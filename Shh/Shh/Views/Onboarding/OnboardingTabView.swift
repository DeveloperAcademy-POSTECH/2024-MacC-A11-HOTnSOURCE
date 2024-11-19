//
//  OnboardingTabView.swift
//  Shh
//
//  Created by Eom Chanwoo on 11/19/24.
//

import SwiftUI

// MARK: - 온보딩 각 탭 별 화면
struct OnboardingTabView: View {
    // MARK: Properties
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    
    let tab: OnboardingTab
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 40)
            
            Image(uiImage: tab.image)
                .resizable()
                .scaledToFit()
            
            Spacer().frame(height: 70)
            
            Text(tab.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Spacer().frame(height: 16)
            
            Text(tab.subtitle)
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
            
            Spacer().frame(height: 10)
            
            Text(tab.subtext)
                .font(.caption)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .lineLimit(3, reservesSpace: true)
            
            Spacer()
            
            startButton
                .hidden(tab != .allCases.last!)
        }
        .padding()
    }
    
    // MARK: SubViews
    private var startButton: some View {
        Button {
            isFirstLaunch = false
        } label: {
            Text("시작하기")
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(.accent)
                )
        }
        .accessibilityLabel("시작하기")
    }
}

// MARK: - Preview
#Preview {
    OnboardingTabView(tab: .background)
}
