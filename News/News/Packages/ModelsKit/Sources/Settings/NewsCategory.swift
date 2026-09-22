//
//  NewsCategory.swift
//  News
//
//  Created by Ярослав Куприянов on 27.03.2024.
//

import CoreKit
import Foundation

public enum NewsCategory: String, CaseIterable, Identifiable, DisplayName {
    public var id: Self { self }

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

    public var displayName: LocalizedStringResource {
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
}
