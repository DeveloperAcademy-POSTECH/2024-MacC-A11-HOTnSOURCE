//
//  MainView.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 10/30/24.
//

import SwiftUI

// MARK: - 메인 뷰(첫 화면)
struct MainView: View {
    // MARK: Body
    var body: some View {
        VStack(spacing: 40) {
            VStack {
                Text("Title")
                    .font(.title)
                
                Text("Subtitle")
                    .font(.subheadline)
            }
            
            NavigationLink("Start") {
                MeteringTabView()
            }
        }
    }
}
