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

                if isMetering {
                    Button(intent: PauseMeteringIntent()) {
                        Text("일시정지")
                    }
                } else {
                    Button(intent: StartMeteringIntent()) {
                        Text("측정하기")
                    }
                }
            }
            Spacer()
        }
        .padding()
        .background(.black)
        .activityBackgroundTint(.black)
    }
}
