//
//  NewsCategory.swift
//  News
//
//  Created by Ярослав Куприянов on 27.03.2024.
//

import CoreKit
import Foundation
import LocalizationKit

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
        case .business: Strings.categoryBusiness
        case .entertainment: Strings.categoryEntertainment
        case .general: Strings.categoryGeneral
        case .health: Strings.categoryHealth
        case .science: Strings.categoryScience
        case .sports: Strings.categorySports
        case .technology: Strings.categoryTechnology
        }
    }
}
