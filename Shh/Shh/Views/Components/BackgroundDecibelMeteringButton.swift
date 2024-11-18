//
//  BackgroundDecibelMeteringButton.swift
//  Shh
//
//  Created by sseungwonnn on 10/15/24.
//

import SwiftUI

struct BackgroundDecibelMeteringButton: View {
    @EnvironmentObject var audioManager: AudioManager
    
    @Binding var backgroundDecibel: Float
    @Binding var isShowingProgressView: Bool
    
    var body: some View {
        Button {
            isShowingProgressView = true
            // 주변 소음 측정을 시작
            Task {
                do {
                    try await audioManager.meteringBackgroundNoise()
                    
//                    // 측정된 평균 데시벨 값을 반올림하여 30, 35, 40, ..., 70 중 가장 가까운 값으로 저장
//                    let unRoundedBackgroundDecibel = rawBackgroundDecibel
//                    
//                    // 5의 배수로 반올림 (예: 32.69 -> 35, 47.823 -> 50)
//                    let roundedBackgroundDecibel = round(unRoundedBackgroundDecibel / 5.0) * 5.0
//                    
//                    // 30.0 ~ 70.0 사이로 범위를 제한
//                    let clampedBackgroundDecibel = min(max(roundedBackgroundDecibel, 30.0), 70.0)
//                    
//                    backgroundDecibel = clampedBackgroundDecibel
                    isShowingProgressView = false
                } catch {
                    // TODO: 만약 에러가 invalidBackgroundNoise라면 알러트 띄우기
                    backgroundDecibel = 0
                    isShowingProgressView = false
                    print(error)
                }
            }
        } label: {
            Label("주변 소음 측정", systemImage: "mic.circle.fill")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.accent)
        }
    }
}
