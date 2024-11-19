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
    
    @State var backgroundDecibel: Float = 0
    @State private var canNavigate: Bool = false
    
    // MARK: Body
    var body: some View {

        VStack(spacing: 20) {
            welcomeText
            startButton
        }
        .padding()
        .navigationDestination(isPresented: $canNavigate) {
            MeteringTabView(backgroundDecibel: $backgroundDecibel)
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
            meterBackgroundNoise()
        }
        .buttonStyle(BorderedButtonStyle(tint: .accent.opacity(10)))
        .foregroundStyle(.customWhite)
    }
    
    // MARK: Function
    private func meterBackgroundNoise() {
        Task {
            do {
                // 배경 소음 측정
                try await audioManager.meteringBackgroundDecibel()
                
                // (MeteringTabView에 넘겨주기 위해) backgroundDecibel 저장
                backgroundDecibel = Float(audioManager.backgroundDecibel)
                
                // MeteringTabView로 이동
                canNavigate = true
                
                // TODO: iOS의 로딩 뷰 머지 후, watch에도 배경 소음 측정 과정에 로딩 뷰 활용할 예정
            } catch {
                print("‼️ 배경 소음 측정 실패 \(error)")
            }
        }
    }
}
