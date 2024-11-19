//
//  ControlsView.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 11/16/24.
//

import SwiftUI

struct ControlsView: View {
    // MARK: Properties
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var audioManager: AudioManager
    
    // MARK: Body
    var body: some View {
        HStack {
            meteringStopButton
            meteringToggleButton
        }
        .frame(maxWidth: 150)
    }
    
    // MARK: Subviews
    private var meteringStopButton: some View {
        VStack {
            Button {
                audioManager.stopMetering()
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            // TODO: button color가 어둡게 나오는 이슈 발생 -> opacity로 임시 대처
            .buttonStyle(BorderedButtonStyle(tint: .red.opacity(3.5)))
            
            Text("종료")
        }
    }
    
    private var meteringToggleButton: some View {
        VStack {
            Button {
                if audioManager.isMetering {
                    audioManager.pauseMetering()
                } else {
                    audioManager.startMetering()
                }
            } label: {
                Image(systemName: audioManager.isMetering ? "pause.fill" : "play.fill")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            .buttonStyle(BorderedButtonStyle(tint: .accent.opacity(audioManager.isMetering ? 2 : 3.5)))
            
            Text(audioManager.isMetering ? "일시정지" : "재개")
        }
    }
}
