//
//  WelcomeView.swift
//  Shh
//
//  Created by Eom Chanwoo on 11/19/24.
//

import SwiftUI

// MARK: - 온보딩 첫 시작 화면
struct WelcomeView: View {
    // MARK: Properties
    let tab: OnboardingTab = .welcome
    
    // MARK: Body
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Group {
                Text(tab.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(tab.subtitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                Text(tab.subtext)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding(.leading)
            
            Image(uiImage: tab.image)
                .resizable()
                .scaledToFit()
        }
    }
}

// MARK: - Preview
#Preview {
    WelcomeView()
}
