////
////  StartView.swift
////  Shh
////
////  Created by Eom Chanwoo on 10/31/24.
////
//
//import SwiftUI
//
//// MARK: - 온보딩 > 시작 페이지
//struct StartView: View {
//    // MARK: Properties
//    @EnvironmentObject var locationManager: LocationManager
//    @EnvironmentObject var router: Router
//    
//    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
//    
//    let name: String
//    let backgroundNoise: Float
//    let distance: Float
//    
//    // MARK: Body
//    var body: some View {
//        VStack {
//            Spacer(minLength: 40)
//            
//            VStack(spacing: 6) {
//                StepDescriptionRow(
//                    text: NSLocalizedString("모든 준비가 완료되었어요!", comment: "온보딩 완료 제목"),
//                    subText: NSLocalizedString("시끄러운 소리를 내면 알려드릴게요!", comment: "온보딩 완료 부제목")
//                )
//                
//                Text("* 알림 권한을 허용해주세요")
//                    .font(.caption2)
//                    .foregroundStyle(.accent)
//                    .fontWeight(.bold)
//            }
//            
//            Spacer(minLength: 50)
//            
//            SsambbongAsset(image: .completeAsset)
//                .frame(maxHeight: .infinity, alignment: .top)
//            
//            startButton
//        }
//        .padding(20)
//        .background(.customBlack)
//        .onAppear {
//            Task {
//                await NotificationManager.shared.requestPermission()
//            }
//        }
//    }
//    
//    // MARK: SubViews
//    private var startButton: some View {
//        CustomButton(text: "시작하기") {
//            let newLocation = Location(id: UUID(), name: name, backgroundDecibel: backgroundNoise, distance: distance)
//            
//            locationManager.selectedLocation = newLocation
//            locationManager.createLocation(newLocation)
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
//                router.push(view: .mainView(selectedLocation: newLocation))
//            }
//            
//            isFirstLaunch = false
//        }
//    }
//}
//
//// MARK: - Preview
//#Preview {
//    StartView(name: "name", backgroundNoise: 30.0, distance: 2.0)
//}
