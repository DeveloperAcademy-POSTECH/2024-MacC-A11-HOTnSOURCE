//
//  LockScreenAndBannerView.swift
//  DynamicIslandWidgetExtension
//
//  Created by sseungwonnn on 10/28/24.
//

import SwiftUI

struct LockScreenAndBannerView: View {
    let isMetering: Bool
    let location: Location
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("Shh-!")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
                Text("\(location.name)")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(.gray)
            }
            Spacer()
            HStack(alignment: .bottom) {
                Text(isMetering ? "소음을 대신 듣고 있어요!" : "측정이 일시정지되었습니다.")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
                Button {
                    // TODO: APP INTENTS 추가 예정
                } label: {
                    Label(isMetering ? "일지정지" : "재시작", systemImage: "play.circle.fill")
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
