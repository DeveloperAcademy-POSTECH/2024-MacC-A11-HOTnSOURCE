//
//  ContentView.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 10/30/24.
//

import SwiftUI

// MARK: - 홈 뷰: Controls, Metering, Info View로 구성
struct MeteringTabView: View {
    // MARK: Properties
    @State private var tabSelection: Tabs = .home
    
    // TODO: 기능 구현하고 나서 실제 데이터로 변경 예정
    @State private var isMetering = true
    
    // MARK: Body
    var body: some View {
        TabView(selection: $tabSelection) {
            ControlsView(isMetering: $isMetering)
                .tag(Tabs.controls)
            
            MeteringView(isMetering: $isMetering)
                .tag(Tabs.home)
            
            MeteringInfoView()
                .tag(Tabs.info)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MeteringTabView()
}
