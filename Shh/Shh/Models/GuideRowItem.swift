//
//  GuideRowItem.swift
//  Shh
//
//  Created by Jia Jang on 11/19/24.
//

import SwiftUI

enum GuideRowItem: CaseIterable {
    case meteringMethod
    case levels
    case maxNoise
    case pushNotification
    case dangerStandard
}

extension GuideRowItem {
    var systemName: String {
        switch self {
        case .meteringMethod: "waveform.badge.mic"
        case .levels: "ring.circle"
        case .maxNoise: "speaker.wave.2.fill"
        case .pushNotification: "bell.badge.fill"
        case .dangerStandard: "exclamationmark.triangle.fill"
        }
    }
    
    var accessibilityLabel: String {
        switch self {
        case .meteringMethod: "마이크 심볼"
        case .levels: "소음 측정 심볼"
        case .maxNoise: "음량 심볼"
        case .pushNotification: "종 모양 알림 심볼"
        case .dangerStandard: "위험 경고 심볼"
        }
    }
    
    var boxColor: Color {
        switch self {
        case .meteringMethod: .accent
        case .levels: .accent
        case .maxNoise: .accent
        case .pushNotification: .pink
        case .dangerStandard: .pink
        }
    }
    
    var title: LocalizedStringKey {
        switch self {
        case .meteringMethod: "어떻게 측정하나요?"
        case .levels: "소음 단계는 어떻게 되나요?"
        case .maxNoise: "최대 소음이 뭔가요?"
        case .pushNotification: "알림은 언제 오나요?"
        case .dangerStandard: "언제 ‘위험’이 되나요?"
        }
    }
    
    var description: LocalizedStringKey {
        switch self {
        case .meteringMethod: "기기 마이크를 사용해서 실시간으로 소음 수준을 확인하며, 배경 소음에 비해서 얼만큼 크게 들리는지 계산해요."
        case .levels: "소음 단계는 양호와 위험 두 단계로 이루어져 있어요. 양호일 땐 녹색, 위험일 땐 분홍색으로 소음 단계를 볼 수 있어요."
        case .maxNoise: "‘양호’ 수준을 유지하면서 낼 수 있는 소리의 최대 크기예요. 이 이상 큰 소리를 내면 시끄럽다고 느낄 수 있어요."
        case .pushNotification: "소음 단계가 ‘위험’이 되었을 때, 알림이 와요. 또한 ‘위험’이 지속될 경우, 20초마다 알림을 보내요."
        case .dangerStandard: "2초 동안 ‘소음'이 지속될 경우 혹은 지나치게 큰 소리가 감지되었을 때, 소음 단계가 ‘위험'이 돼요."
        }
    }
}
