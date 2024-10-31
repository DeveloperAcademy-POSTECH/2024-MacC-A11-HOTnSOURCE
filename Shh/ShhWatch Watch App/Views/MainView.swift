//
//  ContentView.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 10/30/24.
//

import SwiftUI

// MARK: - 메인 뷰: Controls, Home, MeteringInfo View로 구성
struct MainView: View {
    // MARK: Properties
    @State private var tabSelection: MainTabs = .home
    
    // ✅ TODO: 뭘 쓰는게 맞는지 다시 확인 필요 (StateObject/var/private)
    private var connectivityManager = WatchConnectivityManager()
    
    // MARK: Body
    var body: some View {
        TabView(selection: $tabSelection) {
            controlsView
                .tag(MainTabs.controls)
            
            homeView
                .tag(MainTabs.home)
            
            MeteringInfoView()
                .tag(MainTabs.info)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: SubViews
    private var controlsView: some View {
        Text("controls view")
    }
    
    private var homeView: some View {
        Text("home view")
    }
}

#Preview {
    MainView()
}
