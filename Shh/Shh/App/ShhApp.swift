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
    
    @AppStorage("selectedPlace") private var storedSelectedPlace: String = ""
    
    @State private var selectedPlace: Place?
    
    private let notificationManager: NotificationManager = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $routerManager.path) {
                SelectPlaceView()
                    .navigationDestination(for: ShhView.self) { shhView in
                        shhView.view
                    }
            }
            .onAppear {
                if let data = storedSelectedPlace.data(using: .utf8),
                    let decodedPlaces = try? JSONDecoder().decode(Place.self, from: data) {
                        selectedPlace = decodedPlaces
                }
                
                if let selectedPlace = self.selectedPlace {
                    routerManager.push(view: .mainView(selectedPlace: selectedPlace))
                }
                
                Task {
                    await notificationManager.requestPermission()
                }
            }
            .environmentObject(routerManager)
        }
    }
}
