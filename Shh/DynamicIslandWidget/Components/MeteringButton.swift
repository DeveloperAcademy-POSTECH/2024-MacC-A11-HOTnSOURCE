//
//  StartMeteringButton.swift
//  Shh
//
//  Created by Eom Chanwoo on 11/11/24.
//

import SwiftUI

struct MeteringButton: View {
    let isMetering: Bool
    
    var body: some View {
        if isMetering {
            Button(intent: PauseMeteringIntent()) {
                Label("일시정지", systemImage: "pause.fill")
                    .labelStyle(.iconOnly)
            }
            .buttonStyle(.plain)
            .padding()
            .background {
                Circle()
                    .fill(.accent)
            }
        } else {
            Button(intent: StartMeteringIntent()) {
                Label("측정하기", systemImage: "play.fill")
                    .labelStyle(.iconOnly)
            }
            .buttonStyle(.plain)
            .padding()
            .background {
                Circle()
                    .fill(.accent)
            }
        }
    }
}

#Preview {
    MeteringButton(isMetering: true)
}
