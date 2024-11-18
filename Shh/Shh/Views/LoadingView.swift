//
//  MeteringBackgroundNoiseView.swift
//  Shh
//
//  Created by Eom Chanwoo on 11/17/24.
//

import SwiftUI

// MARK: - 로딩 화면; 로딩 중 배경 소음 측정
struct LoadingView: View {
    // MARK: Properties
    @State private var progress: CGFloat = 0.0
    @State private var isLoading: Bool = false
    @State private var message: LoadingMessage = .metering
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 20) {
            Text(message.text)
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(.gray)
            
            progressBar
        }
        .padding(20)
        .onAppear {
            startLoading()
        }
    }
    
    // MARK: SubViews
    private var progressBar: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(.gray.opacity(0.3))
                .frame(height: 15)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(.accent)
                .frame(width: progress, height: 15)
                .animation(.linear(duration: 3), value: progress)
        }
    }
}

// MARK: Action Handlers
private extension LoadingView {
    private func startLoading() {
        isLoading = true
        progress = 0.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                message = .beQuiet
            }
        }
        
        withAnimation(.linear(duration: 3)) {
            progress = .infinity
        }
        
        // TODO: 성공적으로 결과 반환받으면 로딩 상태 변경
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isLoading = false
        }
    }
}

// MARK: - 로딩 중 안내 텍스트
enum LoadingMessage {
    case metering
    case beQuiet
}

extension LoadingMessage {
    var text: String {
        switch self {
        case .metering:
        return NSLocalizedString("배경 소리를 확인하고 있어요!", comment: "로딩 화면 안내 텍스트1")
        case .beQuiet:
        return NSLocalizedString("조용한 상태를 유지하면 더 정확해져요!", comment: "로딩 화면 안내 텍스트2")
        }
    }
}

#Preview {
    LoadingView()
}
