//
//  MeteringInfoSheet.swift
//  Shh
//
//  Created by sseungwonnn on 10/20/24.
//

import SwiftUI

struct MeteringInfoSheet: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Spacer()
                
                Text("자주 묻는 질문")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                VStack(spacing: 60) {
                    ForEach(Array(InfoItem.infoItemList.enumerated()), id: \.offset) { _, infoItem in
                        InfoRow(item: infoItem)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    MeteringInfoSheet()
}
