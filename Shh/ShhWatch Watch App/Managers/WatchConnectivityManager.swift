//
//  WatchConnectivityManager.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 10/31/24.
//

import SwiftUI
import WatchConnectivity

// MARK: - iOS와의 연결을 관리하는 클래스
class WatchConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
    @AppStorage("locations") private var storedLocations: String = "[]"
    
    @Published var locations: [Location] = [] {
        didSet {
            saveLocationsToAppStorage() // locations가 변경될 때 AppStorage에 저장
        }
    }
    
    // watchOS 연결 세션
    var session: WCSession
    
    // 초기화: WCSession 설정 및 활성화
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate() // Watch와 iOS 간의 연결 활성화
        loadLocationsFromAppStorage() // 저장된 locations 데이터를 불러와서 초기화
    }
    
    // WCSession이 활성화된 상태인지 확인
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            print("WCSession is activated on watchOS")
        } else {
            print("WCSession failed to activate on watchOS")
            // TODO: activated가 아닐 경우 예외처리 (ex. 얼럿 등..)
        }
    }
    
    // iOS로부터 수신한 UserInfo 데이터를 통해 Location 정보 업데이트
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        if let jsonData = userInfo["locationData"] as? Data {
            do {
                // JSON 데이터를 Location 배열로 디코딩하여 업데이트
                let decodedLocations = try JSONDecoder().decode([Location].self, from: jsonData)
                DispatchQueue.main.async {
                    self.locations = decodedLocations
                    print("Received location data from iOS: \(self.locations)")
                }
            } catch {
                print("Failed to decode Location data: \(error.localizedDescription)")
            }
        }
    }
    
    // AppStorage에 location 정보 저장
    private func saveLocationsToAppStorage() {
        do {
            let encodedData = try JSONEncoder().encode(locations)
            storedLocations = String(data: encodedData, encoding: .utf8) ?? "[]"
        } catch {
            print("Failed to encode locations for AppStorage: \(error.localizedDescription)")
        }
    }
    
    // AppStorage에서 location 정보 로드
    private func loadLocationsFromAppStorage() {
        guard let data = storedLocations.data(using: .utf8) else { return }
        do {
            locations = try JSONDecoder().decode([Location].self, from: data)
        } catch {
            print("Failed to decode locations from AppStorage: \(error.localizedDescription)")
        }
    }
}
