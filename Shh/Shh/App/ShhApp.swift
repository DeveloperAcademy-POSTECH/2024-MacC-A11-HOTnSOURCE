//
//  ShhApp.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/7/24.
//

import SwiftUI
import TipKit
@main
struct ShhApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var audioManager: AudioManager = {
        do {
            return try AudioManager()
        } catch {
            fatalError("AudioManager 초기화 실패: \(error.localizedDescription)")
        }
    }()
    
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                WelcomeView()
                    .background(.customBlack)
            } else {
                MainView()
                    .task {
                        #if DEBUG
                        try? Tips.resetDatastore() // 디버그를 위해 팁 상태 초기화, 실제 버전에서는 동작하진 않음
                        #endif
                        try? Tips.configure( // 모든 팁을 로드
                            [
                                // TODO: 팁과 관련된 동작 수정 예정
                                // .datastoreLocation(.applicationDefault) // 표시된 팁과 매개변수 재설정
                                // .displayFrequency(.immediate) // 팁이 보이는 시기. 바로 보이게
                            ]
                        )
                    }
            }
        }
        .environmentObject(audioManager)
    }
}
