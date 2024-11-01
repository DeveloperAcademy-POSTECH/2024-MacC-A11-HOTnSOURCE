//
//  HomeView.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 11/1/24.
//

import SwiftUI

// MARK: - 홈 뷰: 메인 뷰의 가운데 탭에서 소음 상태를 나타냄
struct HomeView: View {
    // MARK: Properties
    @EnvironmentObject var audioManager: AudioManager
    @Binding var isAnimating: Bool
    @Binding var showCountdown: Bool
    
    // TODO: 추후 재검토 필요
    let selectedLocation: Location
    
    // Animations
    private let meteringCircleAnimation = Animation
        .easeInOut(duration: 1.5)
        .repeatForever(autoreverses: true)
    
    private var outerCircleColor: Color {
        audioManager.userNoiseStatus == .safe ? .green : .purple
    }
    
    // Colors
    private var innerCircleColors: [Color] {
        if audioManager.userNoiseStatus == .safe {
            return [.green, .yellow, .white]
        } else {
            return [.purple, .blue, .white]
        }
    }
    
    private var pausedCircleGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [.gray, .white]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    private var meteringCircleGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: innerCircleColors),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    // MARK: Body
    var body: some View {
        ZStack {
            homeNavigationTitle
            
            ZStack {
                meteringCircles
                    .hidden(!audioManager.isMetering) // 측정 중일 때
                
                meteringPausedCircle
                    .hidden(audioManager.isMetering) // 측정을 멈추었을 때
                
                Text(audioManager.isMetering ? audioManager.userNoiseStatus.message : "멈춤")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
            }
        }
    }
    
    // MARK: SubViews
    private var homeNavigationTitle: some View {
        VStack {
            HStack {
                Spacer()
                
                Text(selectedLocation.name)
                    .foregroundStyle(.white)
                    .hidden(showCountdown)
                    .padding(.trailing)
            }
            
            Spacer()
        }
    }
    
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
                .fill(meteringCircleGradient)
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
            .fill(pausedCircleGradient)
            .frame(width: 120)
    }
}
