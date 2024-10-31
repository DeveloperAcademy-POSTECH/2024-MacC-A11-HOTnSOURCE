//
//  BackgroundNoiseInputView.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/30/24.
//

import SwiftUI

// MARK: - 장소 생성 > 배경 소음 측정 화면
struct BackgroundNoiseInputView: View {
    // MARK: Properties
    @EnvironmentObject var audioManager: AudioManager
    
    @Binding var step: CreateLocationStep
    @Binding var backgroundNoise: Float
    @Binding var isMetering: Bool
    
    var isFirstMeteringFinished: Bool {
        return !backgroundNoise.isZero
    }
    
    // MARK: Body
    var body: some View {
        VStack {
            StepDescriptionRow(
                text: "얼마나 시끄러운가요?",
                subText: "측정 기준이 될 현재 장소의 소음을 측정해주세요.\n그보다 더 큰 소리를 내시면 알려드릴게요."
            )
            
            Spacer()
            
            SsambbongAsset(image: .backgroundNoiseInputAsset)
            
            Spacer()
            
            Group {
                if isMetering {
                    LoadingDots()
                } else if isFirstMeteringFinished {
                    backgroundNoiseInfoRow
                } else {
                    Rectangle()
                        .fill(.clear)
                }
            }
            .frame(height: 100)
            
            Spacer()
            Spacer()
            
            VStack(spacing: 12) {
                reMeteringButton
                    .opacity(isFirstMeteringFinished && !isMetering ? 1 : 0)
                
                if isFirstMeteringFinished && !isMetering {
                    NextStepButton(step: $step)
                } else {
                    meteringButton
                }
            }
        }
    }
    
    // MARK: SubViews
    private var backgroundNoiseInfoRow: some View {
        VStack {
            Button {
                // TODO: 인포 화면
            } label: {
                Label("자세한 정보", systemImage: "info.circle")
                    .labelStyle(.iconOnly)
            }
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            Text(Location.decibelWriting(decibel: backgroundNoise))
                .font(.title)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer().frame(height: 8)
            
            Text("정도의 느낌이군요!")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .fontWeight(.bold)
    }
    
    private var reMeteringButton: some View {
        Button {
            meteringBackgroundNoise()
        } label: {
            Label("다시 측정하기", systemImage: "arrow.clockwise")
                .font(.footnote)
                .foregroundStyle(.white)
        }
    }
    
    @ViewBuilder
    private var meteringButton: some View {
        CustomButton(text: isMetering ? "측정 중이에요..." : "측정하기") {
            meteringBackgroundNoise()
        }
        .disabled(isMetering)
    }
    
    // MARK: Action Handlers
    private func meteringBackgroundNoise() {
        isMetering = true
        
        do {
            try audioManager.meteringBackgroundNoise { averageDecibel in
                let unRoundedAverageDecibel = averageDecibel
                
                let roundedDecibel = round(unRoundedAverageDecibel / 5.0) * 5.0
                
                let clampedDecibel = min(max(roundedDecibel, 30.0), 70.0)
                
                backgroundNoise = clampedDecibel
                isMetering = false
            }
        } catch {
            backgroundNoise = 0
            isMetering = false
            print("소음 측정 중 오류 발생: \(error)")
        }
    }
}

// MARK: - Preview
#Preview {
    BackgroundNoiseInputView(step: .constant(.backgroundNoiseInput), backgroundNoise: .constant(0), isMetering: .constant(false))
}
