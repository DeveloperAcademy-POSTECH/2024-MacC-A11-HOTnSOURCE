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
    // 현재 사용자의 dB
    @Published var decibelLevel: Float = 0.0
    
    // 현재 소음 측정 상황
    @Published var isMetering: Bool = false
    
    // 배경 소음에 비해, 증가된 Loudness 비율
    @Published var loudnessIncreaseRatio: Float = 0.0
    
    // 현재 사용자의 소음 상태
    @Published var userNoiseStatus: NoiseStatus = .safe
    
    private let audioRecorder: AVAudioRecorder
    private let decibelMeteringTimeInterval: TimeInterval = 0.1
    private let decibelBufferSize: Int = 5 // 0.5초 간의 소리로 데시벨을 갱신
    private let loudnessBufferSize: Int = 4 // 2초 지속됐을 경우 위험도를 갱신
    
    // 현 시점의 사용자의 dB; 0.1초 간격으로 측정
    private var currentDecibel: Float = 0.0
    
    // 소리 갱신을 위한 타이머; 주변 소음 측정 및, 현재 소음 측정에 이용
    private var timer: Timer?
    
    // 현재 사용자의 dB을 계산하기 위해 실시간 dB를 저장해두는 버퍼
    private var decibelBuffer: [Float] = []
    
    // 위험치를 계산하기 위해 loudness를 저장해두는 버퍼
    private var loudnessBuffer: [Float] = []
    
    
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
    /// 해당 장소의 소음 측정을 시작합니다.
    func startMetering(place: Place) throws {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .measurement, options: [.mixWithOthers, .allowBluetoothA2DP])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("오디오 세션을 설정하는 중 오류 발생")
            throw error
        }
        
        // 측정 시작
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        isMetering = true
        
        // 타이머 설정
        timer = Timer.scheduledTimer(withTimeInterval: decibelMeteringTimeInterval, repeats: true) { _ in
            self.updateDecibelLevel()
            self.calculateLoudnessForDistance(backgroundDecibel: place.backgroundDecibel, distance: place.distance)
        }
    }
    
    /// 배경의 평균 소음을 측정합니다.
    func meteringBackgroundNoise(completion: @escaping (Float) -> Void) throws {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .measurement, options: [.mixWithOthers, .allowBluetoothA2DP])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("오디오 세션을 설정하는 중 오류 발생")
            throw error
        }

        // 측정 시작
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        
        // 측정 데이터 저장용 변수
        var decibelSum: Float = 0.0
        var measurementCount: Int = 0
        
        // 3초간 소음을 측정하기 위한 타이머 (0.1초 간격으로 데시벨 측정)
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            // 데시벨 값 갱신
            self.audioRecorder.updateMeters()
            let dBFSDecibel = self.audioRecorder.averagePower(forChannel: 0)
            let splDecibel = self.convertToSPL(dBFS: dBFSDecibel)
            
            // 측정된 데시벨 값의 합계를 저장하고 측정 횟수를 증가시킴
            decibelSum += splDecibel
            measurementCount += 1
            
            // 3초(30회) 경과 후 평균값 계산 및 리턴
            if measurementCount >= 30 { // 0.1초 간격으로 3초간 측정(총 30회)
                let averageDecibel = decibelSum / Float(measurementCount)
                
                // 타이머 종료
                timer.invalidate()
                
                // 측정 종료
                audioRecorder.isMeteringEnabled = false
                audioRecorder.stop()
                
                // 측정 완료 후 평균값을 completion 핸들러로 전달
                completion(averageDecibel)
            }
        }
    }
    
    /// 소음 측정을 일시정지합니다.
    func pauseMetering() {
        if isMetering {
            audioRecorder.pause()
            isMetering = false
    
            decibelLevel = 0.0
            currentDecibel = 0.0
            decibelBuffer.removeAll()
            
            timer?.invalidate()
        }
    }
    
    /// 소음 측정을 재개합니다.
    func resumeMetering(backgroundDecibel: Float, distance: Float) {
        if !isMetering {
            audioRecorder.record()
            isMetering = true
            
            // 타이머 설정
            timer = Timer.scheduledTimer(withTimeInterval: decibelMeteringTimeInterval, repeats: true) { _ in
                self.updateDecibelLevel()
                self.calculateLoudnessForDistance(backgroundDecibel: backgroundDecibel, distance: distance)
            }
        }
    }
    
    /// 소음 측정을 정지합니다.
    func stopMetering() {
        if isMetering {
            audioRecorder.isMeteringEnabled = false
            audioRecorder.stop()
            isMetering = false
            
            decibelLevel = 0.0
            currentDecibel = 0.0
            decibelBuffer.removeAll()
            
            timer?.invalidate()
        }
    }
    
    
    // MARK: internal methods
    /// 데시벨 레벨을 갱신합니다.
    private func updateDecibelLevel() {
        audioRecorder.updateMeters()
        // 마이크로 수음한 소리 레벨
        let dBFSDecibel = audioRecorder.averagePower(forChannel: 0)
        
        // 음압 레벨(dB SPL)로 변환
        let splDecibel = convertToSPL(dBFS: dBFSDecibel)
        
        // 버퍼에 값을 저장
        decibelBuffer.append(splDecibel)
        
        // 현재 소리 받아오기
        currentDecibel = splDecibel
        
        // 버퍼가 가득차면, 평균치를 계산하여 업데이트
        if decibelBuffer.count == decibelBufferSize {
            let bufferAverage = decibelBuffer.reduce(0, +) / Float(decibelBuffer.count)
            decibelLevel = bufferAverage
            
            decibelBuffer.removeAll() // 초기 위치에 다시 저장, 새로운 메모리 할당하지 않음
        }
    }
    
    /// 사용자가 발생한 소리로부터 일정 거리로 떨어진 상대방이 들리는 최종적인 Loudness 계산
    private func calculateLoudnessForDistance(backgroundDecibel: Float, distance: Float) {
        // 1. 배경 소음의 Loudness 계산
        let backgroundLoudness = convertToLoudness(decibel: backgroundDecibel)
        
        // 2. 상대방이 느끼는 소음 (사용자가 내는 소음의 거리 감쇠 적용)
        let distanceRatio = distance / 0.5
        let perceivedDecibel = calculateDecibelAtDistance(originalDecibel: decibelLevel, distanceRatio: distanceRatio)
        
        // 3. 배경음과 상대방이 느끼는 소음의 dB 합 계산
        let combinedDecibel = combineDecibels(backgroundDecibel: backgroundDecibel, noiseDecibel: perceivedDecibel)
        
        // 4. 합산된 dB를 Loudness로 변환하여 실제 상대방이 느끼는 소음 수준을 계산
        let combinedLoudness = convertToLoudness(decibel: combinedDecibel)
        
        // 5. 배경 소음 대비 바뀐 최종 비율 계산
        loudnessIncreaseRatio = loudnessRatio(originalLoudness: backgroundLoudness, combinedLoudness: combinedLoudness)
        
        // 6. 증가된 최종 비율에 따라 위험치를 계산
        if loudnessIncreaseRatio > NoiseStatus.loudnessCautionLevel {
            loudnessBuffer.append(loudnessIncreaseRatio)
        } else {
            userNoiseStatus = .safe
            loudnessBuffer.removeAll()
        }
        
        if loudnessBuffer.count >= loudnessBufferSize {
            var isDanger: Bool = true
            for value in loudnessBuffer.suffix(loudnessBufferSize) { // 최근 2초만을 관찰
                if value < NoiseStatus.loudnessDangerLevel {
                    isDanger = false
                }
            }
            userNoiseStatus = isDanger ? .danger : .caution
        }
    }
    
    /// dBFS를 dB SPL로 변환합니다.
    private func convertToSPL(dBFS: Float) -> Float {
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
    /// 40 dB SPL = 1 sone 을 기준으로 변환합니다.
    private func convertToLoudness(decibel: Float) -> Float {
        return pow(2.0, (decibel - 40.0) / 10.0)
    }
    
    /// 사용자가 낸 소리로 인해 실제로 상대방이 기존보다 얼만큼 큰 소리로 느끼는지에 대한 비율을 계산합니다.
    private func loudnessRatio(originalLoudness: Float, combinedLoudness: Float) -> Float {
        return combinedLoudness / originalLoudness
    }
    
    
    // MARK: deinit
    deinit {
        audioRecorder.stop()
        isMetering = false
        
        decibelLevel = 0.0
        currentDecibel = 0.0
        decibelBuffer.removeAll()
        
        timer?.invalidate()
    }
}
