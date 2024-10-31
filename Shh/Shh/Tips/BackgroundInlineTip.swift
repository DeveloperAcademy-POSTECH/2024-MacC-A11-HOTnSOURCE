//
//  BackgroundInlineTip.swift
//  Shh
//
//  Created by sseungwonnn on 10/31/24.
//

import Foundation
import TipKit

struct BackgroundInlineTip: Tip {
    var title: Text {
        Text("화면을 덮고 사용해보세요!")
    }

    var message: Text? {
        Text("Shh-!는 앱을 나가거나 휴대전화를 잠궈도 들을 수 있어요. 마음 놓고 집중하세요!")
    }

    var image: Image? {
        Image(systemName: "heart")
    }
}
