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
    case selectLocationView(location: Location)
    case createLocationView
    case editLocationView(location: Location)
    case mainView(selectedLocation: Location)
    case meteringInfoView
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .selectLocationView(let location):
            SelectLocationView(location: location)
        case .createLocationView:
            CreateLocationView()
        case .editLocationView(let location):
            EditLocationView(location: location)
        case .mainView(let selectedLocation):
            MainView(selectedLocation: selectedLocation)
        case .meteringInfoView:
            MeteringInfoView()
        }
    }
}
