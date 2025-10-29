//
//  NewsWidgetsLiveActivity.swift
//  NewsWidgets
//
//  Created by Ярослав Куприянов on 05.04.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct NewsWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct NewsWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NewsWidgetsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension NewsWidgetsAttributes {
    fileprivate static var preview: NewsWidgetsAttributes {
        NewsWidgetsAttributes(name: "World")
    }
}

extension NewsWidgetsAttributes.ContentState {
    fileprivate static var smiley: NewsWidgetsAttributes.ContentState {
        NewsWidgetsAttributes.ContentState(emoji: "😀")
     }

     fileprivate static var starEyes: NewsWidgetsAttributes.ContentState {
         NewsWidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: NewsWidgetsAttributes.preview) {
   NewsWidgetsLiveActivity()
} contentStates: {
    NewsWidgetsAttributes.ContentState.smiley
    NewsWidgetsAttributes.ContentState.starEyes
}
