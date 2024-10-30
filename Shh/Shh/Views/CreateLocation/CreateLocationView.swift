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
    
    // MARK: Body
    var body: some View {
        VStack {
            PageIndicator(page: currentStep.rawValue)
            
            switch currentStep {
            case .nameInput:
                NameInputView(step: $currentStep)
            case .backgroundInput:
                BackgroundNoiseInputView(step: $currentStep)
            case .distanceInput:
                DistanceInputView(step: $currentStep)
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
    }
    
    // MARK: SubViews
    private var navigationBarBackButton: some View {
        Button {
            // TODO: 뒤로 가기
            print("뒤로 가기")
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
    case backgroundInput = 2
    case distanceInput = 3
}

// MARK: - Preview
#Preview {
    NavigationView {
        CreateLocationView()
    }
}
