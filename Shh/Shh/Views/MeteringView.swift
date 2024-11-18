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
    
    // MARK: Body
    var body: some View {
        VStack(alignment: .center) {
            Spacer().frame(height: 58)
            
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
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    // TODO: 뒤로가기
                    router.pop()
                } label: {
                    Text("종료")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundStyle(.gray)
                        .contentShape(Rectangle())
                }
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                HStack(spacing: 10) {
                    Button {
                        showMeteringInfoSheet = true
                    } label: {
                        Label("실시간 현황", systemImage: "chart.xyaxis.line")
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundStyle(.green)
                            .contentShape(Rectangle())
                            .padding(.all, 6)
                            .background {
                                if showMeteringInfoSheet {
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(.green.opacity(0.3))
                                }
                            }
                    }
                    .buttonStyle(.plain)
                    
                    Button {
                        showMeteringInfoSheet = true
                    } label: {
                        Text("도움말")
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundStyle(.green)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .onChange(of: audioManager.userNoiseStatus) {
            Task {
                if audioManager.userNoiseStatus == .danger {
                    await NotificationManager.shared.sendNotification(.caution)
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
        .sheet(isPresented: $showMeteringInfoSheet) {
            MeteringInfoSheet()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
    
    // MARK: SubViews
    private var meteringCircles: some View {
        ZStack(alignment: .center) {
            MeteringCircle(
                userNoiseStatus: $audioManager.userNoiseStatus,
                isGradient: false,
                scale: isAnimating ? 1.8 : 0.9
            )
            
            MeteringCircle(
                userNoiseStatus: $audioManager.userNoiseStatus,
                isGradient: false,
                scale: isAnimating ? 1.4 : 0.9
            )
                
            MeteringCircle(
                userNoiseStatus: $audioManager.userNoiseStatus,
                isGradient: true,
                scale: isAnimating ? 1.0 : 0.9
            )
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
        }
        // TODO: 한글로 현지화
        .accessibilityLabel(audioManager.isMetering ? "Pause metering" : "Resume metering")
        .accessibilityHint("Starts or pauses noise metering")
    }
}

struct MeteringCircle: View {
    @Binding var userNoiseStatus: NoiseStatus
    
    let isGradient: Bool
    let scale: Double
    
    private var outerCircleColor: Color {
        userNoiseStatus == .safe
        ? .green
        : .pink
    }
    
    private var innerCircleColors: [Color] {
        userNoiseStatus == .safe
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
    
    var body: some View  {
        Circle()
            .fill(isGradient ? AnyShapeStyle(innerCircleGradient) : AnyShapeStyle(outerCircleColor))
            .opacity(isGradient ? 1.0 : 0.2)
            .scaleEffect(scale)
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

    NavigationStack {
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
}
