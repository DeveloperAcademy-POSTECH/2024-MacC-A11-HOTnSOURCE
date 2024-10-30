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
    @StateObject private var locationManager = LocationManager(connectivityManager: IOSConnectivityManager())
    
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
