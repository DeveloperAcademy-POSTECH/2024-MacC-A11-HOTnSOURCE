//
//  ShhWatchApp.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 10/30/24.
//

import SwiftUI

@main
struct ShhWatch_Watch_AppApp: App {
    // MARK: Properties
    @StateObject private var audioManager: AudioManager = {
        do {
            return try AudioManager()
        } catch {
            fatalError("AudioManager 초기화 실패: \(error.localizedDescription)")
        }
    }()
    
    // MARK: Body
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainView()
            }
            .onAppear {
                trySettingAudioSession()
            }
            .onDisappear {
                audioManager.stopMetering()
                NotificationManager.shared.removeAllNotifications()
            }
        }
        .environmentObject(audioManager)
    }
    
    // MARK: Function
    private func trySettingAudioSession() {
        do {
            try audioManager.setAudioSession()
        } catch {
            // TODO: 문제 발생 알러트 띄우기
            print("오디오 세션 설정 중에 문제가 발생했습니다.")
        }
    }
}
