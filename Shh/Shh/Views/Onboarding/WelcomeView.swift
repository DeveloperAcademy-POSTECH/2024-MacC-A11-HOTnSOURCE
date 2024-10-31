//
//  WelcomeView.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/31/24.
//

import SwiftUI

struct WelcomeView: View {
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
            
            CustomButton(text: "시작하기") {
                // TODO: 장소 생성 뷰로 네비게이트
            }
        }
        .padding(30)
    }
}

#Preview {
    WelcomeView()
}
