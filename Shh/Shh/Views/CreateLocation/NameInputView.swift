//
//  NameInputView.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/30/24.
//

import SwiftUI

// MARK: - 장소 생성 > 이름 입력 화면
struct NameInputView: View {
    // MARK: Properties
    @Binding var step: CreateLocationStep
    
    // MARK: Body
    var body: some View {
        VStack {
            descriptionRow
            
            Spacer()
            
            NextStepButton(step: $step)
        }
    }
    
    // MARK: SubViews
    private var descriptionRow: some View {
        VStack(spacing: 10) {
            Text("어떤 장소인가요?")
                .font(.title)
            Text("사용할 곳의 이름을 작성해주세요")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .fontWeight(.bold)
    }
}

// MARK: - Preview
#Preview {
    NameInputView(step: .constant(.nameInput))
}
