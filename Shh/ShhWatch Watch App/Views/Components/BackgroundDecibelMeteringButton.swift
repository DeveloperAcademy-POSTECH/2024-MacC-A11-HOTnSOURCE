//
//  BackgroundDecibelMeteringButton.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 11/1/24.
//

import SwiftUI

struct BackgroundDecibelMeteringButton: View {
    @Binding var backgroundDecibel: Float
    @Binding var isShowingProgressView: Bool
    
    var body: some View {
        Image(systemName: "mic.circle.fill")
            .font(.title2)
            .foregroundStyle(.green)
            .onTapGesture {
                isShowingProgressView = true
                // TODO: 소음 관련 로직이 들어갈 예정
            }
    }
}
