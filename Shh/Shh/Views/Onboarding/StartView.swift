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
    
    // MARK: Body
    var body: some View {
        VStack {
            Spacer()
            
            StepDescriptionRow(
                text: "모든 준비가 완료되었어요!",
                subText: "지금 바로 Shh-!와 함께\n조용한 작업을 시작해볼까요?"
            )
            
            Spacer()
            
            SsambbongAsset(image: .completeAsset)
            
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            
            startButton
        }
        .padding(20)
    }
    
    // MARK: SubViews
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
