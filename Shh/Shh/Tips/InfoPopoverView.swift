//
//  InfoPopoverTip.swift
//  Shh
//
//  Created by sseungwonnn on 10/31/24.
//

import Foundation
import TipKit

struct InfoPopoverTip: Tip {
    var title: Text {
        Text("자주 묻는 질문")
    }
    
    var message: Text? {
        Text("Shh-!의 소음 측정 방법이 궁금하면 이곳을 눌러주세요.")
    }
    
    var image: Image? {
        Image(systemName: "lightbulb.fill")
    }
}
