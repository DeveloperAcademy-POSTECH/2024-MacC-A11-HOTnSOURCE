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
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
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
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(.green)
        }
    }
}
//
//extension DynamicIslandWidgetAttributes{
//    fileprivate static var preview: DynamicIslandWidgetAttributes {
//        DynamicIslandWidgetAttributes(place: Place(
//            id: UUID(),
//            name: "도서관 5층",
//            backgroundDecibel: 40.0,
//            distance: 2.0))
//    }
//}
//
//extension DynamicIslandWidgetAttributes.ContentState {
//    fileprivate static var smiley: DynamicIslandWidgetAttributes.ContentState {
//        DynamicIslandWidgetAttributes.ContentState(isMetering: false)
//    }
//    
//    fileprivate static var starEyes: DynamicIslandWidgetAttributes.ContentState {
//        DynamicIslandWidgetAttributes.ContentState(isMetering: false)
//    }
//}
//
//#Preview("Notification", as: .content, using: DynamicIslandWidgetAttributes.preview) {
//    DynamicIslandWidgetLiveActivity()
//} contentStates: {
//    DynamicIslandWidgetAttributes.ContentState.smiley
//    DynamicIslandWidgetAttributes.ContentState.starEyes
//}
