//
//  ActivityManager.swift
//  News
//
//  Created by Ярослав Куприянов on 02.11.2025.
//

import ActivityKit
import Foundation
import WidgetKit
import ModelsKit

@MainActor
public final class WidgetsManager {
    public static var shared = WidgetsManager()

    private var currentLevel: Level = .newbie
    private var currentActivity: Activity<NewsWidgetsAttributes>?
    private var articles = [Article]()
    private var oldActivitiesEnded = false

    func start() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled, currentActivity == nil else {
            return
        }

        endOldActivities()

        let attributes = NewsWidgetsAttributes()
        let contentState = NewsWidgetsAttributes.ContentState(level: currentLevel, procents: .zero)

        do {
            let activity = try Activity<NewsWidgetsAttributes>.request(
                attributes: attributes,
                content: .init(state: contentState, staleDate: .distantFuture),
                pushType: nil
            )
            currentActivity = activity
            print("Activity started: \(activity.id)")
        } catch {
            print("Failed to start activity: \(error)")
        }
    }

    func updateArticles(_ articles: [Article]) {
        self.articles = articles
    }

    public func updateLevel(watchedTopics: Set<String>) {
        guard !articles.isEmpty else { return }

        let watched = articles.filter { article in
            watchedTopics.contains(where: { $0 == article.key })
        }
        let procents = watched.count * 100 / articles.count
        let level = getLevel(for: procents)

        let newState = NewsWidgetsAttributes.ContentState(level: level, procents: procents)

        guard let activity = currentActivity else { return }
        
        let content = ActivityContent(state: newState, staleDate: .distantFuture)

        nonisolated(unsafe) let unsafeActivity = activity

        Task {
            await unsafeActivity.update(content)
        }

        guard level != currentLevel else { return }

        currentLevel = level

        updateStaticWidget()
    }

    public func stop() {
        let semaphore = DispatchSemaphore(value: 0)

        Task {
            for activity in Activity<NewsWidgetsAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
            semaphore.signal()
        }

        semaphore.wait()
    }

    func updateStaticWidget() {
        WidgetCenter.shared.reloadTimelines(ofKind: "NewsWidget")
    }

    func endOldActivities() {
        guard !oldActivitiesEnded else { return }
        oldActivitiesEnded = true

        Task {
            for activity in Activity<NewsWidgetsAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }
    }

    public func getLevel(for procents: Int) -> Level {
        switch procents {
        case (0..<25): .newbie
        case (25..<75): .curiousObserver
        case (75..<100): .loopMaster
        case (100...): .techNinja
        default: .unrecognized
        }
    }
}
