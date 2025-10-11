//
//  AppIcon.swift
//  News
//
//  Created by Ярослав Куприянов on 01.02.2025.
//

import Foundation
import SwiftUI

enum AppIconConfiguration: String, CaseIterable, Identifiable {
    var id: Self { return self }

    static var title: String { "App icon" }

    static var image: String { "photo" }

    case globe
    case cat
    case dart

    var iconName: String {
        return switch self {
        case .globe: "GlobeIcon"
        case .cat: "CatIcon"
        case .dart: "DartIcon"
        }
    }

    var shadowColor: Color {
        switch self {
        case .globe: .cyan
        case .cat: .orange
        case .dart: .red
        }
    }
}
