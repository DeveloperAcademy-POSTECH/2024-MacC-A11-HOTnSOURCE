//
//  WelcomeView.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/31/24.
//

import SwiftUI

// MARK: - 온보딩
struct OnboardingView: View {
    // MARK: Properties
    @Environment(\.dismiss) var dismiss
    
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    
    @State private var currentTab: OnboardingTab = .welcome
    
    // MARK: Body
    var body: some View {
        TabView(selection: $currentTab) {
            ForEach(OnboardingTab.allCases, id: \.self) { tab in
                if tab == .welcome {
                    WelcomeView()
                        .tag(tab)
                } else {
                    OnboardingTabView(tab: tab)
                        .tag(tab)
                }
            }
        }
        .tabViewStyle(
            .page(indexDisplayMode: currentTab == .allCases.last ? .never : .always)
        )
        .background(.customBlack)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if isFirstLaunch {
                        isFirstLaunch = false
                    } else {
                        dismiss()
                    }
                } label: {
                    Text("건너뛰기")
                        .font(.body)
                        .fontWeight(.regular)
                        .foregroundStyle(.gray)
                }
                .contentShape(Rectangle())
                .buttonStyle(.plain)
                .hidden(currentTab == .allCases.last)
            }
        }
    }
}

// MARK: - 온보딩 화면 내 탭
enum OnboardingTab: CaseIterable {
    case welcome
    case pushNotification
    case earphone
    case background
}

extension OnboardingTab {
    var image: UIImage {
        switch self {
        case .welcome: .pushNotification
        case .pushNotification: .pushNotification
        case .earphone: .earphone
        case .background: .background
        }
    }
    
    var title: LocalizedStringKey {
        switch self {
        case .welcome: "Shh-!를\n소개합니다"
        case .pushNotification: "푸시 알림으로 빠른 안내"
        case .earphone: "노래를 들으면서도 걱정 없이"
        case .background: "화면을 보지 않고도"
        }
    }
    
    var subtitle: LocalizedStringKey {
        switch self {
        case .welcome: "내 소리가 시끄러울까봐 걱정되시나요?\n소음으로 인해 주위의 따가운 시선을 받은 적이 있나요?"
        case .pushNotification: "내 소리가 주변보다 시끄러우면\n푸시 알림으로 알려드려요"
        case .earphone: "편하게 음악을 들어도 괜찮아요\n소음은 저희가 대신 들어드릴게요"
        case .background: "앱을 늘 켜고 있지 않아도\n백그라운드에서 계속 들어드릴게요"
        }
    }
    
    var subtext: LocalizedStringKey {
        switch self {
        case .welcome: "시끄러운지는 저희가 대신 듣고 알려드릴테니\n걱정 말고 편안하게 집중하세요!"
        case .pushNotification: "* 애플 워치를 사용하시면 워치로도 알림을 드려요"
        case .earphone: "* 전화 중에는 마이크를 동시에 사용할 수 없으니\n통화를 마치고 다시 시작해주세요"
        case .background: "* 라이브 액티비티로도 확인할 수 있어요"
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        OnboardingView()
    }
}
