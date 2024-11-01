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
    
    @State private var tabSelection: MainTabs = .home
    
    @State private var countdownTimer: Timer?
    @State private var showCountdown = true
    @State private var countdown = 3
    
    @State private var isAnimating = false
    
    let selectedLocation: Location
    
    // MARK: Body
    var body: some View {
        ZStack {
            TabView(selection: $tabSelection) {
                controlsView
                    .tag(MainTabs.controls)
                
                HomeView(isAnimating: $isAnimating)
                    .tag(MainTabs.home)
                
                MeteringInfoView()
                    .tag(MainTabs.info)
            }
            .hidden(showCountdown)
            
            if showCountdown {
                countdownView
            }
        }
        .navigationTitle {
            Text(showCountdown ? "" : selectedLocation.name)
                .foregroundStyle(.white)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            do {
                try audioManager.setAudioSession()
            } catch {
                print("오디오 세션 설정 중에 문제가 발생했습니다.")
                routerManager.pop()
            }
        }
        .onChange(of: audioManager.userNoiseStatus) { oldValue, newValue in
            if oldValue == .safe && newValue == .caution {
                Task {
                    WKInterfaceDevice.current().play(.notification) // 햅틱 재생
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
