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
            HStack(alignment: .bottom) {
                Text("소음을 대신 듣고 있어요!")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
                Button {
                    // TODO: APP INTENTS 추가 예정
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
