//
//  MainView.swift
//  Shh
//
//  Created by sseungwonnn on 10/14/24.
//

import SwiftUI

// MARK: - 메인 뷰; 사용자의 소음 정도를 나타냅니다.
struct MainView: View {
    // MARK: Properties
//    @EnvironmentObject var audioManager: AudioManager
    
    // MARK: Body
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    
                    Color(.safe)
                    .ignoresSafeArea(edges: .bottom)
                    .frame(height: 200)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Rectangle()
                            .fill(.white)
                            .opacity(0.4)
                            .frame(width: 27, height: 4)
                        
                        Spacer()
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("양호") // TODO: 수정 예정
                                .font(.system(size: 56))
                                .fontWeight(.bold)
                                .foregroundStyle(.customWhite)
                            
                            Text("지금 아주 잘하고 있어요!")
                                .font(.callout)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                        }
                        Spacer()
                        
                        VStack(spacing: 14) {
                            HStack {
                                Text("40dB") // TODO: 수정예정
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.customWhite)
                                
                                Rectangle()
                                    .fill(.customWhite)
                                    .frame(width: 1, height: 18)
                                
                                Text("2 m") // TODO: 수정예정
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.customWhite)
                            }
                            
                            HStack {
                                Button {
                                    // TODO: ㅁㄴㅇㄹ
                                } label: {
                                    Image(systemName: "pause.fill")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.customWhite)
                                        .padding()
                                        .background(
                                            Circle()
                                                .fill(.customBlack)
                                        )
                                }
                                
                                Button {
                                    // TODO: ㅁㄴㅇㄹ
                                } label: {
                                    Image(systemName: "xmark")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.customWhite)
                                        .padding()
                                        .background(
                                            Circle()
                                                .fill(.customBlack)
                                        )
                                }
                            }
                            
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
            }
            .navigationTitle("도서관") // TODO: 수정 예정
            
        }
    }
}

#Preview {
    MainView()
}
