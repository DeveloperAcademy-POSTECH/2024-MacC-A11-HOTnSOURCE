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
    var location: Location
}

// MARK: - Live Activity 뷰
struct DynamicIslandWidgetLiveActivity: Widget {
    // MARK: Body
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DynamicIslandWidgetAttributes.self) { context in
            // Lock screen / banner
            LockScreenAndBannerView(
                isMetering: context.state.isMetering,
                location: context.attributes.location
            )
        } dynamicIsland: { context in
            DynamicIsland {
                // TODO: 디자인 리팩토링 필요
                // Expanded UI; leading/trailing/center/bottom 로 구성
                // Compact / minimal UI
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
                        if context.state.isMetering {
                            Button(intent: PauseMeteringIntent()) {
                                Text("일시정지")
                            }
                        } else {
                            Button(intent: StartMeteringIntent()) {
                                Text("측정하기")
                            }
                        }
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text(context.state.isMetering ? "지금 소리를 듣는 중이에요!" : "측정이 일시정지되었습니다.")
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                            
                            Text("\(context.attributes.location.name)")
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
                Text(context.state.isMetering ? "듣는 중!" : "일시정지됨")
                    .font(.caption2)
                    .fontWeight(.regular)
            } minimal: {
                Text("🤫")
                    .font(.caption2)
                    .fontWeight(.regular)
            }
            .widgetURL(URL(string: "http://www.apple.com")) // 수정하지 않아도 호출한 지점으로 이동
            .keylineTint(.accent)
        }
    }
}
