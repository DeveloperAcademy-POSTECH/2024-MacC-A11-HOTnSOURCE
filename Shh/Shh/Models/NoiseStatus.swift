//
//  NoiseStatus.swift
//  Shh
//
//  Created by sseungwonnn on 10/13/24.
//

import SwiftUI

enum NoiseStatus: String {
    case safe
    case caution
    case danger
}

extension NoiseStatus {
    /// 소음 '주의'  단계의 기준치입니다.
    static let loudnessCautionLevel: Float = 1.3
    
    /// 소음 '위험' 단계의 기준치입니다.
    static let loudnessDangerLevel: Float = 1.5
    
    /// 위험도에 해당하는 색상입니다.
    var statusColor: Color {
        switch self {
        case .safe:
            return Color.safe
        case .caution:
            return Color.caution
        case .danger:
            return Color.danger
        }
    }
    
    /// 위험도에 해당하는 한국어입니다.
    var korean: String {
        switch self {
        case .safe:
            return "양호"
        case .caution:
            return "주의"
        case .danger:
            return "위험"
        }
    }
    
    /// 위험도에 따른 안내 문구입니다.
    var writing: String {
        switch self {
        case .safe:
            return "지금 아주 잘하고 있어요!"
        case .caution:
            return "이제 조금 조심해야 해요."
        case .danger:
            return "지금 바로 조용히 해야 해요!"
        }
    }
    
}
