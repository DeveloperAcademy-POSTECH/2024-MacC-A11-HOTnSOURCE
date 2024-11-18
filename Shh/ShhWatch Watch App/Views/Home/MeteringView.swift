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
    @State private var isPaused = false
    
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
    
    private var innerCircleGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: innerCircleColors),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var pausedCircleGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [.gray, .white]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    // MARK: Body
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
    
    // MARK: Subviews
    private var meteringCircles: some View {
        ZStack(alignment: .center) {
            meteringCircle(isGradient: false, scale: isAnimating ? 1.2 : 0.7)
            meteringCircle(isGradient: false, scale: isAnimating ? 1.0 : 0.7)
            meteringCircle(isGradient: true, scale: isAnimating ? 0.8 : 0.7)
        }
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(meteringCircleAnimation) {
                    isAnimating = true
                }
            }
        }
    }
    
    private func meteringCircle(isGradient: Bool, scale: Double) -> some View {
        return Circle()
            // TODO: 더 좋은 방법을 찾으면 AnyShapeStyle 제거 예정
            .fill(isGradient ? AnyShapeStyle(innerCircleGradient) : AnyShapeStyle(outerCircleColor))
            .opacity(isGradient ? 1.0 : 0.2)
            .scaleEffect(scale)
    }
    
    private var meteringPausedCircle: some View {
        Circle()
            .fill(pausedCircleGradient)
            .frame(width: 120)
    }
}
