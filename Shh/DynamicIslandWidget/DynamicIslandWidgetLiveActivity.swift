//
//  DynamicIslandWidgetLiveActivity.swift
//  DynamicIslandWidget
//
//  Created by sseungwonnn on 10/26/24.
//

import ActivityKit
import SwiftUI
import WidgetKit

// MARK: - Live Activity Attributes
struct DynamicIslandWidgetAttributes: ActivityAttributes {
    // MARK: Properties
    public struct ContentState: Codable, Hashable {
        // 가변 Properties
        var isMetering: Bool
    }
    
    // 불변 Properties
    var place: Place
}

// MARK: - Live Activity 뷰
struct DynamicIslandWidgetLiveActivity: Widget {
    // MARK: Body
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DynamicIslandWidgetAttributes.self) { context in
            // Lock screen/banner
            LockScreenAndBannerView(place: context.attributes.place)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI; leading/trailing/center/bottom 로 구성
                // TODO: 현지화 예정
                DynamicIslandExpandedRegion(.leading) {
                    Text("Shh-!")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.leading)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack {
                        Spacer()
                        Text("🤫")
                            .font(.largeTitle)
                            .fontWeight(.black)
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("지금 소리를 듣는 중이에요!")
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                            
                            Text("\(context.attributes.place.name)")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundStyle(.gray)
                        }
                        Spacer()
                    }
                    .padding(.leading)
                }
            } compactLeading: {
                Text("🤫")
                    .font(.caption2)
                    .fontWeight(.regular)
            } compactTrailing: {
                Text("듣는 중!")
                    .font(.caption2)
                    .fontWeight(.regular)
            } minimal: {
                Text("🤫")
                    .font(.caption2)
                    .fontWeight(.regular)
            }
            .widgetURL(URL(string: "http://www.apple.com")) // 수정하지 않아도 호출한 지점으로 이동
            .keylineTint(.green)
        }
    }
}
