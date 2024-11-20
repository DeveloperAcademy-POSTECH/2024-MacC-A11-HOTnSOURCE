//
//  LoadingView.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 11/19/24.
//

import SwiftUI

// MARK: - 로딩 화면; 로딩 중 배경 소음 측정
struct LoadingView: View {
    // MARK: Properties
    @EnvironmentObject var audioManager: AudioManager
    
    @State private var progress: CGFloat = 0.0
    @State private var message: LoadingMessage = .metering
    @State private var isMeteringFinished: Bool = false
    @State private var isMeteringFailed: Bool = false
    @State private var isFirstMetering: Bool = true
    @State private var pushMeteringView: Bool = false
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text(message.text)
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(.gray)
            
            progressBar
            
            Spacer()
        }
        .padding(20)
        .background(.customBlack)
        .accessibilityHint("배경 소음을 측정하기 위한 로딩중입니다. 측정을 마치면 측정 뷰로 이동합니다.")
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $pushMeteringView) {
            MeteringTabView()
        }
        .task {
            await startLoading()
        }
        .onChange(of: isMeteringFinished) {
            if isMeteringFinished && !isMeteringFailed {
                pushMeteringView = true
            }
        }
        .alert(isPresented: $isMeteringFailed) {
            Alert(
                title: Text("큰 소리를 들었어요"),
                message: Text("비정상적으로 큰 소리가 들어가면 측정이 정확하지 않을 수 있어요. 다시 확인할까요?"),
                primaryButton: .cancel(Text("괜찮아요")) {
                    pushMeteringView = true
                },
                secondaryButton: .default(Text("다시 확인할게요")) {
                    Task {
                        await startLoading()
                    }
                }
            )
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
                .frame(maxWidth: progress)
                .frame(height: 15)
        }
    }
    
    // MARK: Action Handlers
    private func startLoading() async {
        isMeteringFinished = false
        isMeteringFailed = false
        message = .metering
        progress = 0.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                message = .beQuiet
            }
        }
        
        withAnimation(.linear(duration: 3)) {
            progress = .infinity
        }
        
        do {
            try await meteringBackgroundDecibel()
        } catch AudioManagerError.invalidBackgroundNoise {
            isMeteringFailed = true
        } catch {
            // TODO: 구체적인 에러 핸들링 필요; 현재는 큰 소리가 감지됐을 때만 처리함
            progress = 0.0
            print(error.localizedDescription)
        }
    }
    
    private func meteringBackgroundDecibel() async throws {
        if isFirstMetering {
            try audioManager.setAudioSession()
            isFirstMetering = false
        }
        
        try await audioManager.meteringBackgroundDecibel()
        isMeteringFinished = true
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
        return NSLocalizedString("배경 소리를\n확인하고 있어요!", comment: "로딩 화면 안내 텍스트1")
        case .beQuiet:
        return NSLocalizedString("조용한 상태를 유지하면\n더 정확해져요!", comment: "로딩 화면 안내 텍스트2")
        }
    }
}
