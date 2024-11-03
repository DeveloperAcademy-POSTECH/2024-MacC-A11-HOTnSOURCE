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
    
    @State private var showBackgroundNoiseInfo: Bool = false
    
    var isFirstMeteringFinished: Bool {
        return !backgroundNoise.isZero
    }
    
    // MARK: Body
    var body: some View {
        ZStack {
            Color.customBlack
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                StepDescriptionRow(
                    text: step.text,
                    subText: step.subText
                )
                
                Spacer(minLength: 30)
                
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
                
                Spacer(minLength: 16)
                
                VStack(spacing: 12) {
                    reMeteringButton
                        .hidden(!isFirstMeteringFinished || isMetering)
                    
                    if isFirstMeteringFinished && !isMetering {
                        NextStepButton(step: $step)
                    } else {
                        meteringButton
                    }
                }
            }
        }
        .sheet(isPresented: $showBackgroundNoiseInfo) {
            backgroundNoiseInfoSheet
                .presentationDragIndicator(.visible)
                .presentationDetents([.medium])
        }
    }
    
    // MARK: SubViews
    private var backgroundNoiseInfoRow: some View {
        VStack {
            Button {
                showBackgroundNoiseInfo = true
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
    
    private var meteringButton: some View {
        CustomButton(text: isMetering ? "측정 중이에요..." : "측정하기") {
            meteringBackgroundNoise()
        }
        .disabled(isMetering)
    }
    
    private var backgroundNoiseInfoSheet: some View {
        VStack {
            Text("배경 소음 예시")
            
            List {
                ForEach(Location.backgroundDecibelOptions, id: \.self) { decibel in
                    HStack(spacing: 20) {
                        Text("\(Int(decibel)) dB")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        
                        Text(Location.decibelWriting(decibel: decibel))
                            .foregroundStyle(decibel == backgroundNoise ? .accent : .customWhite)
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                }
            }
        }
        .padding()
        .fontWeight(.bold)
    }
    
    // MARK: Action Handlers
    private func meteringBackgroundNoise() {
        isMetering = true
        
        do {
            try audioManager.meteringBackgroundNoise { averageDecibel in
                guard let averageDecibel = averageDecibel else {
                    isMetering = false
                    return
                }
                
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
