//
//  IOSConnectivityManager.swift
//  Shh
//
//  Created by Jia Jang on 10/31/24.
//

import Foundation
import WatchConnectivity

// MARK: - watchOS와의 연결을 관리하는 클래스
class IOSConnectivityManager: NSObject, WCSessionDelegate {
    static let shared = IOSConnectivityManager()
    
    // watchOS와의 연결 세션
    var session: WCSession
    
    // 초기화: WCSession 설정 및 활성화
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate() // iOS와 Watch 간의 연결 활성화
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    func sessionDidDeactivate(_ session: WCSession) {}
    
    // 데이터가 변경될 때 Watch에 location 정보를 자동으로 전송
    func sendLocationData(location: [Location]) {
        do {
            let jsonData = try JSONEncoder().encode(location) // Location 데이터를 JSON으로 인코딩
            let userInfo = ["locationData": jsonData]
            session.transferUserInfo(userInfo) // transferUserInfo로 비동기 전송
            print("Transferred location data to Watch")
        } catch {
            print("Failed to encode Location: \(error.localizedDescription)")
        }
    }
}
