//
//  MainView.swift
//  Shh
//
//  Created by sseungwonnn on 11/16/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        // TODO: 디자인 예정
        VStack {
            Text("진짜 메인뷰")
            
            CustomButton(text: "측정 뷰로 이동") {
                router.push(view: .meteringView)
            }
        }
    }
}

#Preview {
    MainView()
}
