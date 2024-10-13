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
    
    @AppStorage("selectedPlace") private var storedSelectedPlace: String = ""
    
    @State private var selectedPlace: Place?
    
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
                    routerManager.push(view: .noiseView(selectedPlace: selectedPlace))
                }
            }
            .environmentObject(routerManager)
        }
    }
}
