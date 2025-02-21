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
    func playLoaded() {
        guard soundTheme != SoundTheme.silentMode.rawValue else { return }

        loadedSound = switch SoundTheme(rawValue: soundTheme) {
        case .starwars:
            "starwars_loaded"
        case .cats:
            "cats_loaded"
        default:
            String.empty
        }
    }

    func playRefresh() {
        guard soundTheme != SoundTheme.silentMode.rawValue else { return }

        refreshSound = switch SoundTheme(rawValue: soundTheme) {
        case .starwars:
            starwarsRefresh
        case .cats:
            "cats_refresh"
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
}

extension ViewModel {
    private var starwarsRefresh: String {
        Set(["starwars_refresh", "starwars_refresh1", "starwars_refresh2"]).randomElement() ?? ""
    }
}
