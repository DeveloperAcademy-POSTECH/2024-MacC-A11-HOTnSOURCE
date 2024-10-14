//
//  NotificationManager.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/14/24.
//

import Foundation
import UserNotifications

// MARK: - 로컬 푸시 알림 담당 매니저
class NotificationManager {
    /// 푸시 알림 권한 설정
    ///
    /// `.alert`, `.badge`, `.sound`, `.criticalAlert`에 대한 권한을 받습니다.
    static func requestPermission() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .sound, .criticalAlert]) { granted, error in
                if granted == true && error == nil {
                    print("푸시 알림 권한 설정 성공!!")
                }
            }
    }
    
    /// 푸시 알림 전송
    ///
    /// 타입에 맞는 알림을 전송합니다.
    static func sendNotification(type: NotificationType) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission()
            case .authorized, .provisional:
                switch type {
                case .caution:
                    self.sendCautionNotification()
                case .warning:
                    self.sendWarningNotification()
                }
            default:
                break
            }
        }
    }
    
    /// 주의 알림 전송
    private static func sendCautionNotification() {
        let content = createNotificationContent(subtitle: "주의", body: "조심하세요!")
        scheduleNotification(content: content)
    }
    
    /// 위험 알림 전송
    private static func sendWarningNotification() {
        let content = createNotificationContent(subtitle: "위험", body: "시끄러워요!")
        scheduleNotification(content: content)
    }
    
    /// 푸시 알림 설정 확인
    static func check(completion: @escaping (Bool) -> Void) {
        let current = UNUserNotificationCenter.current()
        
        current.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                // 사용자가 알림 권한을 부여한 경우
                print(settings.authorizationStatus.rawValue)
                completion(true)
            case .denied, .ephemeral, .notDetermined, .provisional:
                // 사용자가 알림 권한을 거부한 경우 또는 아직 결정하지 않은 경우
                print(settings.authorizationStatus.rawValue)
                completion(false)
            @unknown default:
                // 알려지지 않은 권한 상태
                print("unknown authorization status")
                completion(false)
            }
        }
    }
    
    /// 푸시 알림 내용 생성
    private static func createNotificationContent(subtitle: String? = nil, body: String, sound: UNNotificationSound = .default) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.sound = sound
        content.subtitle = subtitle ?? ""
        content.body = body
        return content
    }
    
    /// 푸시 알림 전송(예약)
    private static func scheduleNotification(content: UNMutableNotificationContent) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            guard error == nil else { return }
            print("scheduling notification with id: \(request.identifier)")
        }
    }
}

enum NotificationType {
    case caution
    case warning
}
