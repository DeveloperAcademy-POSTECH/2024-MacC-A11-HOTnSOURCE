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
                audioManager.isMetering = false
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            // TODO: button color가 어둡게 나오는 이슈 발생. 해결방안을 찾기 전까지 opacity로 임시 대처.
            .buttonStyle(BorderedButtonStyle(tint: Color.red.opacity(10)))
            
            Text("종료")
        }
    }
    
    private var meteringToggleButton: some View {
        VStack {
            Button {
                audioManager.isMetering.toggle()
            } label: {
                Image(systemName: audioManager.isMetering ? "pause.fill" : "play.fill")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            // TODO: button color가 어둡게 나오는 이슈 발생. (opacity로 임시 대처)
            .buttonStyle(BorderedButtonStyle(tint: .accent.opacity(audioManager.isMetering ? 2 : 10)))
            
            Text(audioManager.isMetering ? "일시정지" : "재개")
        }
    }
}
