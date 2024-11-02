//
//  WelcomeView.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/31/24.
//

import SwiftUI

// MARK: - 온보딩 > 웰컴 페이지
struct WelcomeView: View {
    // MARK: Properties
    @EnvironmentObject var routerManager: RouterManager
    
    // MARK: Body
    var body: some View {
        VStack {
            Spacer(minLength: 80)
            
            welcomeComment
            
            Spacer(minLength: 50)
            
            SsambbongAsset(image: .welcomeAsset)
                .frame(maxHeight: .infinity, alignment: .top)
            
            startButton
        }
        .padding(20)
    }
    
    // MARK: SubViews
    private var welcomeComment: some View {
        VStack(alignment: .leading) {
            Text("반가워요!\n소음이 걱정이신가요?")
                .font(.title)
            Text("소음이 걱정될 땐? Shh-!")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .fontWeight(.bold)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var startButton: some View {
        CustomButton(text: "시작하기") {
            routerManager.push(view: .createLocationView, isOnboarding: true)
        }
    }
}

// MARK: - Preview
#Preview {
    WelcomeView()
        .environmentObject(RouterManager())
}
