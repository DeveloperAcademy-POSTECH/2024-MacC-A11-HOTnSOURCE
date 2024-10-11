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
                    .navigationDestination(for: ShhView.self) { shhView in
                        shhView.view
                    }
            }
            .onAppear {
                routerManager.push(view: .noiseView(selectedMenu: "도서관"))
            }
            .environmentObject(routerManager)
        }
    }
}
