//
//  MainView.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 10/30/24.
//

import SwiftUI

// MARK: - 메인 뷰(첫 화면)
struct MainView: View {
    // MARK: Properties
    @EnvironmentObject var audioManager: AudioManager
    
    @State private var showLoadingView: Bool = false
    
    // MARK: Body
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                welcomeText
                startButton
            }
            .padding()
            
            if showLoadingView {
                LoadingView()
                    .transition(.move(edge: .trailing))
            }
        }
        .onDisappear {
            showLoadingView = false
        }
    }
    
    // MARK: Subviews
    private var welcomeText: some View {
        VStack {
            VStack(spacing: 0) {
                Text("반가워요!")
                Text("소음이 걱정이신가요?")
            }
            .font(.title3)
            .bold()
            
            VStack(spacing: 0) {
                Text("아래 버튼을 눌러")
                Text("시작해주세요")
            }
            .font(.subheadline)
            .foregroundStyle(.gray)
        }
    }
    
    private var startButton: some View {
        Button("시작하기") {
            showLoadingView = true
        }
        .buttonStyle(BorderedButtonStyle(tint: .accent.opacity(3.5)))
        .foregroundStyle(.customWhite)
    }
}
