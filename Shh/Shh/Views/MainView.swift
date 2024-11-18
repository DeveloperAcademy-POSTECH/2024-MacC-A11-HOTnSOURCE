//
//  MainView.swift
//  Shh
//
//  Created by sseungwonnn on 11/16/24.
//

import SwiftUI

// MARK: - 메인 화면
struct MainView: View {
    // MARK: Body
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 80)
            
            Text("반가워요!\n소음이 걱정이신가요?")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .fontWeight(.bold)
            
            Spacer().frame(height: 15)
            
            Text("아래 버튼을 눌러 시작해주세요")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.gray)
            
            Spacer()
            
            Text("버튼 눌러 시작하기")
                .font(.footnote)
                .foregroundStyle(.gray)
            
            Spacer().frame(height: 20)
            
            startButton
        }
        .padding(25)
        .background(.customBlack)
    }
    
    // MARK: SubViews
    private var startButton: some View {
        Button {
            // TODO: 로딩뷰로 이동
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
