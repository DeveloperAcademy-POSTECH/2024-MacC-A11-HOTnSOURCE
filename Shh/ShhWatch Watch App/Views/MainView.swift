//
//  ContentView.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 10/30/24.
//

import SwiftUI

// MARK: - 메인 뷰: Controls, Home, MeteringInfo View로 구성
struct MainView: View {
    // MARK: Properties
    @EnvironmentObject var routerManager: RouterManager
    
    @State private var tabSelection: MainTabs = .home
    
    // TODO: 추후에 audioManger.isMetering으로 변경 예정
    @State private var isMetering = true
    
    // ✅ TODO: 뭘 쓰는게 맞는지 다시 확인 필요 (StateObject/var/private)
    private var connectivityManager = WatchConnectivityManager()
    
    // MARK: Body
    var body: some View {
        TabView(selection: $tabSelection) {
            controlsView
                .tag(MainTabs.controls)
            
            homeView
                .tag(MainTabs.home)
            
            MeteringInfoView()
                .tag(MainTabs.info)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: SubViews
    private var controlsView: some View {
        VStack {
            HStack {
                meteringStopButton
                editingButton
            }
            
            meteringToggleButton
        }
        .frame(maxWidth: 150)
    }
    
    private var meteringStopButton: some View {
        VStack {
            Button {
                routerManager.pop()
                
                // more actions
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            // TODO: button color가 어둡게 나오는 이슈 발생. 해결방안을 찾기 전까지 opacity로 임시 대처.
            .buttonStyle(BorderedButtonStyle(tint: Color.red.opacity(10)))
            
            Text("종료")
        }
    }
    
    private var meteringToggleButton: some View {
        VStack {
            Button {
                // action
                
                // TODO: 테스트용 코드 (기능 적용시 삭제 예정)
                isMetering.toggle()
            } label: {
                // TODO: 추후에 audioManger.isMetering으로 변경 예정
                Image(systemName: isMetering ? "pause.fill" : "play.fill")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            // TODO: button color가 어둡게 나오는 이슈 발생. 해결방안을 찾기 전까지 opacity로 임시 대처.
            .buttonStyle(BorderedButtonStyle(tint: Color.green.opacity(isMetering ? 2 : 10)))
            
            Text(isMetering ? "일시정지" : "재개")
        }
    }
    
    private var editingButton: some View {
        VStack {
            Button {
                // TODO: editLocationView로 이동
            } label: {
                Image(systemName: "square.and.pencil")
                    .foregroundStyle(.white)
            }
            
            Text("수정")
        }
    }
    
    private var homeView: some View {
        Text("소리 상태 표시")
    }
}

#Preview {
    MainView()
}
