//
//  InfoRow.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 10/31/24.
//

import SwiftUI

struct InfoRow: View {
    var item: InfoItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.title)
                .fontWeight(.bold)
                .foregroundStyle(.accent)
            
            Divider()
                .background(.white)
                .padding(.bottom)
            
            VStack(alignment: .leading, spacing: 5) {
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
