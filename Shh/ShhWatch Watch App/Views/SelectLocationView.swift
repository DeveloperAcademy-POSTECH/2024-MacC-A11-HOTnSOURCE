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
    @EnvironmentObject var routerManager: RouterManager
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 16) {
            Button {
                routerManager.push(view: .mainView)
            } label: {
                Text("메인 뷰로 이동")
            }
        }
        .navigationTitle("장소 선택")
        .scrollIndicators(.hidden)
    }
    
    // MARK: SubViews
}

#Preview {
    SelectLocationView()
}
