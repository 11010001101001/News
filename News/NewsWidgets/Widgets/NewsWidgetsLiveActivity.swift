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
            blockOrExpandedView(procents: context.state.procents)
        } dynamicIsland: { context in
            DynamicIsland(
                expanded: {
                    DynamicIslandExpandedRegion(.center) {
                        blockOrExpandedView(procents: context.state.procents)
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
    func blockOrExpandedView(procents: Int) -> some View {
        let lvls = [Level.newbie, Level.curiousObserver, Level.loopMaster, Level.techNinja]
        let isNewbieActive = procents >= 0
        let isObserverActive = procents >= 25
        let isLooperActive = procents >= 75
        let isNinjaActive = procents >= 100

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
            .padding(.horizontal, 30)

            HStack(alignment: .center) {
                Circle()
                    .fill(isNewbieActive ? Level.newbie.color : .gray)
                    .frame(width: 30, height: 30)
                    .shadow(color: isNewbieActive ? Level.newbie.color : .clear, radius: 7)
                    .overlay(alignment: .center) {
                        Text(Level.newbie.image)
                            .grayscale(isNewbieActive ? 0 : 1)
                    }

                Spacer()

                Circle()
                    .fill(isObserverActive ? Level.curiousObserver.color : .gray)
                    .frame(width: 30, height: 30)
                    .shadow(color: isObserverActive ? Level.curiousObserver.color : .clear, radius: 7)
                    .overlay(alignment: .center) {
                        Text(Level.curiousObserver.image)
                            .grayscale(isObserverActive ? 0 : 1)
                    }

                Spacer()

                Circle()
                    .fill(isLooperActive ? Level.loopMaster.color : .gray)
                    .frame(width: 30, height: 30)
                    .shadow(color: isLooperActive ? Level.loopMaster.color : .clear, radius: 7)
                    .overlay(alignment: .center) {
                        Text(Level.loopMaster.image)
                            .grayscale(isLooperActive ? 0 : 1)
                    }

                Spacer()

                Circle()
                    .fill(isNinjaActive ? Level.techNinja.color : .gray)
                    .frame(width: 30, height: 30)
                    .shadow(color: isNinjaActive ? Level.techNinja.color : .clear, radius: 7)
                    .overlay(alignment: .center) {
                        Text(Level.techNinja.image)
                            .grayscale(isNinjaActive ? 0 : 1)
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
    NewsWidgetsAttributes.ContentState(level: .loopMaster, procents: 60)
}
