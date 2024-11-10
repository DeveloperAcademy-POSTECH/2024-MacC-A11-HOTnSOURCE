//
//  AppIntent.swift
//  Shh
//
//  Created by Eom Chanwoo on 11/11/24.
//

import AppIntents
import WidgetKit

struct StopMeteringIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Pause Metering"
    
    func perform() async throws -> some IntentResult {
        DispatchQueue.main.async {
            print("측정 일시정지 시도")
            AudioManager.shared.pauseMetering()
            print("측정 일시정지 성공")
        }
        return .result()
    }
}
