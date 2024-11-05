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
}

extension NoiseStatus {
    /// 소음 '주의'  단계의 기준치입니다.
    /// 주의는 상대방이 소리를 인지하기 시작한 때입니다. 바로 소리를 줄여야 합니다.
    static let loudnessCautionLevel: Float = 1.3
    
    /// 위험도에 해당하는 메시지입니다.
    var message: LocalizedStringKey {
        switch self {
        case .safe:
            return "양호"
        case .caution:
            return "주의"
        }
    }
    
    /// 위험도에 따른 안내 문구입니다.
    var writing: LocalizedStringKey {
        switch self {
        case .safe:
            return "지금 아주 잘하고 있어요!"
        case .caution:
            return "이제 조금 조심해야 해요"
        }
    }
}
