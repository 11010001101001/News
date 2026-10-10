//
//  NewsCategory.swift
//  News
//
//  Created by Ярослав Куприянов on 27.03.2024.
//

import CoreKit
import Foundation
import LocalizationKit
import SwiftData

public enum NewsCategory: String, CaseIterable, Identifiable, Sendable, Codable {
    public var id: Self { self }

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
