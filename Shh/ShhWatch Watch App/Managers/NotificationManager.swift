//
//  NotificationManager.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 11/16/24.
//

import Foundation
import SwiftUI
import UserNotifications

// MARK: - 로컬 푸시 알림 담당 매니저
final class NotificationManager {
    static let shared = NotificationManager()
    
    /// 푸시 알림 전송
    func sendNotification(_ type: NotificationType) async {
        let status = await canSendNotification()
        
        if status {
            scheduleNotificationFor(type)
        } else {
            await requestPermission()
        }
    }
    
    /// 예약된 알림 모두 취소
    func removeAllNotifications() {
        print(#function)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    /// 푸시 알림 권한 설정
    ///
    /// `.alert`, `.badge`, `.sound`에 대한 권한을 받습니다.
    func requestPermission() async {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            
            if granted {
                print("푸시 알림 권한 설정 성공!")
            } else {
                print("푸시 알림 권한이 거부되었습니다.")
            }
        } catch {
            print("푸시 알림 권한 요청 중 오류 발생: \(error.localizedDescription)")
        }
    }
    
    /// 푸시 알림 설정 확인
    private func canSendNotification() async -> Bool {
        let status = await UNUserNotificationCenter.current().notificationSettings()
        switch status.authorizationStatus {
        case .authorized:
            print("알림 권한이 부여되었습니다.")
            return true
        case .provisional, .ephemeral:
            print("임시 알림 권한이 부여되었습니다.")
            return true
        case .denied:
            print("알림 권한이 거부되었습니다.")
            return false
        case .notDetermined:
            print("알림 권한이 아직 설정되지 않았습니다.")
            return false
        @unknown default:
            print("알 수 없는 권한 상태입니다.")
            return false
        }
    }
    
    /// 실제 푸시 알림 전송 함수
    private func scheduleNotificationFor(_ type: NotificationType) {
        let content = createNotificationContent(
            title: type.title,
            subtitle: type.subtitle
        )
        
        scheduleNotification(content: content, type: type)
    }
    
    /// 푸시 알림 내용 생성
    private func createNotificationContent(title: String, subtitle: String, sound: UNNotificationSound = .default) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.sound = sound
        content.title = title
        content.subtitle = subtitle
        
        return content
    }
    
    /// 푸시 알림 예약
    private func scheduleNotification(content: UNMutableNotificationContent, type: NotificationType) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: type.delay, repeats: type == .recurringAlert)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("\(type.rawValue) 알림 예약 실패: \(error.localizedDescription)")
            } else {
                print("\(type.rawValue) 알림 예약 성공: \(request.identifier)")
            }
        }
    }
}

enum NotificationType: String {
    /// 위험 알림
    case danger = "위험"
    /// 위험 지속 알림. 소음 수준이 위험 상태에서 20초 동안 머무를 경우 사용자에게 알려줍니다.
    case persistent = "위험 지속"
    /// 위험 지속 반복 알림.  위험 지속 알림을 받은 이후에도 계속해서 위험 수준에 머물 경우 60초 간격으로 사용자에게 알려줍니다.
    case recurringAlert = "위험 지속 반복"
}

extension NotificationType {
    var delay: TimeInterval {
        switch self {
        case .danger: return 0.1
        case .persistent: return 20
        case .recurringAlert: return 60
        }
    }
    
    var title: String {
        switch self {
        case .danger:
            NSLocalizedString("🤫", comment: "위험 알림 제목")
        case .persistent:
            NSLocalizedString("‼️", comment: "위험 지속 푸시 알림 제목")
        case .recurringAlert:
            NSLocalizedString("🚨", comment: "위험 지속 반복 푸시 알림 제목")
        }
    }
    
    var subtitle: String {
        switch self {
        case .danger:
            NSLocalizedString("큰 소리를 들었어요!", comment: "위험 푸시 알림 내용")
        case .persistent:
            NSLocalizedString("20초 동안 지속적인 소음이 발생했어요", comment: "위험 지속 푸시 알림 내용")
        case .recurringAlert:
            NSLocalizedString("큰 소리가 계속 들려요!", comment: "위험 지속 반복 푸시 알림 내용")
        }
    }
}
