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
    
    @State private var currentStep: CreateLocationStep = .nameInput
    @State private var name: String = ""
    @State private var backgroundNoise: Float = 0
    @State private var distance: Float = 0
    @State private var createComplete: Bool = false
    
    var isFirstUser: Bool = false
    
    // MARK: Body
    var body: some View {
        VStack {
            PageIndicator(page: currentStep.rawValue)
            
            switch currentStep {
            case .nameInput:
                NameInputView(step: $currentStep, name: $name)
            case .backgroundNoiseInput:
                BackgroundNoiseInputView(step: $currentStep, backgroundNoise: $backgroundNoise)
            case .distanceInput:
                DistanceInputView(step: $currentStep, distance: $distance, createComplete: $createComplete, isFirstUser: isFirstUser)
            }
        }
        .padding(20)
        .navigationTitle("장소 생성")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                navigationBarBackButton
            }
        }
        .ignoresSafeArea(.keyboard)
        .onChange(of: createComplete) { newValue in
            if newValue {
                // TODO: 장소 생성 함수
                if isFirstUser {
                    // TODO: 온보딩 마지막 페이지로 네비게이트
                } else {
                    // TODO: 바로 메인 화면으로 네비게이트(0.7초 딜레이)
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
            Label("뒤로 가기", systemImage: "chevron.left")
                .labelStyle(.iconOnly)
                .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
    }
}

enum CreateLocationStep: Int {
    case nameInput = 1
    case backgroundNoiseInput = 2
    case distanceInput = 3
}

// MARK: - Preview
#Preview {
    NavigationView {
        CreateLocationView()
    }
}
