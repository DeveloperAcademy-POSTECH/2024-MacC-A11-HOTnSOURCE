//
//  MainView.swift
//  Shh
//
//  Created by sseungwonnn on 11/16/24.
//

import SwiftUI

// MARK: - 메인 화면
struct MainView: View {
    // MARK: Properties
    @State private var showLoadingView: Bool = false
    
    // MARK: Body
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer(minLength: 20)
                
                Text("반가워요!\n소음이 걱정이신가요?")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer(minLength: 15)
                
                Text("아래 버튼을 눌러 시작해주세요")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)
                
                Spacer()
                    .frame(maxHeight: .infinity)
                
                Text("버튼 눌러 시작하기")
                    .font(.footnote)
                    .foregroundStyle(.gray)
                
                Spacer(minLength: 20)
                
                startButton
                
                Spacer(minLength: 20)
            }
            .padding(25)
            .background(.customBlack)
            
            // TODO: 로딩 화면
//            if showLoadingView {
//                LoadingView()
//                    .transition(.move(edge: .trailing))
//            }
        }
    }
    
    // MARK: SubViews
    private var startButton: some View {
        Button {
            withAnimation {
                showLoadingView = true
            }
        } label: {
            Image(systemName: "waveform")
                .font(.system(size: 60))
                .foregroundStyle(.white)
                .frame(width: 130, height: 130)
                .background {
                    Circle()
                        .fill(.accent)
                }
        }
    }
}

// MARK: - Preview
#Preview {
    MainView()
}
