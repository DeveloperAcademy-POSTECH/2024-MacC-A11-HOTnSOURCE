//
//  DistanceInputView.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/30/24.
//

import SwiftUI

// MARK: - 장소 생성 > 측정 반경 입력 화면
struct DistanceInputView: View {
    // MARK: Properties
    @Binding var step: CreateLocationStep
    @Binding var distance: Float
    @Binding var createComplete: Bool
    
    let isFirstUser: Bool
    
    // MARK: Body
    var body: some View {
        VStack {
            StepDescriptionRow(
                text: step.text,
                subText: step.subText
            )
            
            Spacer(minLength: 30)
            
            SsambbongAsset(image: .distanceInputAsset)
            
            Spacer()

            DistanceInputField(distance: $distance)
            
            Spacer(minLength: 16)
            
            CustomButton(text: isFirstUser ? "다음으로" : "완료하기") {
                createComplete = true
            }
            .disabled(distance.isZero)
        }
    }
}

// MARK: - Preview
#Preview {
    DistanceInputView(step: .constant(.distanceInput), distance: .constant(0), createComplete: .constant(false), isFirstUser: true)
}
