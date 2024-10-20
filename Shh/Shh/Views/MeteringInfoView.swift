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
                ForEach(InfoItem.infoItemList, id: \.title) { infoItem in
                    InfoRow(item: infoItem)
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("측정 정보")
        
    }
    
}

#Preview {
    MeteringInfoView()
}
