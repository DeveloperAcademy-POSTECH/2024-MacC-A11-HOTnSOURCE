//
//  CustomButton.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/30/24.
//

import SwiftUI

struct CustomButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            buttonLabel
        }
        .buttonStyle(.plain)
    }
    
    private var buttonLabel: some View {
        Text(text)
            .font(.body)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .frame(maxWidth: 350)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .foregroundStyle(.accent)
            )
            .accessibilityLabel(text)
    }
}

#Preview {
    CustomButton(text: "Hello, World!") {
        print("hello")
    }
}
