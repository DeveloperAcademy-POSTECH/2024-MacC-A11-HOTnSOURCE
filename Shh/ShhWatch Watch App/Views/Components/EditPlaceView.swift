//
//  EditPlaceView.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 11/1/24.
//

import SwiftUI

// MARK: - 장소 수정 뷰
struct EditPlaceView: View {
    // MARK: Properties
    @EnvironmentObject var routerManager: RouterManager
    @EnvironmentObject var connectivityManager: WatchConnectivityManager
    
    @FocusState private var isFocused: Bool
    
    @State private var showSelectBackgroundDecibelSheet: Bool = false
    @State private var showDeleteAlert: Bool = false
    @State private var isShowingProgressView: Bool = false
    
    // TODO: 임시 데이터
    @State private var backgroundDecibel: Float = 40.0
    @State private var distance = 1.0
    
    // MARK: Body
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                Spacer().frame(height: 10)
                
                backgroundDecibelRow
                disatanceSelectRow
                
                Spacer()
                
                completeButton
            }
            .padding(.horizontal)
            
            if isShowingProgressView {
                Color(.black)
                    .opacity(0.4)
                    .ignoresSafeArea(.all)
                
                ProgressView()
            }
        }
        .scrollIndicators(.hidden)
        .onTapGesture {
            isFocused = false
        }
    }
    
    // MARK: SubViews
    private var backgroundDecibelRow: some View {
        VStack {
            HStack {
                Text("배경 소음")
                
                Spacer()
                
                HStack {
                    Text("\(Int(backgroundDecibel))dB")
                    
                    BackgroundDecibelMeteringButton(backgroundDecibel: $backgroundDecibel, isShowingProgressView: $isShowingProgressView)
                }
            }
        }
    }
    
    private var disatanceSelectRow: some View {
        HStack {
            Text("거리")
            
            Spacer()
            
            distanceSelectButton
        }
    }
    
    private var distanceSelectButton: some View {
        HStack {
            distanceAdjustButton(isPlus: false)
            distanceInfo
            distanceAdjustButton(isPlus: true)
        }
    }
    
    private var distanceInfo: some View {
        Text("\(String(distance))m")
            .frame(width: 50)
    }
    
    @ViewBuilder
    private func distanceAdjustButton(isPlus: Bool) -> some View {
        Image(systemName: isPlus ? "plus.circle.fill" : "minus.circle.fill")
            .font(.title2)
            .foregroundStyle(.gray)
            .onTapGesture {
                if isPlus && distance < 3 {
                    distance += 0.5
                } else if !isPlus && distance > 1 {
                    distance -= 0.5
                }
            }
    }
    
    private var completeButton: some View {
        Button {
            routerManager.pop()
        } label: {
            Text("완료")
                .foregroundStyle(.black)
                .fontWeight(.bold)
        }
        // TODO: button color가 어둡게 나오는 이슈 발생 -> opacity로 임시 대처.
        .buttonStyle(BorderedButtonStyle(tint: .accent.opacity(10)))
    }
}

#Preview {
    EditPlaceView()
}
