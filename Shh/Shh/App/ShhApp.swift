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
    
    @AppStorage("selectedLocation") private var storedSelectedLocation: String = ""
    
    @State private var selectedLocation: Location?
    
    private let notificationManager: NotificationManager = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $routerManager.path) {
                SelectLocationView()
                    .navigationDestination(for: ShhView.self) { shhView in
                        shhView.view
                    }
            }
            .onAppear {
                if let data = storedSelectedLocation.data(using: .utf8),
                    let decodedLocations = try? JSONDecoder().decode(Location.self, from: data) {
                        selectedLocation = decodedLocations
                }
                
                if let selectedLocation = self.selectedLocation {
                    routerManager.push(view: .mainView(selectedLocation: selectedLocation))
                }
                
                Task {
                    await notificationManager.requestPermission()
                }
            }
            .environmentObject(routerManager)
        }
    }
}
