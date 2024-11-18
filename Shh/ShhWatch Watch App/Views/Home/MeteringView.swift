//
//  MeteringView.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 11/16/24.
//

import SwiftUI

struct MeteringView: View {
    // MARK: Properties
    @EnvironmentObject var audioManager: AudioManager
    
    @State private var isAnimating = false
    
    private let meteringCircleAnimation = Animation
        .easeInOut(duration: 1.5)
        .repeatForever(autoreverses: true)
    
    private var outerCircleColor: Color {
        audioManager.userNoiseStatus == .safe ? .accent : .indigo
    }
    
    private var innerCircleColors: [Color] {
        if audioManager.userNoiseStatus == .safe {
            return [.accent, .customLime]
        } else {
            return [.indigo, .purple]
        }
    }
    
    var body: some View {
        ZStack {
            meteringCircles
                .hidden(!audioManager.isMetering)
            
            meteringPausedCircle
                .hidden(audioManager.isMetering)
            
            Text(audioManager.userNoiseStatus == .safe ? "양호" : "주의")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.black)
        }
    }
    
    // animation
    private var meteringCircles: some View {
        ZStack(alignment: .center) {
            // 가장 옅은 바깥쪽 원
            Circle()
                .fill(outerCircleColor)
                .opacity(0.2)
                .scaleEffect(isAnimating ? 1.2 : 0.7)
                
            // 중간 원
            Circle()
                .fill(outerCircleColor)
                .opacity(0.2)
                .scaleEffect(isAnimating ? 1.0 : 0.7)

            // 가장 진한 안쪽 원
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: innerCircleColors),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .scaleEffect(isAnimating ? 0.8 : 0.7)
        }
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(meteringCircleAnimation) {
                    isAnimating = true
                }
            }
        }
    }
    
    private var meteringPausedCircle: some View {
        Circle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [.gray, .white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 120)
    }
}
