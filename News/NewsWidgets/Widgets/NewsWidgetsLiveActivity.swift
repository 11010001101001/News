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
        let procents: Int
    }
}

struct NewsWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NewsWidgetsAttributes.self) { context in
            blockOrExpandedView(lvl: context.state.level, procents: context.state.procents)
        } dynamicIsland: { context in
            DynamicIsland(
                expanded: {
                    DynamicIslandExpandedRegion(.center) {
                        blockOrExpandedView(lvl: context.state.level, procents: context.state.procents)
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
    func blockOrExpandedView(lvl: Level, procents: Int) -> some View {
        let lvls = [Level.newbie, Level.curiousObserver, Level.loopMaster, Level.techNinja]

        ZStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                LinearGradient(
                    colors: lvls.map { $0.color },
                    startPoint: .leading, endPoint: .trailing
                )
                .mask(
                    ProgressView(value: Float(procents) / 100)
                        .progressViewStyle(.linear)
                )
            }
            .frame(height: 8)

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
    NewsWidgetsAttributes.ContentState(level: .loopMaster, procents: 20)
}
