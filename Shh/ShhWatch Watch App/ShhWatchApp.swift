//
//  ShhWatchApp.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 10/30/24.
//

import SwiftUI

@main
struct ShhWatch_Watch_AppApp: App {
    @StateObject private var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                SelectLocationView()
                    .navigationDestination(for: ShhWatchView.self) { shhWatchView in
                        shhWatchView.view
                    }
            }
            .environmentObject(router)
        }
    }
}
