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
    case selectLocationView
    case createLocationView
    case editLocationView(location: Location)
    case mainView(selectedLocation: Location)
    case meteringInfoView
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .selectLocationView:
            SelectLocationView()
        case .createLocationView:
            PreviousCreateLocationView()
        case .editLocationView(let location):
            EditLocationView(location: location)
        case .mainView(let selectedLocation):
            MainView(selectedLocation: selectedLocation)
        case .meteringInfoView:
            MeteringInfoView()
        }
    }
}
