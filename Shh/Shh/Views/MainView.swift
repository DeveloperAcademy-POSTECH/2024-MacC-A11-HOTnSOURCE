//
//  MainView.swift
//  Shh
//
//  Created by sseungwonnn on 11/16/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var audioManager: AudioManager
    
    @State private var backgroundNoise: Float = 20.0
    @State private var isShowingProgressView: Bool = false
    
    var body: some View {
        // TODO: 디자인 예정
        VStack {
            BackgroundDecibelMeteringButton(backgroundDecibel: $backgroundNoise, isShowingProgressView: $isShowingProgressView)
            
            Text("배경소음: \(backgroundNoise)")
            
            CustomButton(text: "측정 뷰로 이동") {
                router.push(view: .meteringView)
            }
        }
        .onAppear {
            do {
                try audioManager.setAudioSession()
            } catch {
                print("oops")
            }
        }
    }
}

#Preview {
    MainView()
}
