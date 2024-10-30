//
//  SelectLocationView.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 10/30/24.
//

import SwiftUI

struct SelectLocationView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Select Location")
        }
        .navigationTitle("장소 선택")
        .scrollIndicators(.hidden)
    }
}

#Preview {
    SelectLocationView()
}
