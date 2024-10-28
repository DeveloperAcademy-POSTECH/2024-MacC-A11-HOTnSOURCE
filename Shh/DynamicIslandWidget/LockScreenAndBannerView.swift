//
//  LockScreenAndBannerView.swift
//  DynamicIslandWidgetExtension
//
//  Created by sseungwonnn on 10/28/24.
//

import SwiftUI

struct LockScreenAndBannerView: View {
    let place: Place
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("Shh-!")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
                Text("\(place.name)")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(.gray)
            }
            Spacer()
            HStack {
                // TODO: 수정 예정
                Text("소음 측정 중이에요!")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
                Button {
                } label: {
                    Label("일지정지", systemImage: "pause.circle.fill")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.green)
                }
            }
            Spacer()
        }
        .padding()
        .background(.black)
        .activityBackgroundTint(Color.black)
    }
}
