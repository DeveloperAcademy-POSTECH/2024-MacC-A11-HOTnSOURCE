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
    @State private var isNavigating: Bool = false
    
    // MARK: Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                VStack {
                    Text("Title")
                        .font(.title)
                    
                    Text("Subtitle")
                        .font(.subheadline)
                }
                
                Text("배경 소음 측정")
                    .onTapGesture {
                        Task {
                            do {
                                // 배경 소음 측정
                                try await audioManager.meteringBackgroundNoise()
                                
                                // (MeteringTabView에 넘겨주기 위해) backgroundDecibel 저장
                                backgroundDecibel = Float(audioManager.backgroundDecibel)
                                
                                // MeteringTabView로 이동
                                isNavigating = true
                                
                                // TODO: iOS의 로딩 뷰 머지 후, watch에도 배경 소음 측정 과정에 로딩 뷰 활용할 예정
                            } catch {
                                print("‼️ 배경 소음 측정 실패 \(error)")
                            }
                        }
                    }
            }
            .navigationDestination(isPresented: $isNavigating) {
                MeteringTabView(backgroundDecibel: $backgroundDecibel)
            }
        }
    }
}
