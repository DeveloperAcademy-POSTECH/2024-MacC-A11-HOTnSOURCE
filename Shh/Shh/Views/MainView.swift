//
//  MainView.swift
//  Shh
//
//  Created by sseungwonnn on 10/14/24.
//

import SwiftUI

// MARK: - 메인 뷰; 사용자의 소음 정도를 나타냅니다.
struct MainView: View {
    // MARK: Properties
    @EnvironmentObject var routerManager: RouterManager
    @EnvironmentObject var audioManager: AudioManager
    
    @State private var countdown = 3
    @State private var showCountdown = true
    @State private var countdownTimer: Timer?
    @State private var isMetering = false // 애니메이션 상태 제어를 위해 값 복사
    
    let selectedLocation: Location
    
    private let notificationManager: NotificationManager = .init()
    
    private var outerCircleColor: Color {
        !isMetering
            ? .gray
            : audioManager.userNoiseStatus == .safe
                ? .green
                : .purple
    }
    
    private var innerCircleColors: [Color] {
        if !isMetering {
            return [.gray, .white]
        } else {
            if audioManager.userNoiseStatus == .safe {
                return [.green, .yellow, .white]
            } else {
                return [.purple, .blue, .white]
            }
        }
    }
    
    // MARK: Body
    var body: some View {
        ZStack {
            VStack {
                locationInfo
                
                Spacer()
                
                meteringCircles
                
                Spacer()
                
                HStack(alignment: .center) {
                    userNoiseStatusInfo
                    
                    Spacer()
                    
                    meteringToggleButton
                }
                
                Spacer().frame(height: 20) // 아래 여백
            }
            .padding(.horizontal, 16)
            .opacity(showCountdown ? 0 : 1) // 카운트다운 중에는 보이지 않음
            
            if showCountdown {
                countdownView
            }
        }
        .navigationTitle(selectedLocation.name)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarHidden(showCountdown) // 카운트다운 중에는 보이지 않음
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                toolbarButtons
            }
        }
        .onAppear {
            do {
                try audioManager.setAudioSession()
            } catch {
                // TODO: 문제 발생 알러트 띄우기
                print("오디오 세션 설정 중에 문제가 발생했습니다.")
                routerManager.pop()
            }
            DispatchQueue.main.async {
                isMetering = audioManager.isMetering // 상태에 따라 애니메이션 제어
            }
        }
        .onChange(of: audioManager.userNoiseStatus) { newValue in
            Task {
                if newValue == .caution {
                    await notificationManager.sendNotification()
                }
            }
            DispatchQueue.main.async {
                isMetering = audioManager.isMetering // 상태에 따라 애니메이션 제어
            }
        }
        .onDisappear {
            audioManager.stopMetering()
            stopCountdown()
        }
    }
    
    // MARK: SubViews
    private var meteringCircles: some View {
        ZStack {
            Circle()
                .fill(outerCircleColor)
                .opacity(0.1)
                .scaleEffect(audioManager.isMetering ? 1.8 : 0.9)
                .animation(animateScale(), value: audioManager.isMetering)
                .frame(width: 160)
            
            Circle()
                .fill(outerCircleColor)
                .opacity(0.4)
                .scaleEffect(audioManager.isMetering ? 1.4 : 0.9)
                .animation(animateScale(), value: audioManager.isMetering)
                .frame(width: 160)
            
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: innerCircleColors),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .scaleEffect(audioManager.isMetering ? 1.0 : 0.9)
                .animation(animateScale(), value: audioManager.isMetering)
                .frame(width: 160)
        }
    }
    
    private var locationInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("배경 소음 | \(Int(selectedLocation.backgroundDecibel)) dB")
                
                Text("측정 반경 | \(String(format: "%.1f", selectedLocation.distance)) m")
            }
            .font(.body)
            .fontWeight(.regular)
            .foregroundStyle(.gray)
            
            Spacer()
        }
    }
    
    private var userNoiseStatusInfo: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(audioManager.isMetering ? audioManager.userNoiseStatus.message : "일시정지됨")
                .font(.system(size: 56, weight: .bold, design: .default))
                .fontWeight(.bold)
                .foregroundStyle(.customWhite)
            
            Text(audioManager.isMetering ? audioManager.userNoiseStatus.writing : "측정을 다시 시작해주세요")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundStyle(.customWhite)
        }
    }
    
    private var meteringToggleButton: some View {
        Button {
            audioManager.isMetering ? audioManager.pauseMetering() : audioManager.startMetering(location: selectedLocation)
        } label: {
            Image(systemName: audioManager.isMetering ? "pause.fill" : "play.fill")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.customWhite)
                .padding(.horizontal, 21)
                .padding(.vertical, 16)
                .background {
                    Circle()
                        .fill(.customBlack)
                }
        }
        .accessibilityLabel(audioManager.isMetering ? "Pause metering" : "Resume metering")
        .accessibilityHint("Starts or pauses noise metering")
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
    
    private var toolbarButtons: some View {
        HStack(alignment: .center) {
            Button {
                routerManager.push(view: .editLocationView(location: selectedLocation))
            } label: {
                Text("수정")
                    .font(.body)
                    .fontWeight(.regular)
            }
            
            Button {
                routerManager.push(view: .meteringInfoView)
            } label: {
                Label("정보", systemImage: "info.circle")
                    .font(.body)
                    .fontWeight(.regular)
            }
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
    
    private func animateScale() -> Animation? {
        audioManager.isMetering
            ? Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)
            : nil // 측정이 멈추면 애니메이션 없음
    }
}
