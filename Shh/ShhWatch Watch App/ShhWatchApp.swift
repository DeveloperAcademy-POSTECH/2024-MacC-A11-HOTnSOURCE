//
//  ShhWatchApp.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 10/30/24.
//

import SwiftUI

@main
struct ShhWatch_Watch_AppApp: App {
    @StateObject private var routerManager = RouterManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $routerManager.path) {
                SelectLocationView()
                    .navigationDestination(for: ShhWatchView.self) { shhWatchView in
                        shhWatchView.view
                    }
            }
            .environmentObject(routerManager)
        }
    }
}
