//
//  DynamicIslandWidgetBundle.swift
//  DynamicIslandWidget
//
//  Created by sseungwonnn on 10/26/24.
//

import WidgetKit
import SwiftUI

@main
struct DynamicIslandWidgetBundle: WidgetBundle {
    var body: some Widget {
        DynamicIslandWidget()
        DynamicIslandWidgetControl()
        DynamicIslandWidgetLiveActivity()
    }
}
