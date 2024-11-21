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
            title: "✸ 어떻게 측정하나요?",
            description: [
                "실시간으로 내 소음 수준이 배경 소음에 비해 얼마나 크게 들리는지 계산해요."
            ]
        ),
        InfoItem(
            title: "✸ 소음 상태는 어떻게 되나요?",
            description: [
                "소음 상태는 양호(초록)와 위험(분홍) 두 단계로 이루어져 있어요."
            ]
        ),
        InfoItem(
            title: "✸ 최대 소음이 뭔가요?",
            description: [
                "최대 소음은 ‘양호’ 상태에서 낼 수 있는 가장 큰 소리예요. 그보다 더 큰 소리를 내면 시끄럽다고 느낄 수 있어요."
            ]
        ),
        InfoItem(
            title: "✸ 알림은 언제 오나요?",
            description: [
                "소음 상태가 ‘위험’이 되었을 때 알림이 오고, 그 상태가 지속될 경우 20초마다 알림을 보내요."
            ]
        ),
        InfoItem(
            title: "✸ 언제 ‘위험’이 되나요?",
            description: [
                "2초 동안 소음이 지속되거나, 지나치게 큰 소리가 감지되면 ‘위험'이 돼요."
            ]
        )
    ]
}
