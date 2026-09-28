//
//  WidgetsManager.swift
//  News
//
//  Created by Ярослав Куприянов on 02.11.2025.
//

import ActivityKit
import CoreKit
import Foundation
import ModelsKit
import WidgetKit

public protocol WidgetsManagerProtocol {
    func updateLevel(watchedTopics: Set<String>)
    func start()
    func updateArticles(_ articles: [Article])
}

final class WidgetsManager: WidgetsManagerProtocol {
    private var articles = [Article]()

    func start() {
        Task {
            for activity in Activity<NewsWidgetsAttributes>.activities {
                await activity.end(nil, dismissalPolicy: .immediate)
            }

            _ = try? Activity<NewsWidgetsAttributes>.request(
                attributes: NewsWidgetsAttributes(),
                content: .init(
                    state: NewsWidgetsAttributes.ContentState(level: .newbie, procents: .zero),
                    staleDate: Date().hour
                ),
                pushType: nil
            )
        }
    }

    func updateArticles(_ articles: [Article]) {
        self.articles = articles
    }

    func updateLevel(watchedTopics: Set<String>) {
        guard !articles.isEmpty else { return }

        let watched = articles.filter { article in
            watchedTopics.contains(where: { $0 == article.key })
        }

        let procents = watched.count * 100 / articles.count
        let level = Level.getLevel(for: procents)
        let newState = NewsWidgetsAttributes.ContentState(level: level, procents: procents)

        let activeActivity = Activity<NewsWidgetsAttributes>.activities.first {
            $0.activityState == .active
        }

        guard let activeActivity else {
            // TODO: save to local variable and manage it after no .active exists
            start()
            updateLevel(watchedTopics: watchedTopics)
            return
        }

        let content = ActivityContent(state: newState, staleDate: Date().hour)

        Task {
            await activeActivity.update(content)
        }

        updateStaticWidget()
    }

    func updateStaticWidget() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}
