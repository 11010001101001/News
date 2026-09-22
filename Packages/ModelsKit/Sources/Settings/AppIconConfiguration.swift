//
//  AppIcon.swift
//  News
//
//  Created by Ярослав Куприянов on 01.02.2025.
//

import Foundation
import LocalizationKit

public enum AppIconConfiguration: String, CaseIterable, Identifiable {
    public var id: Self { return self }

    case globe
    case cat
    case dart

    public var iconName: String {
        return switch self {
        case .globe: "GlobeIcon"
        case .cat: "CatIcon"
        case .dart: "DartIcon"
        }
    }
    
    public var displayName: LocalizedStringResource {
        switch self {
        case .globe: Strings.appIconGlobe
        case .cat: Strings.appIconCat
        case .dart: Strings.appIconDart
        }
    }
}
