//
//  NewsWidgetsLiveActivity.swift
//  NewsWidgets
//
//  Created by Ярослав Куприянов on 05.04.2024.
//

import ActivityKit
import ModelsKit
import SwiftUI
import WidgetKit
import DesignSystem
import LocalizationKit

struct NewsWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NewsWidgetsAttributes.self) { context in
            BlockOrExpandedView(procents: context.state.procents)
        } dynamicIsland: { context in
            DynamicIsland(
                expanded: {
                    DynamicIslandExpandedRegion(.center) {
                        BlockOrExpandedView(procents: context.state.procents)
                    }
                },
                compactLeading: {
                    CompactLeadingView(level: context.state.level)
                },
                compactTrailing: {
                    TrailingView(level: context.state.level)
                },
                minimal: {
                    TrailingView(level: context.state.level)
                }
            )
        }
    }
}
