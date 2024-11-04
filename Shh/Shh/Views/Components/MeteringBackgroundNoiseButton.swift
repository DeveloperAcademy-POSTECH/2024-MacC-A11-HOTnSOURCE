//
//  BackgroundNoiseMeteringButton.swift
//  Shh
//
//  Created by Eom Chanwoo on 11/4/24.
//

import SwiftUI

struct MeteringBackgroundNoiseButton<Content: View>: View {
    @Binding var backgroundNoise: Float
    @Binding var isMetering: Bool

    let meteringAction: (@escaping (Float?) -> Void) throws -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        Button {
            meteringBackgroundNoise()
        } label: {
            content()
        }
        .buttonStyle(.plain)
        .disabled(isMetering)
    }

    private func meteringBackgroundNoise() {
        isMetering = true

        do {
            try meteringAction { averageDecibel in
                guard let averageDecibel = averageDecibel else {
                    isMetering = false
                    return
                }

                let unRoundedAverageDecibel = averageDecibel
                let roundedDecibel = round(unRoundedAverageDecibel / 5.0) * 5.0
                let clampedDecibel = min(max(roundedDecibel, 30.0), 70.0)

                backgroundNoise = clampedDecibel
                isMetering = false
            }
        } catch {
            backgroundNoise = 0
            isMetering = false
            print("소음 측정 중 오류 발생: \(error)")
        }
    }
}
