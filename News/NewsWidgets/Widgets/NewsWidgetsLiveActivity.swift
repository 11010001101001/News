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
    struct ContentState: Codable & Hashable {
        let level: Level
    }
}

struct NewsWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NewsWidgetsAttributes.self) { context in
            blockOrExpandedView(lvl: context.state.level)
        } dynamicIsland: { context in
            DynamicIsland(
                expanded: {
                    DynamicIslandExpandedRegion(.center) {
                        blockOrExpandedView(lvl: context.state.level)
                    }
                },
                compactLeading: {
                    Text("lvl:")
                },
                compactTrailing: {
                    buildTrailingOrMinimal(lvl: context.state.level)
                },
                minimal: {
                    buildTrailingOrMinimal(lvl: context.state.level)
                }
            )
        }
    }
}

// MARK: - Content
private extension NewsWidgetsLiveActivity {
    @ViewBuilder
    func blockOrExpandedView(lvl: Level) -> some View {
        let lvls = [Level.newbie, Level.curiousObserver, Level.loopMaster, Level.techNinja]

        HStack(alignment: .center) {
            ForEach(lvls, id: \.self) { level in
                let isActive = level == lvl

                if level != Level.newbie {
                    Spacer()
                }

                Circle()
                    .fill(isActive ? lvl.color : .gray)
                    .frame(width: 30, height: 30)
                    .shadow(color: isActive ? lvl.color : .clear, radius: 7)
                    .overlay(alignment: .center) {
                        Text(level.image)
                            .grayscale(isActive ? 0 : 1)
                    }

                if level != Level.techNinja {
                    Rectangle()
                        .fill(.gray)
                        .frame(height: 2)
                }
            }
        }
        .padding(.horizontal, 40)
    }

    func buildTrailingOrMinimal(lvl: Level) -> some View {
        Text(lvl.image)
            .shadow(color: lvl.color, radius: 7)
    }
}

#Preview("test", as: .content, using: NewsWidgetsAttributes()) {
    NewsWidgetsLiveActivity()
} contentStates: {
    NewsWidgetsAttributes.ContentState(level: .loopMaster)
}
