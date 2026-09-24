//
//  WidgetsManager.swift
//  News
//
//  Created by Ярослав Куприянов on 02.11.2025.
//

import ActivityKit
import Foundation
import WidgetKit
import ModelsKit
import CoreKit

@MainActor
public final class WidgetsManager {
    public static var shared = WidgetsManager()

    private var currentLevel: Level = .newbie
    private var currentActivity: Activity<NewsWidgetsAttributes>?
    private var articles = [Article]()
    private var oldActivitiesEnded = false

    func start() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live activities are not enabled in system settings or Info.plist")
            return
        }

        let activeActivity = Activity<NewsWidgetsAttributes>.activities.first {
            $0.activityState == .active
        }

        if let activeActivity {
            currentActivity = activeActivity
            endOldActivities(excluding: activeActivity.id)
            return
        }

        guard currentActivity == nil || currentActivity?.activityState == .ended else {
            return
        }

        let attributes = NewsWidgetsAttributes()
        let contentState = NewsWidgetsAttributes.ContentState(level: currentLevel, procents: .zero)

        do {
            let activity = try Activity<NewsWidgetsAttributes>.request(
                attributes: attributes,
                content: .init(state: contentState, staleDate: Date().hour),
                pushType: nil
            )
            currentActivity = activity
            print("Activity started: \(activity.id)")
            endOldActivities(excluding: activity.id)
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

        if currentActivity == nil || currentActivity?.activityState == .ended {
            start()
        }

        let activeActivity = Activity<NewsWidgetsAttributes>.activities.first {
            $0.activityState == .active
        }

        guard let activity = currentActivity ?? activeActivity else {
            return
        }

        currentActivity = activity
        let content = ActivityContent(state: newState, staleDate: Date().hour)

        nonisolated(unsafe) let unsafeActivity = activity
        Task {
            await unsafeActivity.update(content)
        }

        updateStaticWidget()

        guard level != currentLevel else { return }

        currentLevel = level
    }

    func updateStaticWidget() {
        WidgetCenter.shared.reloadAllTimelines()
    }

    func endOldActivities(excluding currentId: String? = nil) {
        guard !oldActivitiesEnded else { return }
        oldActivitiesEnded = true

        Task {
            for activity in Activity<NewsWidgetsAttributes>.activities {
                if let currentId, activity.id == currentId {
                    continue
                }
                nonisolated(unsafe) let unsafeActivity = activity
                await unsafeActivity.end(nil, dismissalPolicy: .immediate)
            }
        }
    }

    public func getLevel(for procents: Int) -> Level {
        Level.getLevel(for: procents)
    }
}
