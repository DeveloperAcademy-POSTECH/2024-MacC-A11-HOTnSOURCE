//
//  ContentView.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 10/30/24.
//

import SwiftUI

// MARK: - 메인 뷰: Controls, Home, MeteringInfo View로 구성
struct MainView: View {
    // MARK: Properties
    @EnvironmentObject var routerManager: RouterManager
    @EnvironmentObject var audioManager: AudioManager
    
    @State private var countdown = 3
    @State private var showCountdown = true
    @State private var countdownTimer: Timer?
    @State private var tabSelection: MainTabs = .home
    @State private var isAnimating = false
    
    let selectedLocation: Location
    
    private let meteringCircleAnimation = Animation
        .easeInOut(duration: 1.5)
        .repeatForever(autoreverses: true)
    
    private var outerCircleColor: Color {
        audioManager.userNoiseStatus == .safe
        ? .green
        : .purple
    }
    
    private var innerCircleColors: [Color] {
        if audioManager.userNoiseStatus == .safe {
            return [.green, .yellow, .white]
        } else {
            return [.purple, .blue, .white]
        }
    }
    
    // MARK: Body
    var body: some View {
        ZStack {
            TabView(selection: $tabSelection) {
                controlsView
                    .tag(MainTabs.controls)
                
                homeView
                    .tag(MainTabs.home)
                
                MeteringInfoView()
                    .tag(MainTabs.info)
            }
            .hidden(showCountdown)
            
            if showCountdown {
                countdownView
            }
        }
        .navigationTitle(selectedLocation.name)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            do {
                try audioManager.setAudioSession()
            } catch {
                print("오디오 세션 설정 중에 문제가 발생했습니다.")
                routerManager.pop()
            }
        }
        // watchOS 10.0 이후부터 deprecated 경고 -> _, newValue로 표기
        .onChange(of: audioManager.userNoiseStatus) { _, newValue in
            if newValue == .caution {
                Task {
                    WKInterfaceDevice.current().play(.start) // 햅틱 재생
                }
            }
        }
        .onDisappear {
            audioManager.stopMetering()
            stopCountdown()
        }
    }
    
    // MARK: SubViews
    private var controlsView: some View {
        VStack {
            HStack {
                meteringStopButton
                editingButton
            }
            
            meteringToggleButton
        }
        .frame(maxWidth: 150)
    }
    
    private var meteringStopButton: some View {
        VStack {
            Button {
                routerManager.pop()
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            // TODO: button color가 어둡게 나오는 이슈 발생 -> opacity로 임시 대처
            .buttonStyle(BorderedButtonStyle(tint: Color.red.opacity(10)))
            
            Text("종료")
        }
    }
    
    private var meteringToggleButton: some View {
        VStack {
            Button {
                if audioManager.isMetering {
                    audioManager.pauseMetering()
                } else {
                    audioManager.startMetering(location: selectedLocation)
                }
                
                isAnimating.toggle()
            } label: {
                Image(systemName: audioManager.isMetering ? "pause.fill" : "play.fill")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            .buttonStyle(BorderedButtonStyle(tint: Color.green.opacity(audioManager.isMetering ? 2 : 10)))
            
            Text(audioManager.isMetering ? "일시정지" : "재개")
        }
    }
    
    private var editingButton: some View {
        VStack {
            Button {
                routerManager.push(view: .editLocationView)
            } label: {
                Image(systemName: "square.and.pencil")
                    .foregroundStyle(.white)
            }
            
            Text("수정")
        }
    }
    
    private var homeView: some View {
        ZStack {
            meteringCircles
                .hidden(!audioManager.isMetering) // 측정 중일 때
            
            meteringPausedCircle
                .hidden(audioManager.isMetering) // 측정을 멈추었을 때
            
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
    
    private var countdownView: some View {
        Text("\(countdown)")
            .font(.system(size: 100, weight: .bold, design: .default))
            .foregroundColor(.customWhite)
            .transition(.opacity)
            .onAppear {
                startCountdown()
            }
    }
}

extension MainView {
    private func startCountdown() {
        print(#function)
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if countdown > 1 {
                countdown -= 1
            } else {
                stopCountdown()
                
                withAnimation {
                    showCountdown = false
                }
                
                audioManager.startMetering(location: selectedLocation)
            }
        }
    }
    
    private func stopCountdown() {
        print(#function)
        countdownTimer?.invalidate() // 타이머 해지
        countdownTimer = nil
    }
}
