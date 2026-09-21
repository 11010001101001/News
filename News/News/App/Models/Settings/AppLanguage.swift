//
//  AppLanguage.swift
//  News
//
//  Created by Ярослав Куприянов on 19.09.2026.
//

import Foundation

public struct AppLanguage: Identifiable, Equatable, Hashable {
    public let rawValue: String
    public let title: String
    public let flag: String

    public var id: String { rawValue }

    public static let english = AppLanguage(rawValue: "en", title: "English", flag: "🇬🇧")
    public static let russian = AppLanguage(rawValue: "ru", title: "Русский", flag: "🇷🇺")
    public static let indonesian = AppLanguage(rawValue: "id", title: "Bahasa Indonesia", flag: "🇮🇩")

    public static var allCases: [AppLanguage] {
        [.english, .russian, .indonesian]
    }

    public static var image: String { SFSymbols.globe.rawValue }

    public init(rawValue: String, title: String, flag: String) {
        self.rawValue = rawValue
        self.title = title
        self.flag = flag
    }

    public init?(rawValue: String) {
        switch rawValue {
        case "en": self = .english
        case "ru": self = .russian
        case "id": self = .indonesian
        default: return nil
        }
    }
}
