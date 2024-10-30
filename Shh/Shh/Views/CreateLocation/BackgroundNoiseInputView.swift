//
//  BackgroundNoiseInputView.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/30/24.
//

import SwiftUI

struct BackgroundNoiseInputView: View {
    @Binding var step: CreateLocationStep
    @Binding var backgroundNoise: Float
    
    var body: some View {
        VStack {
            Text("Background Noise Input View")
            NextStepButton(step: $step)
        }
    }
}

#Preview {
    BackgroundNoiseInputView(step: .constant(.backgroundInput), backgroundNoise: .constant(0))
}
