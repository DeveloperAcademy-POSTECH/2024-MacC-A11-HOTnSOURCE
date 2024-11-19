//
//  HelpRow.swift
//  Shh
//
//  Created by Jia Jang on 11/19/24.
//

import SwiftUI

struct HelpRow: View {
    // MARK: Properties
    let row: HelpRowItem
    
    // MARK: Body
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(row.boxColor)
                
                Image(systemName: row.systemName)
                    .font(.largeTitle)
                    .foregroundStyle(.white)
            }
            .frame(width: 90, height: 90)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(row.title)
                    .foregroundStyle(.white)
                
                Text(row.description)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .bold()
            .padding(.trailing, 20)
            .frame(maxWidth: 260)
        }
    }
}
