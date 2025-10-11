//
//  ImageProvider.swift
//  News
//
//  Created by Ярослав Куприянов on 28.03.2024.
//

import Foundation
import SwiftUI

protocol ImageProvider {}

// swiftlint:disable cyclomatic_complexity
extension ImageProvider {
    func getImage(for settingName: String) -> some View {
        let imageName = switch settingName {
        case NewsCategory.technology.rawValue:
            "iphone.gen1.radiowaves.left.and.right"
        case NewsCategory.sports.rawValue:
            "figure.outdoor.cycle"
        case NewsCategory.science.rawValue:
            "atom"
        case NewsCategory.health.rawValue:
            "bolt.heart"
        case NewsCategory.general.rawValue:
            "list.clipboard"
        case NewsCategory.entertainment.rawValue:
            "play"
        case NewsCategory.business.rawValue:
            "brain.filled.head.profile"
        case SoundTheme.starwars.rawValue:
            "star.circle.fill"
        case SoundTheme.silentMode.rawValue:
            "powersleep"
        case SoundTheme.cats.rawValue:
            "cat.fill"
        case Texts.App.contactUs():
            "paperplane.fill"
        default:
            "info.circle.fill"
        }

        return Image(systemName: imageName)
    }
}
// swiftlint:enable cyclomatic_complexity
