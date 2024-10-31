//
//  RouterManager.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 10/30/24.
//

import SwiftUI

// MARK: - 라우터 매니저
class RouterManager: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    
    func push(view: ShhWatchView) {
        path.append(view)
    }
    
    func pop() {
        path.removeLast()
    }
}

enum ShhWatchView: Hashable {
    case selectLocationView
    case mainView
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .selectLocationView:
            SelectLocationView()
        case .mainView:
            MainView()
        }
    }
}
