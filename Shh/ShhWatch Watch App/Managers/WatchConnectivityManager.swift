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

class WatchConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
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
            print("WCSession is activated on watchOS")
        } else {
            print("WCSession failed to activate on watchOS")
        }
    }
    
    // Watch가 iOS에 초기 데이터를 요청
    func requestLocationData() {
        session.transferUserInfo(["request": "locationData"])
        print("Requested initial location data via transferUserInfo")
    }
    
    // iOS로부터 수신한 UserInfo 데이터를 통해 Location 정보 업데이트
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        if let jsonData = userInfo["locationData"] as? Data {
            do {
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
