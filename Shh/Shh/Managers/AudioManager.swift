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
    // 현재 사용자의 dB; 1초 간의 사용자의 데시밸 평균
    @Published var decibelLevel: Float = 0.0
    
    // 현 시점의 사용자의 dB; 0.1초 간격으로 측정
    @Published var currentDecibel: Float = 0.0
    
    // 현재 수음 상황
    @Published var isMetering: Bool = false
    
    // TODO: 테스트를 위해 @Published로 선언
    // 사용자가 낸 소리가 상대방에게 인지되는 dB; 거리 감쇠 적용
    @Published var perceivedDecibel: Float = 0.0
    
    // 사용자가 낸 소리가 실제로 상대방의 귀에 느껴지는 Loudness 정도
    @Published var perceivedLoudness: Float = 0.0
    
    // 상대방의 실제 귀에 들어가는 Loudness 정도; 배경 소음 + 사용자가 낸 소리
    @Published var combinedLoudnessValue: Float = 0.0
    
    // 배경 소음에 비해, 증가된 Loudness 비율
    @Published var loudnessIncreaseRatio: Float = 0.0
    
    // 배경 소음이 상대방에게 느껴지는 Loudness 정도
    @Published var backgroundLoudness: Float = 0.0

    // TODO: AppStorage 영역에서 받아올 예정
    private var backgroundDecibel: Float = 40.0 // 고정된 배경 소음
    private var distance: Float = 2.0 // 고정된 거리 (2m로 가정)
    
    // TODO: 이 친구들은 장소 모델로 옮길 예정
    let distances: [Float] = [1, 1.5, 2, 2.5, 3]
    let backgroundDecibelOptions: [Float] = [30, 35, 40, 45, 50, 55, 60]
    
    private let audioRecorder: AVAudioRecorder
    
    private var timer: Timer?
    private var buffer: [Float] = []
    
    init?() {
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
            return nil
        }
    }
    
    /// 측정을 시작합니다.
    func startMetering() throws {
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
        
        // 타이머 설정 (0.1초마다 업데이트)
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.updateDecibelLevel()
            self.calculateLoudnessForDistance()
        }
    }
    
    /// 측정을 일시정지합니다.
    func pauseMetering() {
        if isMetering {
            audioRecorder.pause()
            isMetering = false
    
            decibelLevel = 0.0
            currentDecibel = 0.0
            buffer.removeAll()
            
            timer?.invalidate()
        }
    }
    
    /// 측정을 재개합니다.
    func resumeMetering() {
        if !isMetering {
            audioRecorder.record()
            isMetering = true
            
            // 타이머 설정 (0.1초마다 업데이트)
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                self.updateDecibelLevel()
                self.calculateLoudnessForDistance()
            }
        }
    }
    
    /// 측정을 정지합니다.
    func stopMetering() {
        if isMetering {
            audioRecorder.isMeteringEnabled = false
            audioRecorder.stop()
            isMetering = false
            
            decibelLevel = 0.0
            currentDecibel = 0.0
            buffer.removeAll()
            
            timer?.invalidate()
        }
    }
    
    /// 데시벨 레벨을 갱신합니다.
    func updateDecibelLevel() {
        audioRecorder.updateMeters()
        // 마이크로 수음한 소리 레벨
        let dBFSDecibel = audioRecorder.averagePower(forChannel: 0)
        
        // 음압 레벨(dB SPL)로 변환
        let splDecibel = convertToSPL(dBFS: dBFSDecibel)
        
        // 버퍼에 값을 저장 (최대 10개 저장)
        buffer.append(splDecibel)
        
        // 현재 소리 받아오기
        currentDecibel = splDecibel
        
        // 버퍼가 가득차면, 평균치를 계산하여 업데이트
        if buffer.count == 10 {
            let bufferAverage = buffer.reduce(0, +) / Float(buffer.count)
            decibelLevel = bufferAverage
            
            buffer.removeAll() // 초기 위치에 다시 저장, 새로운 메모리 할당하지 않음
        }
    }
    
    /// 사용자가 발생한 소리로 부터 일정 거리로 떨어진 상대방이 들리는 최종적인 Loudeness 계산
    func calculateLoudnessForDistance() {
        // 1. 배경 소음의 Loudness 계산
        backgroundLoudness = loudnessFromDecibel(Float(backgroundDecibel))
        
        // 2. 상대방이 느끼는 소음 (내가 내는 소음의 거리 감쇠 적용)
        let distanceRatio = Float(distance) / 0.5
        perceivedDecibel = calculateDecibelAtDistance(originalDecibel: Float(decibelLevel), distanceRatio: distanceRatio)
        
        perceivedLoudness = loudnessFromDecibel(perceivedDecibel)
        
        // 3. 합산된 Loudness 계산
        combinedLoudnessValue = combinedLoudness(backgroundLoudness: backgroundLoudness, noiseLoudness: perceivedLoudness)
        
        // 4. 배경 소음 대비 바뀐 최종 비율 계산
        loudnessIncreaseRatio = loudnessRatio(originalLoudness: backgroundLoudness, combinedLoudness: combinedLoudnessValue)
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
    
    // TODO: 거리 선택지가 정해져 있기에, 이는 추후에 Place 모델로 옮길 예정
    /// 거리에 따라 감소되어 상대방이 느끼는 음압 레벨(dB SPL)을 역제곱 법칙을 통해 계산합니다.
    private func calculateDecibelAtDistance(originalDecibel: Float, distance: Float) -> Float {
        var decibelLoss: Float = 0.0
        
        switch distance {
        case 1.0:
            decibelLoss = 6.02
        case 1.5:
            decibelLoss = 9.54
        case 2.0:
            decibelLoss = 12.04
        case 2.5:
            decibelLoss = 13.98
        case 3.0:
            decibelLoss = 15.56
        default:
            decibelLoss = 0.0 // 기본값으로 처리
        }
        
        return originalDecibel - decibelLoss
    }

    /// Loudness 계산 함수입니다.
    /// 40 dB SPL = 1 sone
    private func loudnessFromDecibel(_ decibel: Float) -> Float {
        return pow(2.0, (decibel - 40.0) / 10.0)
    }
    
    /// 상대방이 실제로 느끼는 소리 크기를 계산합니다.
    /// 배경 소음과 사용자가 내는 소음을 합산하여 계산합니다.
    private func combinedLoudness(backgroundLoudness: Float, noiseLoudness: Float) -> Float {
        return sqrt(pow(backgroundLoudness, 2) + pow(noiseLoudness, 2))
    }
    
    /// 사용자가 낸 소리로 인해 실제로 상대방이 기존보다 얼만큼 큰 소리로 느끼는지에 대한 비율을 계산합니다.
    private func loudnessRatio(originalLoudness: Float, combinedLoudness: Float) -> Float {
        return combinedLoudness / originalLoudness
    }
    
    deinit {
        audioRecorder.stop()
        isMetering = false
        
        decibelLevel = 0.0
        currentDecibel = 0.0
        buffer.removeAll()
        
        timer?.invalidate()
    }
}
