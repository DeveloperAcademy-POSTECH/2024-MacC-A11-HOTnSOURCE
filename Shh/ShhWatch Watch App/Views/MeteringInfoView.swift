//
//  MeteringInfoView.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 10/31/24.
//

import SwiftUI

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
