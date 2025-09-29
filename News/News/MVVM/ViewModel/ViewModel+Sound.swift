//
//  ViewModel+Sound.swift
//  News
//
//  Created by Ярослав Куприянов on 31.03.2024.
//

import Foundation
import Combine

// MARK: - Logic

extension ViewModel {
    func playRefresh() {
        guard soundTheme != SoundTheme.silentMode.rawValue else { return }

        refreshSound = switch SoundTheme(rawValue: soundTheme) {
        case .starwars:
            starwarsRefresh
        case .cats:
            catsRefresh
        default:
            String.empty
        }
    }

    func playError() {
        guard soundTheme != SoundTheme.silentMode.rawValue else { return }

        errorSound = switch SoundTheme(rawValue: soundTheme) {
        case .starwars:
            "starwars_error"
        case .cats:
            "cats_error"
        default:
            String.empty
        }
    }

    /// sound theme can change - do it during every app launch and sound changing
    func configureNotifications() {
        notificationSound = switch SoundTheme(rawValue: soundTheme) {
        case .starwars:
            "starwars_notification"
        case .cats:
            "cats_notification"
        default:
            String.empty
        }
    }
}

private extension ViewModel {
    var starwarsRefresh: String {
        Set(["starwars_refresh", "starwars_refresh1"]).randomElement() ?? .empty
    }

    var catsRefresh: String {
        Set(["cats_refresh", "cats_refresh1"]).randomElement() ?? .empty
    }
}
