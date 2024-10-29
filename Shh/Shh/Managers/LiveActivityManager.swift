//
//  LiveActivityManager.swift
//  Shh
//
//  Created by sseungwonnn on 10/29/24.
//

import ActivityKit
import SwiftUI

class LiveActivityManager {
    static let shared = LiveActivityManager() // 싱글톤 인스턴스
    
    private var activity: Activity<DynamicIslandWidgetAttributes>?
    
    func startLiveActivity(isMetering: Bool, selectedLocation: Location) {
        print(#function)
        if self.activity == nil {
            let attributes = DynamicIslandWidgetAttributes(location: selectedLocation)
            
            let contentState = DynamicIslandWidgetAttributes.ContentState(isMetering: isMetering)
            let content = ActivityContent(
                state: contentState,
                staleDate: nil, // 만료 시간
                relevanceScore: 0 // 우선 순위
            )
            
            do {
                self.activity = try Activity<DynamicIslandWidgetAttributes>.request(
                    attributes: attributes,
                    content: content,
                    pushType: nil // TODO: @eomchanu 푸쉬 알림 및 추가
                )
            } catch {
                print("LiveActivityManager: Error in LiveActivityManager: \(error.localizedDescription)")
            }
        }
    }
    
    func updateLiveActivity(isMetering: Bool) async {
        print(#function)
        
        let contentState = DynamicIslandWidgetAttributes.ContentState(isMetering: isMetering)
        
        await self.activity?.update(ActivityContent<DynamicIslandWidgetAttributes.ContentState>(
            state: contentState,
            staleDate: nil
        ))
    }
    
    func endLiveActivity() {
        print(#function)
        let semaphore = DispatchSemaphore(value: 0) // 세마포어 정수를 0으로 설정하여, AppDelegate에서 완료상태 동기화
        Task {
            if let currentActivity = activity {
                await currentActivity.end(
                    nil, // content 전달하지 않음
                    dismissalPolicy: .immediate // 즉시 종료
                )
                self.activity = nil
            }
            semaphore.signal() // 작업이 끝났다고 알림
        }
        semaphore.wait() // 작업이 끝날 때까지 기다림
    }
}
