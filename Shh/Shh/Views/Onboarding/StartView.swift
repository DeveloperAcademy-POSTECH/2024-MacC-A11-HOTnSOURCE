//
//  StartView.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/31/24.
//

import SwiftUI

// MARK: - 온보딩 > 시작 페이지
struct StartView: View {
    // MARK: Properties
    @EnvironmentObject var locationManager: LocationManager
    
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    
    let name: String
    let backgroundNoise: Float
    let distance: Float
    
    private let notificationManager: NotificationManager = NotificationManager()
    
    // MARK: Body
    var body: some View {
        VStack {
            Spacer()
            
            startComment
            
            Spacer()
            
            SsambbongAsset(image: .completeAsset)
            
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            
            startButton
        }
        .padding(20)
        .onAppear {
            Task {
                await notificationManager.requestPermission()
            }
        }
    }
    
    // MARK: SubViews
    private var startComment: some View {
        VStack(spacing: 6) {
            Text("모든 준비가 완료되었어요!")
                .font(.title)
            
            Spacer().frame(height: 6)
            
            Text("시끄러운 소리를 내면 알려드릴게요!")
                .font(.callout)
                .foregroundStyle(.secondary)
            
            Text("* 알림 권한을 허용해주세요")
                .font(.caption2)
                .foregroundStyle(.accent)
        }
        .fontWeight(.bold)
    }
    
    private var startButton: some View {
        CustomButton(text: "시작하기") {
            let newLocation = Location(id: UUID(), name: name, backgroundDecibel: backgroundNoise, distance: distance)
            
            locationManager.selectedLocation = newLocation
            locationManager.createLocation(newLocation)
            
            isFirstLaunch = false
        }
    }
}

// MARK: - Preview
#Preview {
    StartView(name: "name", backgroundNoise: 30.0, distance: 2.0)
}
