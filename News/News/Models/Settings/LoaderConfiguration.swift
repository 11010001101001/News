//
//  LoaderConfiguration.swift
//  News
//
//  Created by Ярослав Куприянов on 04.04.2024.
//

import Foundation
import SwiftUI

enum LoaderConfiguration: String, CaseIterable, Identifiable {
    var id: Self { return self }

    static var tabImage: String { SFSymbols.hourglass.rawValue }

    case rocket
    case hourGlass = "hourglass"
    case astronaut
    case hamster
    case kitten

    var shadowColor: Color {
        switch self {
        case .rocket: .orange
        case .hourGlass: .cyan
        case .astronaut: .red
        case .hamster: .blue
        case .kitten: .indigo
        }
    }

    var displayName: LocalizedStringResource {
        switch self {
        case .rocket: LocalizedStringResource("Loader.rocket")
        case .hourGlass: LocalizedStringResource("Loader.hourglass")
        case .astronaut: LocalizedStringResource("Loader.astronaut")
        case .hamster: LocalizedStringResource("Loader.hamster")
        case .kitten: LocalizedStringResource("Loader.kitten")
        }
    }
}
