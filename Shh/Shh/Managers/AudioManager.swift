//
//  AudioManager.swift
//  Shh
//
//  Created by sseungwonnn on 10/10/24.
//

import AVFoundation
import SwiftUI

// MARK: - 소음을 측정하고 불러오는 역할을 합니다.
final class AudioManager: ObservableObject {
    // MARK: Properties
    // 현재 소음 측정 상황
    @Published var isMetering: Bool = false
    
    // 현재 사용자의 dB
    @Published var userDecibel: Float = 0.0 // 0.1초마다 갱신
    
    // 사용자의 dB를 저장해두는 버퍼; 소음 수준 갱신과 실시간 현황에 사용됨
    @Published var userDecibelBuffer: [Float] = []
    
    // 현재 사용자의 소음 상태
    @Published var userNoiseStatus: NoiseStatus = .safe
    
    // 배경 dB
    var backgroundDecibel: Float = 0.0
    
    // 최대 dB; 배경 dB가 변경되면 변경됨
    var maximumDecibel: Int {
        calculateMaximumDecibel()
    }
    
    private let audioRecorder: AVAudioRecorder
    
    private let distanceFromOthers: Float = 1.0 // 유저와 상대방과의 거리는 1.0 미터로 가정
    private let distanceFromPhone: Float = 0.5 // 유저와 휴대전화 사이의 거리는 0.5 미터로 가정
    
    private let decibelMeteringTimeInterval: TimeInterval = 0.1
    private let userNoiseStatusUpdateTimeInterval: TimeInterval = 2 // 2초마다 사용자의 소음 상태를 갱신
    private var bufferWindowSize: Int {
        Int(userNoiseStatusUpdateTimeInterval / decibelMeteringTimeInterval) // 소음 상태 버퍼 윈도우 크기; 2초 / 0.1초 = 20
    }
    private let userDecibelBufferSize: Int = 1000
    
    private let backgroundDecibelMeteringTimeInterval: TimeInterval = 0.1
    private let backgroundDecibelMeteringTime: Int = 3 // 3초 간의 소리를 받아와 배경 소음을 갱신
    private let validationConstant: Float = 1.5 // 현재 소음이 평균 소음보다 얼만큼 더 커도 되는지; 튀는 값 찾기 위해 사용

    // 소리 갱신을 위한 타이머; 주변 소음 측정 및, 현재 소음 측정에 이용
    private var timer: Timer?
    
    // 소음 측정을 시작한 적이 있는지; 라이브 액티비티에 활용
    private var haveStartedMetering: Bool = false
    
    // MARK: init
    init() throws {
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatAppleLossless),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1
        ]

        let url = URL(fileURLWithPath: "/dev/null") // 데이터를 저장하지 않음.

        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
        } catch {
            print("오디오 레코더를 설정하는 중 오류 발생")
            throw error
        }
    }
    
    // MARK: Methods
    /// 오디오 세션을 설정합니다.
    /// 소음 측정 전 단계에 항상 실행해줘야 하는 메서드입니다.
    func setAudioSession() throws {
        print(#function)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .measurement, options: [.mixWithOthers, .allowBluetoothA2DP])
            try AVAudioSession.sharedInstance().setActive(true)
            try AVAudioSession.sharedInstance().setAllowHapticsAndSystemSoundsDuringRecording(true)
        } catch {
            print("오디오 세션을 설정하는 중 오류 발생")
            throw AudioManagerError.audioSessionDeinitialized
        }
    }
    
    /// 마이크 권한 상태를 확인합니다.
    func checkMicrophonePermissionStatus() -> Bool {
        let permissionStatus = AVAudioApplication.shared.recordPermission
        switch permissionStatus {
        case .granted:
            print("마이크 권한이 이미 허용되었습니다.")
            return true
        case .denied:
            print("마이크 권한이 거부되었습니다.")
            return false
        case .undetermined:
            print("마이크 권한이 아직 결정되지 않았습니다.")
            return false
        @unknown default:
            print("알 수 없는 권한 상태입니다.")
            return false
        }
    }
    
    /// 마이크 권한을 요청합니다.
    func requestMicrophonePermission() async {
        let granted = await AVAudioApplication.requestRecordPermission()
        
        if granted {
            print("마이크 권한을 요청한 결과 허용되었습니다.")
        } else {
            print("마이크 권한을 요청한 결과 거부되었습니다.")
        }
    }
    
    /// 배경의 평균 소음을 측정합니다.
    /// 해당 함수 호출 전에 setAudioSession() 메서드를 호출해야 합니다. View의 .onAppear()를 활용하면 됩니다.
    func meteringBackgroundDecibel() async throws {
        print(#function)
        // 권한 검사
        guard checkMicrophonePermissionStatus() else {
            Task {
                await requestMicrophonePermission()
            }
            throw AudioManagerError.permissionDenied
        }

        // 측정 시작
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        
        // 배경 소음 수음
        var tempDecibelBuffer: [Float] = []
        let tempDecibelBufferMaxSize: Int = Int(Double(backgroundDecibelMeteringTime) / decibelMeteringTimeInterval.magnitude) // 3초 / 0.1초 = 30
        
        // 0.1초 간격으로 측정; 총 30회
        for _ in 0..<tempDecibelBufferMaxSize {
            // 비동기적으로 일정 시간 대기
            try await Task.sleep(nanoseconds: UInt64(decibelMeteringTimeInterval * 1_000_000_000))
            
            audioRecorder.updateMeters()
            let dBFSDecibel = audioRecorder.averagePower(forChannel: 0)
            let splDecibel = convertToSPL(dBFS: dBFSDecibel)
            
            tempDecibelBuffer.append(splDecibel)
        }
        
        // 측정 종료
        audioRecorder.isMeteringEnabled = false
        audioRecorder.stop()
        
        // 배경 소음 수음값의 평균 계산
        let decibelAverage = tempDecibelBuffer.reduce(0, +) / Float(tempDecibelBuffer.count)
        
        // 평균값이 배경 소음으로 유효한지 검사
        let isValid = tempDecibelBuffer.allSatisfy { $0 <= validationConstant * decibelAverage }
        
        guard isValid else {
            throw AudioManagerError.invalidBackgroundNoise
        }
        
        // 값 갱신은 메인 스레드에서
        backgroundDecibel = decibelAverage
    }
    
    /// 내 소리가 시끄러운지 소음 측정을 시작합니다.
    /// 해당 함수 호출 전에 setAudioSession() 메서드를 호출해야 합니다. View의 .onAppear()를 활용하면 됩니다.
    func startMetering(backgroundDecibel: Float) {
        print(#function)
        // 권한 검사
        guard checkMicrophonePermissionStatus() else {
            Task {
                await requestMicrophonePermission()
            }
            return
        }
        
        // 측정 시작
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        isMetering = true
        
        // 라이브 액티비티
        if !haveStartedMetering { // 최초 시작
            // TODO: 임시로 비활성화
            LiveActivityManager.shared.startLiveActivity(isMetering: self.isMetering)
            
            haveStartedMetering = true // 이제 최초 실행이 아님
        } else {
            Task { // 재개; 해당 동작은 업데이트
                await LiveActivityManager.shared.updateLiveActivity(isMetering: self.isMetering)
            }
        }
        
        var userDecibelBufferCounter: Int = 0 // 데시벨 갱신과 소음 상태 갱신을 별도로 진행
        
        // 타이머 설정
        timer = Timer.scheduledTimer(withTimeInterval: decibelMeteringTimeInterval, repeats: true) { _ in
            // 실시간 데시벨 갱신
            self.updateUserDecibel()
            
            // 소음 상태 갱신
            if userDecibelBufferCounter % self.bufferWindowSize == 0 { // 윈도우 끝에 도달하면
                self.updateUserNoiseStatus()
            }
            
            userDecibelBufferCounter += 1
            
            // 버퍼 크기 관리
            if self.userDecibelBuffer.count >= self.userDecibelBufferSize {
                self.userDecibelBuffer.removeFirst(self.bufferWindowSize) // 버퍼에서 20개씩 제거
                userDecibelBufferCounter -= self.bufferWindowSize // 제거한 데이터만큼 카운터도 20 감소
            }
        }
    }
    
    /// 소음 측정을 일시정지합니다.
    func pauseMetering() {
        print(#function)
        audioRecorder.pause()
        
        isMetering = false
        initializeProperties() // 데시벨 관련 프로퍼티 초기화
        
        // 라이브 액티비티 갱신
        Task {
            await LiveActivityManager.shared.updateLiveActivity(isMetering: self.isMetering)
        }
        
        NotificationManager.shared.removeAllNotifications()
        
        timer?.invalidate()
    }
    
    /// 소음 측정을 정지합니다.
    func stopMetering() {
        print(#function)
        audioRecorder.isMeteringEnabled = false
        audioRecorder.stop()
        
        isMetering = false
        haveStartedMetering = false
        initializeProperties() // 프로퍼티 초기화
        
        LiveActivityManager.shared.endLiveActivity() // 라이브 액티비티 종료
        
        NotificationManager.shared.removeAllNotifications()
        
        timer?.invalidate()
    }
    
    // MARK: Internal methods
    // 최대 dB을 계산합니다.
    private func calculateMaximumDecibel() -> Int {
        // 0. 결괏값
        var returnValue: Int = 0
        
        // 1. 분모에 해당하는 배경 소음의 Loudness 계산
        let backgroundLoudness = convertToLoudness(decibel: backgroundDecibel)
        
        // 2. 분자에 해당하는 상대방이 느끼는 Loudness 계산
        let distanceRatio: Float = distanceFromOthers / distanceFromPhone
        var perceivedDecibel: Float = 0.0
        var combinedDecibel: Float = 0.0
        var combinedLoudness: Float = 0.0
        
        for tempDecibel in Int(backgroundDecibel)..<120 { // 최대 120dB까지 탐색
            // 2-1. 상대방이 느끼는 dB 계산(사용자에 의해 생긴 dB)
            perceivedDecibel = calculateDecibelAtDistance(originalDecibel: Float(tempDecibel), distanceRatio: distanceRatio)
            
            // 2-2. 합산된 데시벨 계산(배경 dB + 사용자 dB)
            combinedDecibel = combineDecibels(backgroundDecibel: backgroundDecibel, noiseDecibel: perceivedDecibel)
            
            // 2-3. 상대방이 느끼는 Loudness 계산
            combinedLoudness = convertToLoudness(decibel: combinedDecibel)
            
            // 3. 사용자가 낼 수 있는 dB 최댓값 찾기
            if combinedLoudness >= NoiseStatus.loudnessCautionLevel * backgroundLoudness {
                returnValue = tempDecibel
                break
            }
        }
        
        return returnValue
    }
    
    /// 사용자 dB을 갱신합니다.
    private func updateUserDecibel() {
        audioRecorder.updateMeters()
        // 마이크로 수음한 소리 레벨
        let dBFSDecibel = audioRecorder.averagePower(forChannel: 0)
        
        // 음압 레벨(dB SPL)로 변환
        let splDecibel = convertToSPL(dBFS: dBFSDecibel)
        
        userDecibel = splDecibel // 데시벨 갱신
        userDecibelBuffer.append(userDecibel)
    }
    
    /// 사용자 소음 상태를 갱신합니다.
    private func updateUserNoiseStatus() {
        let startIndex = self.userDecibelBuffer.count - self.bufferWindowSize
        
        guard startIndex >= 0 else { return }
        
        let lastWindowDecibels = self.userDecibelBuffer[startIndex..<self.userDecibelBuffer.count] // 0~19, 20~39, 40~59 등 20개씩 끊은 것 중에서 마지막 윈도우에 해당하는 값
        let userDecibelAverage: Float = lastWindowDecibels.reduce(0, +) / Float(lastWindowDecibels.count)
        
        if Int(userDecibelAverage) > self.maximumDecibel {
            self.userNoiseStatus = .caution
        } else {
            self.userNoiseStatus = .safe
        }
    }
    
    /// 측정이 멈출 때, 값들을 초기화합니다.
    private func initializeProperties() {
        userDecibel = 0.0
        userDecibelBuffer.removeAll()
    }
    
    // MARK: deinit
    deinit {
        audioRecorder.stop()
        isMetering = false
        
        userDecibel = 0.0
        userDecibelBuffer.removeAll()
        
        timer?.invalidate()
    }
}

enum AudioManagerError: Error {
    case audioSessionDeinitialized // 오디오 세션이 설정 안 됐을 때
    case permissionDenied // 마이크 권한이 없을 때
    case invalidBackgroundNoise // 배경 소음이 유효하지 않을 때
}

/// dB 계산에 사용되는 메서드입니다.
extension AudioManager {
    /// dBFS를 dB SPL로 변환합니다.
    private func convertToSPL(dBFS: Float) -> Float {
        // TODO: 기기에 따라 로직 개선
        let splDecibel = dBFS + 100 // 선형 변환으로 가정
        return max(0, splDecibel) // 데시벨 수준이 0보다 낮지 않도록 조정
    }
    
    /// 거리에 따라 감소되어 상대방이 느끼는 음압 레벨(dB SPL)을 역제곱 법칙을 통해 계산합니다.
    private func calculateDecibelAtDistance(originalDecibel: Float, distanceRatio: Float) -> Float {
        let decibelLoss = 20.0 * log10(distanceRatio)
        return originalDecibel - decibelLoss
    }
    
    /// 두 점음원(배경 소음, 사용자가 낸 소음)의 dB 합을 계산합니다.
    private func combineDecibels(backgroundDecibel: Float, noiseDecibel: Float) -> Float {
        // 1. 각각의 dB SPL을 에너지로 변환 (에너지 계산: 10^(dB/10))
        let backgroundEnergy = pow(10, backgroundDecibel / 10)
        let noiseEnergy = pow(10, noiseDecibel / 10)
        
        // 2. 두 에너지를 합산한 후, 다시 dB SPL로 변환
        let totalEnergy = backgroundEnergy + noiseEnergy
        let totalDecibel = 10 * log10(totalEnergy)
        
        return totalDecibel
    }

    /// dB SPL을 Loudness로 변환합니다.
    /// 40 dB SPL = 1 sone 이 기준입니다.
    private func convertToLoudness(decibel: Float) -> Float {
        return pow(2.0, (decibel - 40.0) / 10.0)
    }
    
    /// 사용자가 낸 소리로 인해 실제로 상대방이 기존보다 얼만큼 큰 소리로 느끼는지에 대한 비율을 계산합니다.
    private func loudnessRatio(originalLoudness: Float, combinedLoudness: Float) -> Float {
        return combinedLoudness / originalLoudness
    }
}
