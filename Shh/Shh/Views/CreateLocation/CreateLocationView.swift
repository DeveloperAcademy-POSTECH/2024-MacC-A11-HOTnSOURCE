//
//  CreateLocationView.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/30/24.
//

import SwiftUI

// MARK: - 장소 생성 화면(워크 스루 디자인 적용)
struct CreateLocationView: View {
    // MARK: Properties
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var routerManager: RouterManager
    
    @FocusState private var isFocused: Bool
    
    @State private var currentStep: CreateLocationStep = .nameInput
    @State private var name: String = ""
    @State private var backgroundNoise: Float = 0
    @State private var distance: Float = 0
    @State private var isMetering: Bool = false
    @State private var createComplete: Bool = false
    
    var isFirstUser: Bool = false
    
    // MARK: Body
    var body: some View {
        VStack {
            PageIndicator(page: currentStep.rawValue)
            
            switch currentStep {
            case .nameInput:
                NameInputView(
                    step: $currentStep,
                    name: $name,
                    isFocused: $isFocused.projectedValue
                )
            case .backgroundNoiseInput:
                BackgroundNoiseInputView(
                    step: $currentStep,
                    backgroundNoise: $backgroundNoise,
                    isMetering: $isMetering
                )
            case .distanceInput:
                DistanceInputView(
                    step: $currentStep,
                    distance: $distance,
                    createComplete: $createComplete,
                    isFirstUser: isFirstUser
                )
            }
        }
        .onTapGesture {
            isFocused = false
        }
        .padding(20)
        .navigationTitle("장소 생성")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                navigationBarBackButton
            }
        }
        .ignoresSafeArea(.keyboard)
        .onChange(of: createComplete) { newValue in
            if newValue {
                let newLocation = Location(id: UUID(), name: name, backgroundDecibel: backgroundNoise, distance: distance)
                
                locationManager.selectedLocation = newLocation
                locationManager.createLocation(newLocation)
                
                if isFirstUser {
                    // TODO: 온보딩 마지막 페이지로 네비게이트
                } else {
                    routerManager.pop()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        routerManager.push(view: .mainView(selectedLocation: newLocation))
                    }
                }
            }
        }
    }
    
    // MARK: SubViews
    private var navigationBarBackButton: some View {
        Button {
            if let previousStep = CreateLocationStep(rawValue: currentStep.rawValue - 1) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    currentStep = previousStep
                }
            }
        } label: {
            Text("뒤로")
        }
        .contentShape(Rectangle())
        .foregroundStyle(.secondary)
        .opacity(currentStep == .nameInput || isMetering ? 0 : 1)
    }
}

enum CreateLocationStep: Int {
    case nameInput = 1
    case backgroundNoiseInput = 2
    case distanceInput = 3
}

// MARK: - Preview
//#Preview {
//    NavigationView {
//        CreateLocationView()
//            .environmentObject(LocationManager())
//            .environmentObject(RouterManager())
//            .environmentObject(AudioManager())
//    }
//}
