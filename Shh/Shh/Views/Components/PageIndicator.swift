//
//  PageIndicator.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/30/24.
//

import SwiftUI

struct PageIndicator: View {
    let totalPages: Int = 3
    
    let page: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(1...totalPages, id: \.self) { index in
                circle(isActive: page >= index)
                
                if index < totalPages {
                    line
                }
            }
        }
    }
    
    @ViewBuilder
    private func circle(isActive: Bool) -> some View {
        if isActive {
            Circle()
                .fill(Color.accentColor)
                .frame(width: 16)
        } else {
            Circle()
                .stroke(Color.accentColor)
                .frame(width: 16)
        }
    }
    
    private var line: some View {
        Rectangle()
            .frame(width: 50, height: 1)
            .foregroundStyle(.accent)
    }
}

#Preview {
    PageIndicator(page: 1)
}
