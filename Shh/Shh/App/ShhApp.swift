//
//  ShhApp.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/7/24.
//

import SwiftUI

@main
struct ShhApp: App {
    @StateObject private var routerManager = RouterManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $routerManager.path) {
                SelectModeView()
                    .navigationDestination(for: ShhView.self){ shhView in
                        routerManager.view(for: shhView)
                    }
            }
            .onAppear {
                routerManager.push(view: .noiseView)
            }
            .environmentObject(routerManager)
        }
    }
}
