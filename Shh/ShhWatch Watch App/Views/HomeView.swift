//
//  ContentView.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 10/30/24.
//

import SwiftUI

enum MainTabs {
    case controls, home, info
}

// MARK: - 홈 뷰: Controls, Metering, Info View로 구성
struct HomeView: View {
    // MARK: Properties
    @State private var tabSelection: MainTabs = .home
    @State private var isAnimating = false
    
    // TODO: 기능 구현하고 나서 실제 데이터로 변경 예정
    @State private var isMetering = true
    @State private var noiseStatus = "safe"
    
    private let meteringCircleAnimation = Animation
        .easeInOut(duration: 1.5)
        .repeatForever(autoreverses: true)
    
    private var outerCircleColor: Color {
        noiseStatus == "safe" ? .accent : .indigo
    }
    
    private var innerCircleColors: [Color] {
        if noiseStatus == "safe" {
            return [.accent, .customLime]
        } else {
            return [.indigo, .purple]
        }
    }
    
    // MARK: Body
    var body: some View {
        TabView(selection: $tabSelection) {
            controlsView
                .tag(MainTabs.controls)
            
            meteringView
                .tag(MainTabs.home)
            
            MeteringInfoView()
                .tag(MainTabs.info)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: SubViews
    private var controlsView: some View {
        HStack {
            meteringStopButton
            meteringToggleButton
        }
        .frame(maxWidth: 150)
    }
    
    private var meteringStopButton: some View {
        VStack {
            Button {
                // router.pop()
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            // TODO: button color가 어둡게 나오는 이슈 발생. 해결방안을 찾기 전까지 opacity로 임시 대처.
            .buttonStyle(BorderedButtonStyle(tint: Color.red.opacity(10)))
            
            Text("종료")
        }
    }
    
    private var meteringToggleButton: some View {
        VStack {
            Button {
                // TODO: 재확인 필요 (audioManger.isMetering으로 변경 예정)
                isMetering.toggle()
            } label: {
                Image(systemName: isMetering ? "pause.fill" : "play.fill")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            // TODO: button color가 어둡게 나오는 이슈 발생. (opacity로 임시 대처)
            .buttonStyle(BorderedButtonStyle(tint: .accent.opacity(isMetering ? 2 : 10)))
            
            Text(isMetering ? "일시정지" : "재개")
        }
    }
    
    private var meteringView: some View {
        ZStack {
            meteringCircles
                .hidden(!isMetering) // 측정 중일 때
            
            meteringPausedCircle
                .hidden(isMetering) // 측정을 멈추었을 때
            
            Text(noiseStatus == "safe" ? "양호" : "주의")
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

#Preview {
    HomeView()
}