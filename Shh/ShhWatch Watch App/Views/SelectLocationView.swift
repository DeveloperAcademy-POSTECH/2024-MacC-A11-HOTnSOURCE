//
//  SelectLocationView.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 10/30/24.
//

import SwiftUI

// MARK: - 장소 선택 뷰: iOS에서 가져온 장소 리스트를 보여줌
struct SelectLocationView: View {
    // MARK: Properties
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 16) {
            Text("Select Location")
        }
        .navigationTitle("장소 선택")
        .scrollIndicators(.hidden)
    }
    
    // MARK: SubViews
}

#Preview {
    SelectLocationView()
}
