//
//  ImageProvider.swift
//  News
//
//  Created by Ярослав Куприянов on 28.03.2024.
//

import Foundation
import SwiftUI

protocol ImageProvider {}

extension ImageProvider {
    func getImage(for id: String) -> some View {
        let imageName = switch id {
        case NewsCategory.technology.rawValue: SFSymbols.iphoneGen1RadiowavesLeftAndRight
        case NewsCategory.sports.rawValue: SFSymbols.figureOutdoorCycle
        case NewsCategory.science.rawValue: SFSymbols.atom
        case NewsCategory.health.rawValue: SFSymbols.boltHeart
        case NewsCategory.general.rawValue: SFSymbols.listClipboard
        case NewsCategory.entertainment.rawValue: SFSymbols.play
        case NewsCategory.business.rawValue: SFSymbols.brainFilledHeadProfile
        case SoundTheme.starwars.rawValue: SFSymbols.starFill
        case SoundTheme.silentMode.rawValue: SFSymbols.powersleep
        case SoundTheme.cats.rawValue: SFSymbols.catFill
        case Texts.App.contactUs(): SFSymbols.paperplaneFill
        case Texts.Widgets.levels(): SFSymbols.gamecontrollerFill
        default: SFSymbols.infoCircleFill
        }

        return Image(systemName: imageName.rawValue)
    }
}
