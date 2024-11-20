//
//  MainView.swift
//  Shh
//
//  Created by sseungwonnn on 11/16/24.
//

import SwiftUI

// MARK: - 메인 화면
struct MainView: View {
    // MARK: Properties
    @EnvironmentObject var audioManager: AudioManager

    @State private var showLoadingView: Bool = false
    @State private var showOnboardingFullScreen: Bool = false

    // MARK: Body
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer(minLength: 20)
                
                welcomeWriting
                
                Image("MainAsset")
                    .resizable()
                    .scaledToFit()
                    .padding(.all, 40)
                
                VStack(spacing: 10) {
                    Text("버튼 눌러 시작하기")
                        .font(.footnote)
                        .foregroundStyle(.tertiary)
                    
                    startButton
                }
                
                Spacer(minLength: 20)
            }
            .background(.customBlack)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showOnboardingFullScreen = true
                    } label: {
                        Label("온보딩 가이드", systemImage: "book.pages")
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundStyle(.gray)
                    }
                    .contentShape(Rectangle())
                    .buttonStyle(.plain)
                    .hidden(showLoadingView)
                    .animation(nil, value: showLoadingView)
                }
            }
            
            if showLoadingView {
                LoadingView()
                    .transition(.move(edge: .trailing))
            }
        }
        .task {
            await NotificationManager.shared.requestPermission()
        }
        .onDisappear {
            showLoadingView = false
        }
        .fullScreenCover(isPresented: $showOnboardingFullScreen) {
            NavigationStack {
                OnboardingView()
            }
        }
    }
    
    // MARK: SubViews
    private var welcomeWriting: some View {
        VStack(spacing: 10) {
            Text("오늘도 조용한 하루를\n보내봐요!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.customWhite)
                .multilineTextAlignment(.center)
            
            Text("Shh-!")
                .font(.callout)
                .fontWeight(.bold)
                .foregroundStyle(.gray2)
            + Text("가 응원할게요")
                .font(.callout)
                .fontWeight(.regular)
                .foregroundStyle(.gray2)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var startButton: some View {
        Button {
            Task {
                await audioManager.requestMicrophonePermission()
                if audioManager.checkMicrophonePermissionStatus() {
                    withAnimation {
                        showLoadingView = true
                    }
                } else {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        await UIApplication.shared.open(url)
                    }
                }
            }
        } label: {
            Image(systemName: "waveform")
                .font(.system(size: 46))
                .foregroundStyle(.white)
                .frame(width: 100, height: 100)
                .background {
                    Circle()
                        .fill(.accent)
                }
                .accessibilityLabel("시작하기")
                .accessibilityHint("탭하면 측정을 시작합니다.")
        }
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
        MainView()
            .environmentObject(audioManager)
    }
}
