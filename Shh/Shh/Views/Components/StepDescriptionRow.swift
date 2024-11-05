//
//  StepDescriptionRow.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/31/24.
//

import SwiftUI

struct StepDescriptionRow: View {
    let text: String
    let subText: String
    
    var body: some View {
        VStack(spacing: 10) {
            Text(text)
                .font(.title)
            Text(subText)
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.center)
        .fontWeight(.bold)
    }
}

#Preview {
    StepDescriptionRow(text: "얼마나 시끄러운가요?", subText: "측정 기준이 될 현재 장소의 소음을 측정해주세요.\n그보다 더 큰 소리를 내시면 알려드릴게요.")
}
