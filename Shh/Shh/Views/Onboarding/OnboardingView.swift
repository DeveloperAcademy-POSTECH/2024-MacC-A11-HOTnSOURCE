//
//  WelcomeView.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/31/24.
//

import SwiftUI

// MARK: - 온보딩 > 웰컴 페이지
struct OnboardingView: View {
    // MARK: Properties
    @State private var currentTab: OnboardingViewTab = .welcome
    
    // MARK: Body
    var body: some View {
        TabView(selection: $currentTab) {
            ForEach(OnboardingViewTab.allCases, id: \.self) { tab in
                tab.view
                    .tag(tab)
            }
        }
        .tabViewStyle(
            .page(indexDisplayMode: currentTab == .background ? .never : .always)
        )
        .padding(25)
        .background(.customBlack)
    }
}

// MARK: - 온보딩 화면 내 탭
enum OnboardingViewTab: CaseIterable {
    case welcome
    case pushNotification
    case earphone
    case background
}

extension OnboardingViewTab {
    @ViewBuilder
    var view: some View {
        switch self {
        case .welcome: WelcomeView()
        case .pushNotification: PushNotificationView()
        case .earphone: EarphoneView()
        case .background: BackgroundView()
        }
    }
}

// MARK: - Preview
#Preview {
    OnboardingView()
}
