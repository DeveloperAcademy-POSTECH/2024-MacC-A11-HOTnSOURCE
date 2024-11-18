////
////  BackgroundNoiseInputView.swift
////  Shh
////
////  Created by Eom Chanwoo on 10/30/24.
////
//
//import SwiftUI
//
//// MARK: - 장소 생성 > 배경 소음 측정 화면
//struct BackgroundNoiseInputView: View {
//    // MARK: Properties
//    @EnvironmentObject var audioManager: AudioManager
//    
//    @Binding var step: CreateLocationStep
//    @Binding var backgroundNoise: Float
//    @Binding var isMetering: Bool
//    
//    @State private var showBackgroundNoiseInfo: Bool = false
//    
//    var isFirstMeteringFinished: Bool {
//        return !backgroundNoise.isZero
//    }
//    
//    // MARK: Body
//    var body: some View {
//        ZStack {
//            Color.customBlack
//                .edgesIgnoringSafeArea(.all)
//            
//            VStack {
//                StepDescriptionRow(
//                    text: step.text,
//                    subText: step.subText
//                )
//                
//                Spacer(minLength: 30)
//                
//                SsambbongAsset(image: .backgroundNoiseInputAsset)
//                
//                Spacer()
//                
//                Group {
//                    if isMetering {
//                        LoadingDots()
//                    } else if isFirstMeteringFinished {
//                        backgroundNoiseInfoRow
//                    } else {
//                        Rectangle()
//                            .fill(.clear)
//                    }
//                }
//                .frame(height: 100)
//                
//                Spacer(minLength: 16)
//                
//                VStack(spacing: 12) {
//                    reMeteringButton
//                        .hidden(!isFirstMeteringFinished || isMetering)
//                    
//                    if isFirstMeteringFinished && !isMetering {
//                        NextStepButton(step: $step)
//                    } else {
//                        meteringButton
//                    }
//                }
//            }
//        }
//        .sheet(isPresented: $showBackgroundNoiseInfo) {
//            BackgroundNoiseInfoSheet(backgroundNoise: backgroundNoise)
//        }
//    }
//    
//    // MARK: SubViews
//    private var backgroundNoiseInfoRow: some View {
//        VStack {
//            Button {
//                showBackgroundNoiseInfo = true
//            } label: {
//                Label("자세한 정보", systemImage: "info.circle")
//                    .labelStyle(.iconOnly)
//            }
//            .foregroundStyle(.secondary)
//            .frame(maxWidth: .infinity, alignment: .trailing)
//            
//            Text(Location.decibelWriting(decibel: backgroundNoise))
//                .font(.title)
//                .lineLimit(3)
//                .multilineTextAlignment(.center)
//                .fixedSize(horizontal: false, vertical: true)
//            
//            Spacer().frame(height: 8)
//            
//            Text("정도의 느낌이군요!")
//                .font(.footnote)
//                .foregroundStyle(.secondary)
//                .multilineTextAlignment(.center)
//        }
//        .fontWeight(.bold)
//    }
//    
//    private var reMeteringButton: some View {
//        MeteringBackgroundNoiseButton(backgroundNoise: $backgroundNoise, isMetering: $isMetering, meteringAction: audioManager.meteringBackgroundDecibel) {
//            Label("다시 측정하기", systemImage: "arrow.clockwise")
//                .font(.footnote)
//                .foregroundStyle(.white)
//        }
//    }
//    
//    private var meteringButton: some View {
//        MeteringBackgroundNoiseButton(backgroundNoise: $backgroundNoise, isMetering: $isMetering, meteringAction: audioManager.meteringBackgroundDecibel) {
//            Text(isMetering ? "측정 중이에요..." : "측정하기")
//                .font(.body)
//                .fontWeight(.bold)
//                .foregroundStyle(.white)
//                .frame(maxWidth: .infinity)
//                .frame(height: 60)
//                .background(
//                    RoundedRectangle(cornerRadius: 18)
//                        .foregroundStyle(.accent)
//                )
//                .accessibilityLabel("배경 소음 측정")
//        }
//    }
//}
//
//// MARK: - Preview
//#Preview {
//    BackgroundNoiseInputView(step: .constant(.backgroundNoiseInput), backgroundNoise: .constant(0), isMetering: .constant(false))
//}
