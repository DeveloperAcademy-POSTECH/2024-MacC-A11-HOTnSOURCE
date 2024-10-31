//
//  HapticManager.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 11/1/24.
//

import SwiftUI

class HapticManager: NSObject, ObservableObject, WKExtendedRuntimeSessionDelegate {
    static public let shared = HapticManager()
    private var session = WKExtendedRuntimeSession()
    
    // 현재 세션이 실행 중인지 확인
    private func isRunningSession() -> Bool {
        return session.state == .running || session.state == .scheduled
    }
    
    // 세션 시작
    func startSession() {
        // 현재 세션이 이미 실행 중이면 중복 실행 방지를 위해 리턴
        if isRunningSession() {
            return
        }
        
        // 새 세션을 생성하고, HapticManager를 delegate로 설정
        session = WKExtendedRuntimeSession()
        session.delegate = self
        
        // 현재 시점부터 세션 시작
        session.start(at: Date())
    }
    
    // 세션 중단
    func stopSession() {
        // 세션이 실행 중일 때만 중단
        if isRunningSession() {
            session.invalidate()
        }
    }
    
    // MARK: WKExtendedRuntimeSessionDelegate 메서드들 - 추후에 필요에 따라 활용할 예정
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        // 세션에 오류가 발생했거나 실행이 중지됨
        print("세션에 오류 있거나, 실행 중지됨!")
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        // 세션이 시작될 때 호출됨
        print("세션 실행되기 시작함!")
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        // 세션이 만료되기 직전에 호출됨
        print("세션 만료되기 직전!")
    }
}
