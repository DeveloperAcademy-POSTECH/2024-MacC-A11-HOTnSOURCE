//
//  InfoRow.swift
//  Shh
//
//  Created by sseungwonnn on 10/20/24.
//

import SwiftUI

struct InfoRow: View {
    var item: InfoItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.title)
                .font(.title3)
                .fontWeight(.bold)
            Divider()
                .background(.white)
                .padding(.bottom)
            
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(item.description.enumerated()), id: \.offset) { _, description in
                    Text(description)
                        .font(.body)
                        .fontWeight(.medium)
                }
            }
        }
    }
}

#Preview {
    InfoRow(item: InfoItem(title: "title", description: ["description1", "description2"]))
}
