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
                text: "얼마나 가깝나요?",
                subText: "조심해야 할 대상이 있다면,\n나로부터 얼마나 멀리 있는지 입력해주세요.\n그 쪽에서 어떻게 들리는지를 기준으로 알려드릴게요."
            )
            
            Spacer()
            
            SsambbongAsset(image: .distanceInputAsset)
            
            Spacer()

            distanceInputRow
            
            Spacer()
            
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
            
            Spacer().frame(height: 10)
            
            SliderWithSnap(distance: $distance, snapPoints: [1.0, 1.5, 2.0, 2.5, 3.0])
            
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
                .foregroundStyle(.tertiary)
        }
    }
}

// MARK: - Preview
#Preview {
    DistanceInputView(step: .constant(.distanceInput), distance: .constant(0), createComplete: .constant(false), isFirstUser: true)
}
