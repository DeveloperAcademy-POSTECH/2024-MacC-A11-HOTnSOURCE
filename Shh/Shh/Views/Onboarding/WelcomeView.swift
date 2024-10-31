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
            Spacer()
            
            Text("처음 오셨네요!\n장소부터 만들어볼까요?")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
            SsambbongAsset(image: .welcomeAsset)
            
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            
            startButton
        }
        .padding(20)
    }
    
    // MARK: SubViews
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
