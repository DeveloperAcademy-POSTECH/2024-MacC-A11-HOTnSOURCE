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
        audioManager.userNoiseStatus == .safe ? .accent : .pink
    }
    
    private var innerCircleColors: [Color] {
        if audioManager.userNoiseStatus == .safe {
            return [.accent, .linearGreen]
        } else {
            return [.pink, .linearPink]
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
                .accessibilityHint("\(audioManager.userNoiseStatus) 상태를 \(audioManager.userNoiseStatus == .safe ? "초록색" : "분홍색")으로 나타내고 있습니다.")
            
            meteringPausedCircle
                .hidden(audioManager.isMetering)
                .accessibilityHint("일시정지된 상태입니다.")
            
            Text(audioManager.isMetering ? (audioManager.userNoiseStatus == .safe ? "양호" : "위험") : "멈춤")
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
