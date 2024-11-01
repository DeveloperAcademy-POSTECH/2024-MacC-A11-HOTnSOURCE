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
                ControlsView(isAnimating: $isAnimating, selectedLocation: selectedLocation)
                    .tag(MainTabs.controls)
                
                HomeView(isAnimating: $isAnimating, showCountdown: $showCountdown, selectedLocation: selectedLocation)
                    .tag(MainTabs.home)
                
                MeteringInfoView()
                    .tag(MainTabs.info)
            }
            .hidden(showCountdown)
            
            if showCountdown { countdownView }
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
    private var countdownView: some View {
        Text("\(countdown)")
            .font(.system(size: 100, weight: .bold, design: .default))
            .foregroundColor(.customWhite)
            .transition(.opacity)
            .onAppear {
                startCountdown()
            }
    }
    
    // MARK: Functions
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
