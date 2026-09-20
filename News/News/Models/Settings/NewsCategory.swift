//
//  NewsCategory.swift
//  News
//
//  Created by Ярослав Куприянов on 27.03.2024.
//

import SwiftUI

enum NewsCategory: String, CaseIterable, Identifiable {
    var id: Self { self }

    static var tabImage: String { SFSymbols.listBullet.rawValue }

    static var random: String {
        allCases.randomElement()?.rawValue ?? .empty
    }

    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology

    var localizedResource: LocalizedStringResource {
        switch self {
        case .business: LocalizedStringResource("Category.business")
        case .entertainment: LocalizedStringResource("Category.entertainment")
        case .general: LocalizedStringResource("Category.general")
        case .health: LocalizedStringResource("Category.health")
        case .science: LocalizedStringResource("Category.science")
        case .sports: LocalizedStringResource("Category.sports")
        case .technology: LocalizedStringResource("Category.technology")
        }
    }

    var image: Image {
        let systemName: SFSymbols =
            switch self {
            case .business: .brainFilledHeadProfile
            case .entertainment: .play
            case .general: .listClipboard
            case .health: .boltHeart
            case .science: .atom
            case .sports: .figureOutdoorCycle
            case .technology: .iphoneGen1RadiowavesLeftAndRight
            }
        return Image(systemName: systemName.rawValue)
    }
}
