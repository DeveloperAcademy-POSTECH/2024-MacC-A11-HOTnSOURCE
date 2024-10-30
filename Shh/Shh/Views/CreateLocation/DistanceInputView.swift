//
//  DistanceInputView.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/30/24.
//

import SwiftUI

struct DistanceInputView: View {
    @Binding var step: CreateLocationStep
    @Binding var distance: Float
    
    var body: some View {
        VStack {
            Text("Distance Input View")
            NextStepButton(step: $step)
        }
    }
}

#Preview {
    DistanceInputView(step: .constant(.distanceInput), distance: .constant(0))
}
