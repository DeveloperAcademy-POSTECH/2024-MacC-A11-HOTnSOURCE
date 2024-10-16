//
//  NotificationManager.swift
//  Shh
//
//  Created by Eom Chanwoo on 10/14/24.
//

import Foundation
import SwiftUI
import UserNotifications

// MARK: - 로컬 푸시 알림 담당 매니저 (actor 적용)
actor NotificationManager {
    private var lastNotificationTime: Date?

    /// 푸시 알림 권한 설정
    ///
    /// `.alert`, `.badge`, `.sound`, `.criticalAlert`에 대한 권한을 받습니다.
    func requestPermission() async {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound, .criticalAlert])
            if granted {
                print("푸시 알림 권한 설정 성공!")
            } else {
                print("푸시 알림 권한이 거부되었습니다.")
            }
        } catch {
            print("푸시 알림 권한 요청 중 오류 발생: \(error.localizedDescription)")
        }
    }
    
    /// 푸시 알림 전송
    ///
    /// 타입에 맞는 알림을 전송합니다.
    func sendNotification(type: NotificationType) async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        
        switch settings.authorizationStatus {
        case .notDetermined:
            await requestPermission()
        case .authorized, .provisional:
            if canSendNotification() {
                switch type {
                case .caution:
                    sendCautionNotification()
                case .danger:
                    sendDangerNotification()
                }
                lastNotificationTime = Date() // 알림을 전송한 시간을 기록
            }
        case .denied:
            print("푸시 알림 권한이 거부되었습니다.")
        default:
            print("알 수 없는 상태입니다.")
        }
    }
    
    /// 푸시 알림 설정 확인
    func check(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                print("알림 권한이 부여되었습니다.")
                completion(true)
            case .denied:
                print("알림 권한이 거부되었습니다.")
                completion(false)
            case .notDetermined:
                print("알림 권한이 아직 설정되지 않았습니다.")
                completion(false)
            case .provisional, .ephemeral:
                print("임시 알림 권한이 부여되었습니다.")
                completion(true)
            @unknown default:
                print("알 수 없는 권한 상태입니다.")
                completion(false)
            }
        }
    }
    
    /// 주의 알림 전송
    private func sendCautionNotification() {
        let content = createNotificationContent(
            subtitle: LocalizedStringKey("소음 수준: ").toString() + NoiseStatus.caution.korean.toString(),
            body: NoiseStatus.caution.writing.toString()
        )
        scheduleNotification(content: content)
    }
    
    /// 위험 알림 전송
    private func sendDangerNotification() {
        let content = createNotificationContent(
            subtitle: LocalizedStringKey("소음 수준: ").toString() + NoiseStatus.danger.korean.toString(),
            body: NoiseStatus.danger.writing.toString()
        )
        scheduleNotification(content: content)
    }
    
    /// 푸시 알림 내용 생성
    private func createNotificationContent(subtitle: String? = nil, body: String, sound: UNNotificationSound = .default) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.sound = sound
        content.subtitle = subtitle ?? ""
        content.body = body
        return content
    }
    
    /// 푸시 알림 전송(예약)
    private func scheduleNotification(content: UNMutableNotificationContent) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 예약 실패: \(error.localizedDescription)")
            } else {
                print("알림 예약 성공: \(request.identifier)")
            }
        }
    }
    
    /// 30초 동안 한 번만 푸시 알림 전송 제한
    private func canSendNotification() -> Bool {
        if let lastTime = lastNotificationTime {
            let timeInterval = Date().timeIntervalSince(lastTime)
            return timeInterval >= 30
        }
        return true
    }
}

enum NotificationType {
    case caution
    case danger
}
