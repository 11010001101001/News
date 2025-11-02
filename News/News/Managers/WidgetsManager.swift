//
//  ActivityManager.swift
//  News
//
//  Created by Ярослав Куприянов on 02.11.2025.
//

import Foundation
import ActivityKit
import WidgetKit

final class WidgetsManager {
    static var shared = WidgetsManager()

    private var currentLevel: Level = .newbie
    private var currentActivity: Activity<NewsWidgetsAttributes>?
    private var articles = [Article]()

    func start(articles: [Article], watchedTopics: Set<String>) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        Task {
            for activity in Activity<NewsWidgetsAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }

        guard currentActivity == nil else { return }

        let watched = articles.filter { article in
            watchedTopics.contains(where: { $0 == article.key })
        }
        let procents = watched.count * 100 / articles.count
        let attributes = NewsWidgetsAttributes()
        let level = getLevel(for: procents)
        currentLevel = level
        let contentState = NewsWidgetsAttributes.ContentState(level: level)

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

    func updateLevel(watchedTopics: Set<String>) {
        let watched = articles.filter { article in
            watchedTopics.contains(where: { $0 == article.key })
        }
        let procents = watched.count * 100 / articles.count
        let level = getLevel(for: procents)

        guard level != currentLevel else { return }

        currentLevel = level

        let newState = NewsWidgetsAttributes.ContentState(level: level)

        Task {
            await currentActivity?.update(.init(state: newState, staleDate: .distantFuture))
        }

        updateStaticWidget()
    }

    func stop() {
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

    func getLevel(for procents: Int) -> Level {
        switch procents {
        case (0..<25): .newbie
        case (25..<50): .curiousObserver
        case (50..<75): .loopMaster
        case (75...100): .techNinja
        default: .unrecognized
        }
    }
}
