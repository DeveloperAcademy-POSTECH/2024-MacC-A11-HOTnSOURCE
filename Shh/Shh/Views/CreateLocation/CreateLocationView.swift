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
    
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    
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
                    isFirstUser: isFirstLaunch
                )
            }
        }
        .padding(20)
        .navigationTitle("장소 생성")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(isFirstLaunch)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                navigationBarBackButton
            }
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            isFocused = false
        }
        .onAppear {
            createComplete = false
        }
        .onChange(of: createComplete) {
            if createComplete {
                if isFirstLaunch {
                    routerManager.push(view: .startView(name: name, backgroundNoise: backgroundNoise, distance: distance), isOnboarding: true)
                } else {
                    let newLocation = Location(id: UUID(), name: name, backgroundDecibel: backgroundNoise, distance: distance)
                    
                    locationManager.selectedLocation = newLocation
                    locationManager.createLocation(newLocation)
                    
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
        .hidden(currentStep == .nameInput || isMetering)
    }
}

enum CreateLocationStep: Int {
    case nameInput = 1
    case backgroundNoiseInput = 2
    case distanceInput = 3
}

extension CreateLocationStep {
    var text: String {
        switch self {
        case .nameInput: return NSLocalizedString("어디에서 사용하시나요?", comment: "장소 이름 입력 단계 설명")
        case .backgroundNoiseInput: return NSLocalizedString("주위의 소리를 들려주세요!", comment: "배경 소음 입력 단계 설명")
        case .distanceInput: return NSLocalizedString("상대방과 얼마나 가깝나요?", comment: "측정 반경 입력 단계 설명")
        }
    }
    
    var subText: String {
        switch self {
        case .nameInput: return NSLocalizedString("소음 측정이 필요한 곳의 이름을 알려주세요", comment: "장소 이름 입력 단계 보조 설명")
        case .backgroundNoiseInput: return NSLocalizedString("주변보다 더 큰 소리를 내면 알려드릴게요\n아래의 버튼을 눌러주세요", comment: "배경 소음 입력 단계 보조 설명")
        case .distanceInput: return NSLocalizedString("해당 거리에서 어떻게 들리는지\n계산해서 알려드릴게요", comment: "측정 반경 입력 단계 보조 설명")
        }
    }
}
