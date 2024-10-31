//
//  StartView.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/31/24.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        VStack {
            Spacer()
            
            StepDescriptionRow(
                text: "모든 준비가 완료되었어요!",
                subText: "지금 바로 Shh-!와 함께\n조용한 작업을 시작해볼까요?"
            )
            
            Spacer()
            
            SsambbongAsset(image: .completeAsset)
            
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            
            CustomButton(text: "시작하기") {
                // TODO: newLocation 메인뷰로 네비게이트
            }
        }
        .padding(30)
    }
}

#Preview {
    StartView()
}
