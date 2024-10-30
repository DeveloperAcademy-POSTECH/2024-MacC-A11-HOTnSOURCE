//
//  NextStepButton.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/30/24.
//

import SwiftUI

struct NextStepButton: View {
    @Binding var step: CreateLocationStep
    
    var body: some View {
        CustomButton(text: "다음으로") {
            goToNextStep()
        }
        .accessibilityLabel("다음 단계로 이동")
    }
    
    private func goToNextStep() {
        if let nextStep = CreateLocationStep(rawValue: step.rawValue + 1) {
            withAnimation(.easeInOut(duration: 0.2)) {
                step = nextStep
            }
        }
    }
}

#Preview {
    NextStepButton(step: .constant(.backgroundNoiseInput))
}
