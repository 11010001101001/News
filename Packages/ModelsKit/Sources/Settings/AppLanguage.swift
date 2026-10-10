//
//  AppLanguage.swift
//  News
//
//  Created by Ярослав Куприянов on 19.09.2026.
//

import Foundation

public enum AppLanguage: String, CaseIterable, Identifiable, Sendable, Codable {
    public var id: Self { return self }

    case english = "en"
    case russian = "ru"
    case indonesian = "id"

    public var title: String {
        switch self {
        case .english: "English"
        case .russian: "Русский"
        case .indonesian: "Bahasa Indonesia"
        }
    }

    public var flag: String {
        switch self {
        case .english: "🇬🇧"
        case .russian: "🇷🇺"
        case .indonesian: "🇮🇩"
        }
    }
}
