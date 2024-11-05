//
//  SliderWithSnap.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/31/24.
//

import SwiftUI

// MARK: - 특정 스냅 포인트마다 걸리는 커스텀 슬라이더
struct SliderWithSnap: View {
    // MARK: Properties
    @Binding var distance: Float
    
    @State private var previousSnapPoint: Float?
    
    let snapPoints: [Float]
    
    private var step: Float {
        snapPoints.count > 1 ? snapPoints[1] - snapPoints[0] : 1.0
    }
    
    // MARK: Body
    var body: some View {
        ZStack {
            HStack {
                ForEach(snapPoints, id: \.self) { point in
                    circle(isActive: distance >= point)
                    
                    if point < snapPoints.last! {
                        Spacer()
                    }
                }
            }
            .padding(.top, 1)
            
            Slider(
                value: Binding(
                    get: {
                        distance
                    },
                    set: { newValue in
                        distance = nearestSnapPoint(for: newValue)
                    }
                ),
                in: snapPoints.first!...snapPoints.last!,
                step: step
            )
        }
    }
    
    // MARK: SubViews
    @ViewBuilder
    private func circle(isActive: Bool) -> some View {
        Circle()
            .fill(isActive ? .accent : Color(.quaternaryLabel))
            .frame(width: 12, height: 12)
    }
    
    // MARK: Action Handlers
    private func nearestSnapPoint(for value: Float) -> Float {
        let closestPoint = snapPoints.min(by: { abs($0 - value) < abs($1 - value) }) ?? value

        if closestPoint != previousSnapPoint {
            previousSnapPoint = closestPoint
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.impactOccurred()
        }
        
        return closestPoint
    }
}

// MARK: - Preview
#Preview {
    SliderWithSnap(distance: .constant(0), snapPoints: [1.0, 1.5, 2.0, 2.5, 3.0])
}
