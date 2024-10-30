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
    @EnvironmentObject var routerManager: RouterManager
    @EnvironmentObject var audioManager: AudioManager

    @State private var percent = 20.0
    @State private var waveOffset = Angle(degrees: 0)
    let selectedLocation: Location
    
    private let notificationManager: NotificationManager = .init()
    
    // MARK: Body
    var body: some View {
        VStack {
            locationInfo
            Spacer()
            
            // TODO: 대충 멋진 에셋
            
            HStack(alignment: .center) {
                userNoiseStatusInfo
                Spacer()
                
                meteringToggleButton
            }
            Spacer().frame(height: 20)
        }
        .padding(.horizontal, 16)
        .navigationTitle(selectedLocation.name)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                HStack(alignment: .center) {
                    Button {
                        routerManager.push(view: .editLocationView(location: selectedLocation))
                    } label: {
                        Text("수정")
                            .font(.body)
                            .fontWeight(.regular)
                    }
                    
                    Button {
                        routerManager.push(view: .meteringInfoView)
                    } label: {
                        Label("정보", systemImage: "info.circle")
                            .font(.body)
                            .fontWeight(.regular)
                    }
                }
            }
        }
        .onAppear {
            // TODO: 3,2,1 뷰 나타나기
            do {
                try audioManager.setAudioSession()
            } catch {
                // TODO: 문제 발생 알러트 띄우기
                print("오디오 세션 설정 중에 문제가 발생했습니다.")
                routerManager.pop()
            }
        }
        .onChange(of: audioManager.userNoiseStatus) { newValue in
            Task {
                if newValue == .caution {
                    await notificationManager.sendNotification()
                }
            }
        }
        .onDisappear {
            audioManager.stopMetering()
        }
    }
    
    // MARK: SubViews
    private var locationInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("배경 소음 | \(Int(selectedLocation.backgroundDecibel)) dB")
                    
                Text("측정 반경 | \(String(format: "%.1f", selectedLocation.distance)) m")
            }
            .font(.body)
            .fontWeight(.regular)
            .foregroundStyle(.gray)
            
            Spacer()
        }
    }
    
    private var userNoiseStatusInfo: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(audioManager.isMetering ? audioManager.userNoiseStatus.message : "일시정지됨")
                .font(.system(size: 56, weight: .bold, design: .default))
                .fontWeight(.bold)
                .foregroundStyle(.customWhite)
            
            Text(audioManager.isMetering ? audioManager.userNoiseStatus.writing : "측정을 다시 시작해주세요")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundStyle(.customWhite)
        }
    }
    
    private var meteringToggleButton: some View {
        Button {
            audioManager.isMetering ? audioManager.pauseMetering() : audioManager.startMetering(location: selectedLocation)
        } label: {
            Image(systemName: audioManager.isMetering ? "pause.fill" : "play.fill")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.customWhite)
                .padding(.horizontal, 21)
                .padding(.vertical, 16)
                .background {
                    Circle()
                        .fill(.customBlack)
                }
        }
        .accessibilityLabel(audioManager.isMetering ? "Pause metering" : "Resume metering")
        .accessibilityHint("Starts or pauses noise metering")
    }
}

#Preview {
    NavigationStack {
        MainView(selectedLocation: Location(id: UUID(), name: "도서관", backgroundDecibel: 40.0, distance: 2.0))
    }
}
