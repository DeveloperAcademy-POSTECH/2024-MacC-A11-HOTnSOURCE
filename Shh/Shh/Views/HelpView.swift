//
//  HelpView.swift
//  Shh
//
//  Created by Jia Jang on 11/19/24.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        VStack(spacing: 50) {
            VStack(spacing: 20) {
                Spacer().frame(height: 40)
                
                Image(systemName: "lightbulb.max.fill")
                    .font(.largeTitle)
                
                Text("Shh-! 측정 도움말")
                    .font(.title)
                    .bold()
                
                VStack {
                    Text("측정 기준부터 알림까지")
                    Text("궁금할만한 정보를 알아보세요")
                }
                .font(.callout)
            }
            .foregroundStyle(.white)
            // TODO: 임시 코드
            .frame(maxWidth: 1000)
            .background {
                LinearGradient(
                    gradient: Gradient(colors: [.accent, .black]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            
            ScrollView {
                VStack(spacing: 30) {
                    rowElement(
                        systemName: "waveform.badge.microphone",
                        color: .accent,
                        title: "어떻게 측정하나요?",
                        subtitle: "기기 마이크를 사용해서 실시간으로 소음 수준을 확인하며, 배경 소음에 비해서 얼만큼 크게 들리는지 계산해요."
                    )
                    
                    rowElement(
                        systemName: "ring.circle",
                        color: .accent,
                        title: "소음 단계는 어떻게 되나요?",
                        subtitle: "소음 단계는 양호와 위험 두 단계로 이루어져 있어요. 양호일 땐 녹색, 위험일 땐 분홍색으로 소음 단계를 볼 수 있어요."
                    )
                    
                    rowElement(
                        systemName: "speaker.wave.2.fill",
                        color: .accent,
                        title: "최대 소음이 뭔가요?",
                        subtitle: "‘양호’ 수준을 유지하면서 낼 수 있는 소리의 최대 크기예요. 이 이상 큰 소리를 내면 시끄럽다고 느낄 수 있어요."
                    )
                    
                    rowElement(
                        systemName: "bell.badge.fill",
                        color: .pink,
                        title: "알림은 언제 오나요?",
                        subtitle: "소음 단계가 ‘위험’이 되었을 때, 알림이 와요. 또한 ‘위험’이 지속될 경우, 20초마다 알림을 보내요."
                    )
                    
                    rowElement(
                        systemName: "exclamationmark.triangle.fill",
                        color: .pink,
                        title: "언제 ‘위험’이 되나요?",
                        subtitle: "2초 동안 ‘소음'이 지속될 경우 혹은 지나치게 큰 소리가 감지되었을 때, 소음 단계가 ‘위험'이 돼요."
                    )
                }
            }
        }
    }
    
    private func rowElement(systemName: String, color: Color, title: String, subtitle: String) -> some View {
        HStack(spacing: 20) {
            symbolImage(systemName: systemName, color: color)
            rowText(title: title, subtitle: subtitle)
        }
    }
    
    private func rowText(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .foregroundStyle(.white)
            
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .bold()
    }
    
    private func symbolImage(systemName: String, color: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(color)
            
            Image(systemName: systemName)
                .font(.largeTitle)
                .foregroundStyle(.white)
        }
        .frame(width: 90, height: 90)
    }
}

#Preview {
    HelpView()
}
