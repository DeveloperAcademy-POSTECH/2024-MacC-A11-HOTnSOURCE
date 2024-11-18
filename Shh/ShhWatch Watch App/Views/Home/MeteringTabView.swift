//
//  MeteringTabView.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 10/30/24.
//

import SwiftUI

// MARK: - 홈 뷰: Controls, Metering, Info View로 구성
struct MeteringTabView: View {
    // MARK: Properties
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var audioManager: AudioManager
    
    @State private var tabSelection: Tabs = .home
    
    @Binding var backgroundDecibel: Float
    
    // MARK: Body
    var body: some View {
        TabView(selection: $tabSelection) {
            ControlsView()
                .tag(Tabs.controls)
            
            MeteringView()
                .tag(Tabs.home)
            
            MeteringInfoView()
                .tag(Tabs.info)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            audioManager.startMetering(backgroundDecibel: backgroundDecibel)
        }
        .onChange(of: audioManager.userNoiseStatus) {
            Task {
                if audioManager.userNoiseStatus == .caution {
                    await NotificationManager.shared.sendNotification(.caution)
                    await NotificationManager.shared.sendNotification(.persistent)
                    await NotificationManager.shared.sendNotification(.recurringAlert)
                } else {
                    NotificationManager.shared.removeAllNotifications()
                }
            }
        }
    }
}
