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
    @State private var percent = 20.0
    @State private var waveOffset = Angle(degrees: 0)
    
    let selectedLocation: Location
    
    private let notificationManager: NotificationManager = .init()
    
    // MARK: Body
    var body: some View {
        ZStack {
            content
        }
        .navigationTitle(selectedLocation.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    routerManger.push(view: .meteringInfoView)
                } label: {
                    Label("정보", systemImage: "info.circle")
                        .font(.title2)
                        .fontWeight(.medium)
                }
            }
        }
        .onDisappear {
            audioManager.stopMetering()
        }
    }
    
    // MARK: SubViews
    private var content: some View {
        VStack {
            Spacer()
            
            if !audioManager.isMetering {
                VStack(alignment: .center) {
                    Text("아래 버튼을 눌러")
                    Text("측정을 시작해주세요")
                }
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.gray)
                
                Spacer()
                Spacer()
            }
            
            HStack {
                if audioManager.isMetering {
                    userNoiseStatusInfo
                }
                
                Spacer()
                
                VStack {
                    Spacer()
                    
                    VStack(spacing: 14) {
                        if audioManager.isMetering {
                            locationInfo
                        } else {
                            Spacer()
                        }
                        
                        HStack {
                            meteringToggleButton
                            meteringStopButton
                        }
                        .navigationTitle(selectedLocation.name)
                        .onChange(of: audioManager.userNoiseStatus) { newValue in
                            Task {
                                if let type = newValue.notificationType {
                                    await notificationManager.sendNotification(type: type)
                                }
                            }
                        }
                    }
                }
            }
            .frame(height: 100)
            
            Spacer().frame(height: 40)
        }
        .padding(.horizontal, 24)
    }
    
    private var userNoiseStatusInfo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(audioManager.userNoiseStatus.korean)
                .font(.system(size: 56, weight: .bold, design: .default))
                .foregroundStyle(.customWhite)
            
            Text(audioManager.userNoiseStatus.writing)
                .font(.callout)
                .fontWeight(.bold)
                .foregroundStyle(.black)
                .lineLimit(2, reservesSpace: true)
        }
    }
    
    private var locationInfo: some View {
        HStack {
            Text("\(Int(selectedLocation.backgroundDecibel)) dB")
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(.customWhite)
            
            Rectangle()
                .fill(.customWhite)
                .frame(width: 1, height: 18)
            
            Text("\(Int(selectedLocation.distance)) m")
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(.customWhite)
        }
    }
    
    private var meteringToggleButton: some View {
        // TODO: 시작과 재개 함수를 합칠 예정; 오디오 매니저 다루면서 수정 예정
        Button {
            if audioManager.isMetering {
                audioManager.pauseMetering()
            } else {
                if !isStarted {
                    do {
                        try audioManager.startMetering(location: selectedLocation)
                        isStarted = true
                    } catch {
                        // TODO: 재생버튼 다시 눌러달라는 알러트 일단은 팝
                        routerManger.pop()
                    }
                } else {
                    audioManager.resumeMetering(location: selectedLocation)
                }
            }
        } label: {
            Image(systemName: audioManager.isMetering ? "pause.fill" : "play.fill")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.customWhite)
                .padding()
                .background {
                    Circle()
                        .fill(.customBlack)
                }
        }
        .accessibilityLabel(audioManager.isMetering ? "Pause metering" : "Resume metering")
        .accessibilityHint("Starts or pauses noise metering")
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
                .background {
                    Circle()
                        .fill(.customBlack)
                }
        }
        .accessibilityLabel("Stop metering")
        .accessibilityHint("Stop noise metering")
    }
}

#Preview {
    MainView(selectedLocation: Location(id: UUID(), name: "도서관", backgroundDecibel: 40.0, distance: 2.0))
}
