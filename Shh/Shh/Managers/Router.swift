//
//  Router.swift
//  Shh
//
//  Created by Jia Jang on 10/9/24.
//

import SwiftUI

// MARK: - 라우터 매니저
class Router: ObservableObject {
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
    case mainView
    case meteringView
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .mainView:
            MainView()
        case .meteringView:
            MeteringView()
        }
    }
}
