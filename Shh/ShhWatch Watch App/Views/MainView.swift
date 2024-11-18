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
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 40) {
            VStack {
                Text("Title")
                    .font(.title)
                
                Text("Subtitle")
                    .font(.subheadline)
            }
            
//            NavigationLink {
//                MeteringTabView()
//            } label: {
//                Button {
//                    Task {
//                        do {
//                            try await audioManager.meteringBackgroundNoise()
//                            
//                            print("isMetering \(audioManager.isMetering)")
//                            print("userNoiseStatus \(audioManager.userNoiseStatus)")
//                            
//                        } catch {
//                            print("‼️ 배경 소음 측정 실패 \(error)")
//                        }
//                    }
//                } label: {
//                    Text("배경 소음 측정")
//                }
//            }
        }
        .onAppear {
            Task {
                do {
                    try await audioManager.meteringBackgroundNoise()
                    
                    print("isMetering \(audioManager.isMetering)")
                    print("userNoiseStatus \(audioManager.userNoiseStatus)")
                    
                } catch {
                    print("‼️ 배경 소음 측정 실패 \(error)")
                }
            }
        }
        .onChange(of: audioManager.userNoiseStatus) {
            print("OnChange: userNoiseStatus \(audioManager.userNoiseStatus)")
        }
    }
}
