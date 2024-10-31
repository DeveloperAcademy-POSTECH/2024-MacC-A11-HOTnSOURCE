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
    
    @StateObject private var routerManager = RouterManager()
    @StateObject private var locationManager = LocationManager()
    @StateObject private var audioManager: AudioManager = {
        do {
            return try AudioManager()
        } catch {
            fatalError("AudioManager 초기화 실패: \(error.localizedDescription)")
        }
    }()
    
    private let notificationManager: NotificationManager = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $routerManager.path) {
                SelectLocationView()
                    .navigationDestination(for: ShhView.self) { shhView in
                        shhView.view
                    }
            }
            .environmentObject(routerManager)
            .environmentObject(locationManager)
            .environmentObject(audioManager)
            .onAppear {
                if let selectedLocation = locationManager.selectedLocation {
                    routerManager.push(view: .mainView(selectedLocation: selectedLocation))
                }
                
                Task {
                    await notificationManager.requestPermission()
                }
            }
            .task {
            #if DEBUG
                try? Tips.resetDatastore() // 디버그를 위해 팁 상태 초기화, 실제 버전에서는 동작하진 않음
            #endif
                try? Tips.configure(
                    [
                        // Reset which tips have been shown and what parameters have been tracked, useful during testing and for this sample project
                        .datastoreLocation(.applicationDefault)
                        
                        // When should the tips be presented? If you use .immeiate, they'll all be presented whenever a screen with a tip appears.
                        // You can adjust this on per tip level as well
//                        .displayFrequency(.immediate)
                    ]
                )
            }
        }
    }
}
