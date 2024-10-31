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
    @Published var locations: [Location] = []
    
    // watchOS와의 연결 세션
    var session: WCSession
    
    // 초기화: WCSession 설정 및 활성화
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate() // iOS와 Watch 간의 연결을 활성화
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    func sessionDidDeactivate(_ session: WCSession) {}
    
    // Watch의 요청을 받으면 즉시 응답 전송
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        if message["request"] as? String == "locationData" {
            do {
                let jsonData = try JSONEncoder().encode(locations) // Location 배열을 JSON으로 인코딩
                replyHandler(["locationData": jsonData])  // 인코딩된 데이터를 Watch에 응답으로 전송
                print("Sent location data to Watch")
            } catch {
                print("Failed to encode Location data: \(error.localizedDescription)")
            }
        }
    }
    
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
