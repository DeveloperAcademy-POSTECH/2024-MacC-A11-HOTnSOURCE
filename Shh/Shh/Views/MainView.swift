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
    
    var body: some View {
        // TODO: 디자인 예정
        VStack {
            Text("진짜 메인뷰")
            Button {
                Task {
                    do {
                        try await audioManager.meteringBackgroundDecibel()
                    } catch {
                        print("웁스")
                    }
                }
            } label: {
                Text("배경 소음 측정")
            }
            CustomButton(text: "측정 뷰로 이동") {
                router.push(view: .meteringView)
            }
        }
        .onAppear {
            do {
                try audioManager.setAudioSession()
            } catch {
                print("웁스")
            }
        }
    }
}

#Preview {
    MainView()
}
