//
//  MeteringView.swift
//  Shh
//
//  Created by sseungwonnn on 10/14/24.
//

import SwiftUI
import TipKit

// MARK: - 측정 뷰; 사용자의 소음 정도를 나타냅니다.
struct MeteringView: View {
    // MARK: Properties
    @EnvironmentObject var router: Router
    @EnvironmentObject var audioManager: AudioManager
    
    @State private var isAnimating = false
    
    @State private var showMeteringInfoSheet = false
    
    private let meteringCircleAnimation = Animation
        .easeInOut(duration: 1.5)
        .repeatForever(autoreverses: true)

    private let infoPopoverTip = InfoPopoverTip() // Tip 상태 접근을 위해 객체 미리 생성
    
    private var infoPopoverTipStatus: Tip.Status {
        infoPopoverTip.status
    }
    
    private var outerCircleColor: Color {
        audioManager.userNoiseStatus == .safe
        ? .accent
        : .indigo
    }
    
    private var innerCircleColors: [Color] {
        audioManager.userNoiseStatus == .safe
        ? [.accent, .customLime]
        : [.indigo, .purple]
    }
    
    // MARK: Body
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                meteringCircles
                    .hidden(!audioManager.isMetering) // 측정 중일 때
                
                meteringPausedCircle
                    .hidden(audioManager.isMetering) // 측정을 멈추었을 때
            }
            
            Spacer()
            
            HStack(alignment: .center) {
                userNoiseStatusInfo
                
                Spacer()
                
                meteringToggleButton
            }
            Spacer().frame(height: 20) // 아래 여백
        }
        .padding(.horizontal)
        .background(.customBlack)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    showMeteringInfoSheet = true
                } label: {
                    Label("정보", systemImage: "info.circle")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundStyle(.accent)
                }
                .buttonStyle(.plain)
                .popoverTip(infoPopoverTip, arrowEdge: .top)
            }
        }
        .onChange(of: audioManager.userNoiseStatus) {
            Task {
                if audioManager.userNoiseStatus == .caution {
                    await NotificationManager.shared.sendNotification(.caution)
                    await NotificationManager.shared.sendNotification(.persistent)
                    await NotificationManager.shared.sendNotification(.recurringAlert)
                } else {
                    NotificationManager.shared.removeAllNotifications()
                }
            }
        }
        .onAppear {
            do {
                try audioManager.setAudioSession()
            } catch {
                // TODO: 문제 발생 알러트 띄우기
                print("오디오 세션 설정 중에 문제가 발생했습니다.")
            }
        }
        .onDisappear {
            audioManager.stopMetering()
            NotificationManager.shared.removeAllNotifications()
        }
        .sheet(isPresented: $showMeteringInfoSheet) {
            MeteringInfoSheet()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
    
    // MARK: SubViews
    private var meteringCircles: some View {
        ZStack(alignment: .center) {
            Circle()
                .fill(outerCircleColor)
                .opacity(0.2)
                .scaleEffect(isAnimating ? 1.8 : 0.9)
                
            Circle()
                .fill(outerCircleColor)
                .opacity(0.2)
                .scaleEffect(isAnimating ? 1.4 : 0.9)

            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: innerCircleColors),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .scaleEffect(isAnimating ? 1.0 : 0.9)
        }
        .frame(width: 160)
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
            if audioManager.isMetering {
                audioManager.pauseMetering()
            } else {
                audioManager.startMetering()
            }
            
            isAnimating.toggle()
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
}

// MARK: - Preview
#Preview {
    @Previewable @StateObject var audioManager: AudioManager = {
        do {
            return try AudioManager()
        } catch {
            fatalError("AudioManager 초기화 실패: \(error.localizedDescription)")
        }
    }()

    MeteringView()
        .environmentObject(audioManager)
        .onAppear {
            do {
                try audioManager.setAudioSession()
            } catch {
                print("oops")
            }
        }
}
