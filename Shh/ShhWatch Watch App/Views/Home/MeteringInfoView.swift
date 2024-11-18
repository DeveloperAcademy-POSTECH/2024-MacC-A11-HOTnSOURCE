//
//  MeteringInfoView.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 10/31/24.
//

import SwiftUI

// MARK: - 측정 정보 뷰: 측정 기준에 대한 FAQ
struct MeteringInfoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                ForEach(Array(InfoItem.infoItemList.enumerated()), id: \.offset) { _, infoItem in
                    InfoRow(item: infoItem)
                }
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    MeteringInfoView()
}
