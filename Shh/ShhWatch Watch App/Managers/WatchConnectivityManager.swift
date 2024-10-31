//
//  WatchConnectivityManager.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 10/31/24.
//

import Foundation
import WatchConnectivity

struct Location: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var backgroundDecibel: Float
    var distance: Float
}

// MARK: - iOS와의 연결을 관리하는 클래스
class WatchConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
    @Published var locations: [Location] = []
    
    // watchOS 연결 세션
    var session: WCSession
    
    // 초기화: WCSession 설정 및 활성화
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate() // Watch와 iOS 간의 연결 활성화
    }
    
    // WCSession이 활성화된 상태인지 확인
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            print("WCSession is activated on watchOS")
        } else {
            print("WCSession failed to activate on watchOS")
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
}
