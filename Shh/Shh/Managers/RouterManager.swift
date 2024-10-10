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
    
    @ViewBuilder func view(for route: ShhView) -> some View {
        switch route {
        case .selectModeView:
            SelectModeView()
        case .createModeView:
            CreateModeView()
        case .noiseView(let selectedMenu):
            NoiseView(selectedMenu: selectedMenu)
        }
    }
    
    func push(view: ShhView) {
        path.append(view)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func backToSelect() {
        self.path = NavigationPath()
        path.append(ShhView.selectModeView)
    }
}

enum ShhView: Hashable {
    case selectModeView
    case createModeView
    case noiseView(selectedMenu: String)
}
