//
//  MeteringInfoView.swift
//  Shh
//
//  Created by sseungwonnn on 10/20/24.
//

import SwiftUI

struct MeteringInfoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 60) {
                ForEach(Array(InfoItem.infoItemList.enumerated()), id: \.offset) { _, infoItem in
                    InfoRow(item: infoItem)
                }
                Spacer()
            }
            .padding()
        }
        .background(.customBlack)
        .navigationTitle("자주 묻는 질문")
    }
}

#Preview {
    MeteringInfoView()
}
