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
            }
            .tint(.accent)
        } else {
            Button(intent: StartMeteringIntent()) {
                Label("재시작", systemImage: "play.fill")
            }
            .tint(.accent)
        }
    }
}

#Preview {
    MeteringButton(isMetering: true)
}
