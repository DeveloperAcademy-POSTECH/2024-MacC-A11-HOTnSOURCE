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
    
    // MARK: Body
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer(minLength: 20)
                
                Text("반가워요!\n소음이 걱정이신가요?")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer(minLength: 15)
                
                Text("아래 버튼을 눌러 시작해주세요")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                    .frame(maxHeight: .infinity)
                
                Text("버튼 눌러 시작하기")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                
                Spacer(minLength: 20)
                
                startButton
                
                Spacer(minLength: 20)
            }
            .padding(25)
            .background(.customBlack)
            
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
    }
    
    // MARK: SubViews
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
                .font(.system(size: 60))
                .foregroundStyle(.white)
                .frame(width: 130, height: 130)
                .background {
                    Circle()
                        .fill(.accent)
                }
        }
    }
}

// MARK: - Preview
#Preview {
    MainView()
}
