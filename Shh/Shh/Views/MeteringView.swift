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
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var audioManager: AudioManager
    
    @State private var isAnimating = false
    
    @State private var showLiveDecibelSheet = false
    
    @State private var showHelpViewFullScreenCover = false
    
    private let meteringCircleAnimation = Animation
        .easeInOut(duration: 1.5)
        .repeatForever(autoreverses: true)
    
    // MARK: Body
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            userNoiseStatusInfo
                .frame(maxWidth: .infinity)
            
            Spacer()
            
            ZStack {
                meteringCircles
                    .hidden(!audioManager.isMetering) // 측정 중일 때
                
                meteringPausedCircle
                    .hidden(audioManager.isMetering) // 측정을 멈추었을 때
            }
            
            Spacer()
            
            meteringToggleButton
                .frame(maxWidth: .infinity)
                
            Spacer()
        }
        .background(.customBlack)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("종료")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundStyle(.gray)
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                HStack(spacing: 10) {
                    Button {
                        withAnimation {
                            showLiveDecibelSheet = true
                        }
                    } label: {
                        Label("실시간 현황", systemImage: "chart.xyaxis.line")
                            .font(.callout)
                            .fontWeight(.regular)
                            .foregroundStyle(.accent)
                            .padding(.all, 6)
                            .background {
                                if showLiveDecibelSheet {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(.green.opacity(0.3))
                                }
                            }
                    }
                    .contentShape(Rectangle())
                    .buttonStyle(.plain)
                    .popoverTip(LiveDecibelTip())
                    
                    Button {
                        withAnimation {
                            showHelpViewFullScreenCover = true
                        }
                    } label: {
                        Text("도움말")
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundStyle(.accent)
                    }
                    .contentShape(Rectangle())
                    .buttonStyle(.plain)
                }
            }
        }
        .onChange(of: audioManager.userNoiseStatus) {
            Task {
                if audioManager.userNoiseStatus == .danger {
                    await NotificationManager.shared.sendNotification(.danger)
                    await NotificationManager.shared.sendNotification(.persistent)
                    await NotificationManager.shared.sendNotification(.recurringAlert)
                } else {
                    NotificationManager.shared.removeAllNotifications()
                }
            }
        }
        .onAppear {
            audioManager.startMetering()
        }
        .onDisappear {
            audioManager.stopMetering()
            NotificationManager.shared.removeAllNotifications()
        }
        .sheet(isPresented: $showLiveDecibelSheet) {
            LiveDecibelSheet()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $showHelpViewFullScreenCover) {
            HelpView()
        }
    }
    
    // MARK: SubViews
    private var meteringCircles: some View {
        ZStack(alignment: .center) {
            MeteringCircle(
                isGradient: false,
                scale: isAnimating ? 1.6 : 0.9
            )
            
            MeteringCircle(
                isGradient: false,
                scale: isAnimating ? 1.3 : 0.9
            )
                
            MeteringCircle(
                isGradient: true,
                scale: isAnimating ? 1.0 : 0.9
            )
        }
        .frame(width: 160)
        .onChange(of: audioManager.isMetering) {
            if audioManager.isMetering {
                DispatchQueue.main.async {
                    withAnimation(meteringCircleAnimation) {
                        isAnimating = true
                    }
                }
            }
        }
        .accessibilityHint(audioManager.isMetering ? "\(audioManager.userNoiseStatus) 상태를 \(audioManager.userNoiseStatus == .safe ? "초록색" : "분홍색")으로 나타내고 있습니다." : "일시정지된 상태입니다.")
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
        VStack(alignment: .center, spacing: 12) {
            Text(audioManager.userNoiseStatus.message)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.customWhite)
            
            Text(audioManager.userNoiseStatus.writing)
                .font(.callout)
                .fontWeight(.medium)
                .foregroundStyle(.gray2)
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
                .font(.system(size: 46, weight: .bold, design: .default))
                .fontWeight(.bold)
                .foregroundStyle(.customWhite)
                .padding(.horizontal, 29)
                .padding(.vertical, 22)
                .background {
                    Circle()
                        .fill(Color.meteringToggleButton)
                }
                .accessibilityLabel(audioManager.isMetering ? "일시정지" : "재개")
        }
        // TODO: 영어 현지화
        .accessibilityLabel(audioManager.isMetering ? "일시정지" : "재개")
        .accessibilityHint("버튼을 탭해서 소음 측정을 시작하거나 멈출 수 있습니다.")
    }
}

// MARK: - 중앙의 측정 원
struct MeteringCircle: View {
    @EnvironmentObject var audioManager: AudioManager
    
    let isGradient: Bool
    let scale: Double
    
    private var outerCircleColor: Color {
        audioManager.userNoiseStatus == .safe
        ? .green
        : .pink
    }
    
    private var innerCircleColors: [Color] {
        audioManager.userNoiseStatus == .safe
        ? [.green, .linearGreen]
        : [.pink, .linearPink]
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
    
    var body: some View {
        Circle()
            .fill(isGradient ? AnyShapeStyle(innerCircleGradient) : AnyShapeStyle(outerCircleColor))
            .opacity(isGradient ? 1.0 : 0.2)
            .scaleEffect(scale)
    }
}
