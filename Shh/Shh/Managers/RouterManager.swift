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
    @Published var onboardingPath: NavigationPath = NavigationPath()
    
    func push(view: ShhView, isOnboarding: Bool = false) {
        if !isOnboarding {
            path.append(view)
        } else {
            onboardingPath.append(view)
        }
    }
    
    func pop(isOnboarding: Bool = false) {
        if !isOnboarding {
            path.removeLast()
        } else {
            onboardingPath.removeLast()
        }
    }
}

enum ShhView: Hashable {
    case selectLocationView
    case createLocationView
    case editLocationView(location: Location)
    case mainView(selectedLocation: Location)
    case meteringInfoView
    case startView(name: String, backgroundNoise: Float, distance: Float)
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .selectLocationView:
            SelectLocationView()
        case .createLocationView:
            CreateLocationView()
        case .editLocationView(let location):
            EditLocationView(location: location)
        case .mainView(let selectedLocation):
            MainView(selectedLocation: selectedLocation)
        case .meteringInfoView:
            MeteringInfoView()
        case .startView(let name, let backgroundNoise, let distance):
            StartView(name: name, backgroundNoise: backgroundNoise, distance: distance)
        }
    }
}
