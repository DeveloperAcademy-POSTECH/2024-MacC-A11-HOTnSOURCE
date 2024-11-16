//
//  AppIntent.swift
//  Shh
//
//  Created by Eom Chanwoo on 11/11/24.
//

import AppIntents
import WidgetKit

struct PauseMeteringIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "측정 일시정지"
    
    func perform() async throws -> some IntentResult {
        DispatchQueue.main.async {
            AudioManager.shared.pauseMetering()
        }
        return .result()
    }
}

struct StartMeteringIntent: LiveActivityIntent, AudioRecordingIntent {
    static var title: LocalizedStringResource = "측정 시작"
    
    func perform() async throws -> some IntentResult {
        DispatchQueue.main.async {
            // TODO: 배경 소음 인자 제거
//            AudioManager.shared.startMetering(backgroundDecibel: )
        }
        return .result()
    }
}
