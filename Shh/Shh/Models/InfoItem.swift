//
//  InfoItem.swift
//  Shh
//
//  Created by sseungwonnn on 10/20/24.
//

import SwiftUI

struct InfoItem {
    let title: String
    let description: [String]
}

extension InfoItem {
    static let infoItemList: [InfoItem] = [InfoItem(title: "Shh-!의 소음 측정은 어떻게 이루어지나요?", description: ["'내가 낸 소리가 상대방에게 얼마나 크게 들릴지'를 측정하기 위해 기기 마이크를 사용합니다.\n", "- 측정된 소음 정보는 저장하지 않습니다.", "- 백그라운드에서도 측정은 이루어지며, 화면 상단의 노란 점을 확인하면 마이크 사용 현황을 알 수 있습니다."]), InfoItem(title: "내가 시끄러운지 어떻게 알 수 있나요?", description: ["메인 화면의 물결의 높낮이는 내 소리가 얼마나 시끄러운지를 나타냅니다. 높이가 높을 수록 상대방은 시끄럽다고 느낍니다."]), InfoItem(title: "메인 화면의 색상은 무엇을 나타내나요?", description: ["메인 화면의 색상은 '위험 수준'을 나타냅니다. Shh-!에서는 상대방이 내가 낸 소리를 얼만큼 인지하는지에 따라, 세 단계로 위험 수준을 구분합니다.\n", "- 안전: 내가 낸 소리가 상대방에게 영향을 크게 미치지 않습니다.", "- 경고: 파란색 파도로, 상대방이 내 소리를 인지하지만 아직 큰 영향은 끼치지 않습니다.", "- 위험: 분홍색 파도로, 상대방이 내 소리를 명백한 소음으로 인식합니다."]), InfoItem(title: "알림은 언제 오나요?", description: ["- '주의'에 해당하는 소음이 일정시간 지속되면 알림을 보냅니다. 다음 알림은 30초 뒤에 보낼 수 있습니다.", "- '위험' 에 해당하는 소음이 발생하면 즉시 알림을 보냅니다."])
    ]
}
