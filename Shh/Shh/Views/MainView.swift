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
    @EnvironmentObject var routerManger: RouterManager
    
    @StateObject private var audioManager: AudioManager = {
        do {
            return try AudioManager()
        } catch {
            fatalError("AudioManager 초기화 실패: \(error.localizedDescription)")
        }
    }()
    
    @State private var isStarted: Bool = false
    @State private var percent = 20.0
    @State private var waveOffset = Angle(degrees: 0)
    
    let selectedPlace: Place
    
    private let waveMotion = Animation
        .linear(duration: 3.5)
        .repeatForever(autoreverses: false)
    
    private let heightAnimation = Animation
        .easeInOut(duration: 0.5)
    
    private var animatableData: Double {
        get { waveOffset.degrees }
        set { waveOffset = Angle(degrees: newValue) }
    }
    
    private let notificationManager: NotificationManager = .init()
    
    // MARK: Body
    var body: some View {
        ZStack {
            content
            beaker
        }
        .background(backgroundWave)
        .navigationTitle(selectedPlace.name)
        .onAppear { startWaveAnimation() }
        .onChange(of: CGFloat(audioManager.loudnessIncreaseRatio)) { loudnessIncreaseRatio in
            changeHeightAnimation(loudness: loudnessIncreaseRatio)
        }
        .onDisappear {
            audioManager.stopMetering()
        }
    }
    
    // MARK: SubViews
    private var content: some View {
        VStack {
            Spacer()
            
            if !audioManager.isMetering {
                VStack(alignment: .center) {
                    Text("아래 버튼을 눌러")
                    Text("측정을 시작해주세요")
                }
                .font(.title2)
                .bold()
                .foregroundStyle(.gray)
                
                Spacer()
                Spacer()
            }
            
            HStack {
                if audioManager.isMetering {
                    userNoiseStatusInfo
                }
                
                Spacer()
                
                VStack(spacing: 14) {
                    if audioManager.isMetering {
                        placeInfo
                    }
                    
                    HStack {
                        meteringToggleButton
                        meteringStopButton
                    }
                    .navigationTitle(selectedPlace.name)
                    .onChange(of: audioManager.userNoiseStatus) { newValue in
                        Task {
                            if let type = newValue.notificationType {
                                await notificationManager.sendNotification(type: type)
                            }
                        }
                    }
                }
            }
            
            Spacer().frame(height: 40)
        }
        .padding(.horizontal, 24)
    }
    
    private var backgroundWave: some View {
        VStack {
            Spacer()
            waveAnimation(percent: percent, waveOffset: waveOffset)
        }
    }
    
    private func waveAnimation(percent: Double, waveOffset: Angle) -> some View {
        Wave(offSet: Angle(degrees: audioManager.isMetering ? waveOffset.degrees : 0.0), percent: audioManager.isMetering ? percent : 20.0)
            .fill(audioManager.isMetering ? audioManager.userNoiseStatus.statusColor : .gray)
            .ignoresSafeArea(.all)
    }
    
    private var beaker: some View {
        VStack {
            Spacer().frame(height: 80)
            
            beakerRow
            Spacer()
            
            beakerRow
            Spacer()
            
            beakerRow
            Spacer()
            Spacer()
        }
    }
    
    private var beakerRow: some View {
        HStack {
            Rectangle()
                .fill(.white)
                .opacity(0.4)
                .frame(width: 27, height: 2)
            
            Spacer()
        }
    }
    
    private var userNoiseStatusInfo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(audioManager.userNoiseStatus.korean)
                .font(.system(size: 56, weight: .bold, design: .default))
                .foregroundStyle(.customWhite)
            
            Text(audioManager.userNoiseStatus.writing)
                .font(.callout)
                .bold()
                .foregroundStyle(.black)
        }
    }
    
    private var placeInfo: some View {
        HStack {
            Text("\(Int(selectedPlace.backgroundDecibel)) dB")
                .font(.body)
                .bold()
                .foregroundStyle(.customWhite)
            
            Rectangle()
                .fill(.customWhite)
                .frame(width: 1, height: 18)
            
            Text("\(Int(selectedPlace.distance)) m")
                .font(.body)
                .bold()
                .foregroundStyle(.customWhite)
        }
    }
    
    private var meteringToggleButton: some View {
        Button {
            if audioManager.isMetering {
                audioManager.pauseMetering()
            } else {
                if !isStarted {
                    do {
                        try audioManager.startMetering(backgroundDecibel: 40.0, distance: 2.0)
                        isStarted = true
                    } catch {
                        // TODO: 재생버튼 다시 눌러달라는 알러트 일단은 팝
                        routerManger.pop()
                    }
                } else {
                    audioManager.resumeMetering(backgroundDecibel: 40.0, distance: 2.0)
                }
            }
        } label: {
            Image(systemName: audioManager.isMetering ? "pause.fill" : "play.fill")
                .font(.title3)
                .bold()
                .foregroundStyle(.customWhite)
                .padding()
                .background {
                    Circle()
                        .fill(.customBlack)
                }
        }
        .accessibilityLabel(audioManager.isMetering ? "Pause metering" : "Resume metering")
        .accessibilityHint("Starts or pauses noise metering")
    }
    
    private var meteringStopButton: some View {
        Button {
            audioManager.stopMetering()
            isStarted = false // 시작 상태 초기화
            routerManger.pop() // 정지 시 선택창으로 이동
        } label: {
            Image(systemName: "xmark")
                .font(.title3)
                .bold()
                .foregroundStyle(.customWhite)
                .padding()
                .background {
                    Circle()
                        .fill(.customBlack)
                }
        }
        .accessibilityLabel("Stop metering")
        .accessibilityHint("Stop noise metering")
    }
    
    // MARK: Functions
    private func startWaveAnimation() {
        DispatchQueue.main.async {
            withAnimation(waveMotion) {
                self.waveOffset = Angle(degrees: 360)
            }
        }
    }
    
    private func changeHeightAnimation(loudness: CGFloat) {
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 0.5)) {
                let minRatio: CGFloat = 1.0
                let maxRatio: CGFloat = 1.5
                
                switch loudness {
                case maxRatio...:
                    self.percent = 100.0
                    audioManager.userNoiseStatus = .danger
                    
                case 1.3..<maxRatio:
                    self.percent = 75.0
                    audioManager.userNoiseStatus = .caution
                    
                case minRatio..<1.3:
                    self.percent = 45.0 + (loudness - minRatio) / (maxRatio - minRatio) * 30.0
                    audioManager.userNoiseStatus = .safe
                    
                default:
                    self.percent = 45.0
                    audioManager.userNoiseStatus = .safe
                }
            }
        }
    }
}

#Preview {
    MainView(selectedPlace: Place(id: UUID(), name: "도서관", backgroundDecibel: 40.0, distance: 2.0))
}
