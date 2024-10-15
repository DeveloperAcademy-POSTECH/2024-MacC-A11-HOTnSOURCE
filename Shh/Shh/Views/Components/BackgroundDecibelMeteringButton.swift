//
//  BackgroundDecibelMeteringButton.swift
//  Shh
//
//  Created by sseungwonnn on 10/15/24.
//

import SwiftUI

struct BackgroundDecibelMeteringButton: View {
    @StateObject private var audioManager: AudioManager = {
        do {
            return try AudioManager()
        } catch {
            fatalError("AudioManager 초기화 실패: \(error.localizedDescription)")
        }
    }()
    
    @Binding var backgroundDecibel: Float
    @Binding var isShowingProgressView: Bool
    
    var body: some View {
        Button {
            isShowingProgressView = true
            // 주변 소음 측정을 시작
            do {
                try audioManager.meteringBackgroundNoise { averageDecibel in
                    // 측정된 평균 데시벨 값을 반올림하여 30, 35, 40, ..., 70 중 가장 가까운 값으로 저장
                    let unRoundedAverageDecibel = averageDecibel
                    
                    // 5의 배수로 반올림 (예: 32.69 -> 35, 47.823 -> 50)
                    let roundedDecibel = round(unRoundedAverageDecibel / 5.0) * 5.0
                    
                    // 30.0 ~ 70.0 사이로 범위를 제한
                    let clampedDecibel = min(max(roundedDecibel, 30.0), 70.0)
                    
                    backgroundDecibel = clampedDecibel
                    isShowingProgressView = false
                }
            } catch {
                backgroundDecibel = 0
                isShowingProgressView = false
                print("소음 측정 중 오류 발생: \(error)")
            }
        } label: {
            Label("주변 소음 측정", systemImage: "mic.circle.fill")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.accent)
        }
    }
}
