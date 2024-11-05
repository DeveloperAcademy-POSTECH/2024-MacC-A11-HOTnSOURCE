//
//  AppDelegate.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/14/24.
//

import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    /// 앱이 실행될 때 가장 먼저 호출되는 메서드 중 하나로, 앱이 실행되기 전에 초기 설정 가능
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // 노티피케이션 센터의 delegate 설정
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    /// 포그라운드에서 알림 수신했을 때 처리
    ///
    /// 배너와 사운드 알림을 표시하도록 설정합니다.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.banner, .sound]
    }
    
    /// 앱이 종료될 때 실행하는 메서드로,
    /// 현재 실행중인 라이브 액티비티를 정지합니다.
    func applicationWillTerminate(_ application: UIApplication) {
        print(#function)
        LiveActivityManager.shared.endLiveActivity()
        NotificationManager.shared.removeAllNotifications()
    }
}
