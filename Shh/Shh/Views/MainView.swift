//
//  MainView.swift
//  Shh
//
//  Created by sseungwonnn on 10/14/24.
//

import SwiftUI

// MARK: - 메인 뷰; 사용자의 소음 정도를 나타냅니다.
struct MainView: View {
    // MARK: Properties
    @EnvironmentObject var routerManger: RouterManager
    
    @StateObject private var audioManager: AudioManager = {
        do {
            return try AudioManager()
        } catch {
            fatalError("AudioManager 초기화 실패: \(error.localizedDescription)")
        }
    }()
    
    @State private var isStarted: Bool = false
    
    // MARK: Body
    var body: some View {
        ZStack {
            // 배경
            backgroundWave
            
            // 눈금
            beaker
            
            // 내용
            VStack {
                Spacer()
                
                HStack {
                    userNoiseStatusInfo
                    
                    Spacer()
                    
                    VStack(spacing: 14) {
                        placeInfo
                        
                        HStack {
                            meteringToggleButton
                            
                            meteringStopButton
                        }
                    }
                }
            }
            .padding(.horizontal, 24)

        }
        .navigationTitle("도서관") // TODO: 장소 수정 예정
    }
    
    // MARK: SubViews
    private var backgroundWave: some View {
        VStack {
            Spacer()
            
            // TODO: 높이 수정 예정
            // TODO: 파도 추가 예정
            Rectangle()
                .fill(audioManager.userNoiseStatus.statusColor)
            .ignoresSafeArea(edges: .bottom)
            .frame(height: 200)
        }
    }
    
    private var beaker: some View {
        // TODO: 간격 수정 예정
        VStack {
            Spacer().frame(height: 80)
            
            beakerRow
            Spacer()
            
            beakerRow
            Spacer()
            
            beakerRow
            Spacer()
            Spacer()
        }
    }
    
    private var beakerRow: some View {
        HStack {
            Rectangle()
                .fill(.white)
                .opacity(0.4)
                .frame(width: 27, height: 4)
            
            Spacer()
        }
    }
    
    private var userNoiseStatusInfo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("양호") // TODO: 수정 예정
                .font(.system(size: 56))
                .fontWeight(.bold)
                .foregroundStyle(.customWhite)
            
            Text("지금 아주 잘하고 있어요!")
            // TODO: 수정 예정
                .font(.callout)
                .fontWeight(.bold)
                .foregroundStyle(.black)
        }
    }
    
    private var placeInfo: some View {
        HStack {
            Text("40dB") // TODO: 수정예정
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(.customWhite)
            
            Rectangle()
                .fill(.customWhite)
                .frame(width: 1, height: 18)
            
            Text("2 m") // TODO: 수정예정
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(.customWhite)
        }
    }
    
    private var meteringToggleButton: some View {
        Button {
            if audioManager.isMetering {
                audioManager.pauseMetering()
            } else {
                if !isStarted {
                    do {
                        try audioManager.startMetering(backgroundDecibel: 40.0, distance: 2.0)
                        isStarted = true
                    } catch {
                        // TODO: 재생버튼 다시 눌러달라는 알러트 일단은 팝
                        routerManger.pop()
                    }
                } else {
                    audioManager.resumeMetering(backgroundDecibel: 40.0, distance: 2.0)
                }
            }
        } label: {
            Image(systemName: audioManager.isMetering ? "pause.fill" : "play.fill")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.customWhite)
                .padding()
                .background(
                    Circle()
                        .fill(.customBlack)
                )
        }
    }
    
    private var meteringStopButton: some View {
        Button {
            audioManager.stopMetering()
            isStarted = false // 시작 상태 초기화
            routerManger.pop() // 정지 시 선택창으로 이동
        } label: {
            Image(systemName: "xmark")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.customWhite)
                .padding()
                .background(
                    Circle()
                        .fill(.customBlack)
                )
        }
    }
}

#Preview {
    MainView()
}
