//
//  ControlsView.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 11/1/24.
//

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var routerManager: RouterManager
    @EnvironmentObject var audioManager: AudioManager
    
    @Binding var isAnimating: Bool
    
    // TODO: 추후 재검토 필요
    let selectedLocation: Location
    
    var body: some View {
        VStack {
            HStack {
                meteringStopButton
                editingButton
            }
            
            meteringToggleButton
        }
        .frame(maxWidth: 150)
    }
    
    private var meteringStopButton: some View {
        VStack {
            Button {
                routerManager.pop()
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            // TODO: button color가 어둡게 나오는 이슈 발생 -> opacity로 임시 대처
            .buttonStyle(BorderedButtonStyle(tint: Color.red.opacity(10)))
            
            Text("종료")
        }
    }
    
    private var meteringToggleButton: some View {
        VStack {
            Button {
                if audioManager.isMetering {
                    audioManager.pauseMetering()
                } else {
                    audioManager.startMetering(location: selectedLocation)
                }
                
                isAnimating.toggle()
            } label: {
                Image(systemName: audioManager.isMetering ? "pause.fill" : "play.fill")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            .buttonStyle(BorderedButtonStyle(tint: Color.green.opacity(audioManager.isMetering ? 2 : 10)))
            
            Text(audioManager.isMetering ? "일시정지" : "재개")
        }
    }
    
    private var editingButton: some View {
        VStack {
            Button {
                routerManager.push(view: .editLocationView)
            } label: {
                Image(systemName: "square.and.pencil")
                    .foregroundStyle(.white)
            }
            
            Text("수정")
        }
    }
}
