//
//  LoadingDots.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/30/24.
//

import SwiftUI

struct LoadingDots: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3) { index in
                Circle()
                    .frame(width: 10, height: 10)
                    .offset(y: isAnimating ? -8 : 8)
                    .animation(
                        .easeInOut(duration: 0.4)
                        .repeatForever()
                        .delay(0.1 * Double(index)),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
        .foregroundColor(.white)
    }
}

#Preview {
    LoadingDots()
}
