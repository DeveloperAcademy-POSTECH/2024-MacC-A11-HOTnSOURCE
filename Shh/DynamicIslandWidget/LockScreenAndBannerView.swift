//
//  LockScreenAndBannerView.swift
//  DynamicIslandWidgetExtension
//
//  Created by sseungwonnn on 10/28/24.
//

import SwiftUI

struct LockScreenAndBannerView: View {
    let isMetering: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Shh-!")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
            }
            
            Spacer()
            
            HStack {
                Text(isMetering ? "소음을 대신 듣고 있어요!" : "버튼을 눌러 다시 시작해주세요")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
                
                MeteringButton(isMetering: isMetering)
            }
        }
        .padding()
        .background(.black)
        .activityBackgroundTint(.black)
    }
}
