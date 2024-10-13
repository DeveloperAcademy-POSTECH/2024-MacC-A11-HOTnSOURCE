//
//  RouterManager.swift
//  Shh
//
//  Created by Jia Jang on 10/9/24.
//

import SwiftUI

// MARK: - 라우터 매니저
class RouterManager: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    
    func push(view: ShhView) {
        path.append(view)
    }
    
    func pop() {
        path.removeLast()
    }
}

enum ShhView: Hashable {
    case selectPlaceView
    case createPlaceView
    case editPlaceView(place: Place)
    case noiseView(selectedPlace: Place)
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .selectPlaceView:
            SelectPlaceView()
        case .createPlaceView:
            CreatePlaceView()
        case .editPlaceView(let place):
            EditPlaceView(place: place)
        case .noiseView(let selectedPlace):
            NoiseView(selectedPlace: selectedPlace)
        }
    }
}
