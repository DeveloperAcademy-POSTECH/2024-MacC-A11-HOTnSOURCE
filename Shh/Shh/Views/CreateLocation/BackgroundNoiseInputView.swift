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
    @Binding var step: CreateLocationStep
    @Binding var backgroundNoise: Float
    
    @State private var isMetering: Bool = false
    @State private var isFirstMeteringFinished: Bool = false
    
    // MARK: Body
    var body: some View {
        VStack {
            descriptionRow
            
            Spacer()
            
            ssambbongAsset
            
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
                    .opacity(isFirstMeteringFinished ? 1 : 0)
                
                if isFirstMeteringFinished {
                    NextStepButton(step: $step)
                } else {
                    meteringButton
                }
            }
        }
        .onChange(of: isMetering) { newValue in
            if newValue {
                isFirstMeteringFinished = true
            }
        }
    }
    
    // MARK: SubViews
    private var descriptionRow: some View {
        VStack(spacing: 10) {
            Text("얼마나 시끄러운가요?")
                .font(.title)
            Text("측정 기준이 될 현재 장소의 소음을 측정해주세요.\n그보다 더 큰 소리를 내시면 알려드릴게요.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .fontWeight(.bold)
    }
    
    private var ssambbongAsset: some View {
        Image(.backgroundNoiseInputAsset)
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
    }
    
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
            
            Text("조용한 카페의 배경 소음")
                .font(.title)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
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
            // TODO: 측정 함수
        } label: {
            Label("다시 측정하기", systemImage: "arrow.clockwise")
                .font(.footnote)
                .foregroundStyle(.white)
        }
    }
    
    private var meteringButton: some View {
        CustomButton(text: "측정하기") {
            // TODO: 측정 함수
            
            withAnimation(.easeInOut(duration: 0.2)) {
                isFirstMeteringFinished = true
            }
        }
    }
}

// MARK: - Preview
#Preview {
    BackgroundNoiseInputView(step: .constant(.backgroundNoiseInput), backgroundNoise: .constant(0))
}
