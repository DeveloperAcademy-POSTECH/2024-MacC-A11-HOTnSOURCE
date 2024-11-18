//
//  LiveDecibelTip.swift
//  Shh
//
//  Created by sseungwonnn on 11/19/24.
//

import Foundation
import TipKit

struct LiveDecibelTip: Tip {
    var title: Text {
        Text("실시간 데시벨 현황")
            .bold()
            .foregroundStyle(.green)
    }

    var message: Text? {
        Text("현재 내가 내고 있는 소리가 궁금하다면 이곳을 눌러주세요.")
    }
}
