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
    
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            print("WCSession is activated on iOS")
        } else {
            print("WCSession failed to activate on iOS")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    func sessionDidDeactivate(_ session: WCSession) {}
    
    // Watch의 요청에 즉시 응답을 전송
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        if message["request"] as? String == "locationData" {
            do {
                let jsonData = try JSONEncoder().encode(locations)
                replyHandler(["locationData": jsonData])  // 즉시 응답으로 데이터를 전송
                print("Sent location data to Watch")
            } catch {
                print("Failed to encode Location data: \(error.localizedDescription)")
            }
        }
    }
    
    // transferUserInfo를 사용하여 Location 데이터를 자동으로 전송
    func sendLocationData(location: [Location]) {
        do {
            let jsonData = try JSONEncoder().encode(location)
            let userInfo = ["locationData": jsonData]
            session.transferUserInfo(userInfo)
            print("Transferred location data to Watch")
        } catch {
            print("Failed to encode Location: \(error.localizedDescription)")
        }
    }
}
