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

            distanceInputRow
            
            Spacer(minLength: 16)
            
            CustomButton(text: isFirstUser ? "다음으로" : "완료하기") {
                createComplete = true
            }
            .disabled(distance.isZero)
        }
    }
    
    // MARK: SubViews
    private var distanceInputRow: some View {
        VStack(alignment: .leading) {
            Text("\(distance, specifier: "%.1f") m")
                .font(.title)
            
            Text("정도 떨어져 있어요")
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            Spacer().frame(height: 22)
            
            SliderWithSnap(distance: $distance, snapPoints: [1.0, 1.5, 2.0, 2.5, 3.0])
            
            Spacer().frame(height: 5)
            
            HStack {
                Text("1m")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("2m")
                    .frame(maxWidth: .infinity)
                Text("3m")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
        .fontWeight(.bold)
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.quaternary)
        }
    }
}

// MARK: - Preview
#Preview {
    DistanceInputView(step: .constant(.distanceInput), distance: .constant(0), createComplete: .constant(false), isFirstUser: true)
}
