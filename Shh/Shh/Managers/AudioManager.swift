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
    @Published var decibelLevel: Float = 0.0
    @Published var currentDecibel: Float = 0.0
    @Published var isMetering: Bool = false
    
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
            try AVAudioSession.sharedInstance().setCategory(.record, mode: .measurement, options: [.mixWithOthers, .allowBluetooth])
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
    
    /// dBFS를 dB SPL로 변환합니다.
    private func convertToSPL(dBFS: Float) -> Float {
        let splDecibel = dBFS + 100 // 선형 변환으로 가정
        return max(0, splDecibel) // 데시벨 수준이 0보다 낮지 않도록 조정
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
