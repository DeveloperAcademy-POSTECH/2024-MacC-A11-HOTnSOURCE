//
//  InfoItem.swift
//  ShhWatch Watch App
//
//  Created by Jia Jang on 10/31/24.
//

import SwiftUI

struct InfoItem {
    let title: LocalizedStringKey
    let description: [LocalizedStringKey]
}

extension InfoItem {
    // TODO: 팀 내 논의 후 수정 예정 (워치 버전 설명 임시로 작성함)
    static let infoItemList: [InfoItem] = [
        InfoItem(
            title: "✸ Shh-!의 소음 측정은 어떻게 이루어지나요?",
            description: [
                "'내가 낸 소리가 상대방에게 얼마나 크게 들릴지' 파악하기 위해 기기의 마이크를 사용합니다.",
                "- 파악한 소음 정보는 저장하지 않아요.",
                "- 앱이 켜져 있지 않아도 백그라운드에서 계속 측정 가능해요."
            ]
        ),
        InfoItem(
            title: "✸ 내가 시끄러운지 어떻게 알 수 있나요?",
            description: [
                "메인 화면에서 내 소리가 얼마나 시끄러운지 확인할 수 있어요.",
                "- 조심해야 할 경우 진동으로 알려드려요.",
                "- 화면이 켜져있지 않아도 돼요. 편안하게 작업에 집중하세요."
            ]
        ),
        InfoItem(
            title: "✸ 메인 화면의 색상은 무엇을 나타내나요?",
            description: [
                "메인 화면의 색상은 '위험 수준'을 나타냅니다.",
                "위험 수준은 상대방이 내 소리를 인지하는 정도에 따라 구분됩니다.",
                "- 양호(초록색): 내가 낸 소리가 상대방에게 영향을 크게 미치지 않아요.",
                "- 주의(분홍색): 상대방이 내 소리를 명백한 소음으로 인식해요."
            ]
        ),
        InfoItem(
            title: "✸ 알림은 언제 오나요?",
            description: [
                "- 작업을 방해하지 않기 위해, 반복되는 소음이 발생했을 경우에만 알려드려요.",
                "- '주의'에 해당하는 소음이 일정시간 지속되면 알림을 보냅니다."
            ]
        )
    ]
}
