//
//  ShhApp.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/7/24.
//

import SwiftUI

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
    
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    
    private let notificationManager: NotificationManager = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                NavigationStack(path: $routerManager.onboardingPath) {
                    WelcomeView()
                        .navigationDestination(for: ShhView.self) { shhView in
                            shhView.view
                        }
                }
                .environmentObject(routerManager)
                .environmentObject(locationManager)
                .environmentObject(audioManager)
            } else {
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
            }
        }
    }
}
