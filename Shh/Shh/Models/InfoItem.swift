//
//  InfoItem.swift
//  Shh
//
//  Created by sseungwonnn on 10/20/24.
//

import SwiftUI

struct InfoItem {
    let title: LocalizedStringKey
    let description: [LocalizedStringKey]
}

extension InfoItem {
    // TODO: 위험치 로직 갱신 후 수정 예정
    static let infoItemList: [InfoItem] = [
        InfoItem(
            title: "✅ 내가 시끄러운지 어떻게 알 수 있나요?",
            description: [
                "Shh-!는 장소의 배경 소음, 상대방과의 거리 등을 바탕으로 파악하고 있어요!",
                "◦ 조심해야 할 경우 푸시 알림으로 알려드려요.",
                "◦ 화면을 매번 볼 필요 없이 핸드폰을 내려놓고 편안하게 작업하세요 :)"
            ]
        ),
        InfoItem(
            title: "✅ '주의'는 어떤 걸 의미하나요?",
            description: [
                "'주의' 단계는 상대방이 내 소리를 인지하기 시작하는 시점이에요!",
                "즉, 내가 내는 소리를 '소음'으로 인식할 수 있어서 소리를 줄여야 해요."
            ]
        ),
        InfoItem(
            title: "✅ 알림은 언제 오나요?",
            description: [
                "◦ 2초 간의 평균 소음이 '주의'에 해당하면 알림을 보내요!",
                "◦ 또한 '주의' 소음이 일정시간 지속되면 추가적인 알림을 보내요!"
            ]
        )
    ]
}
