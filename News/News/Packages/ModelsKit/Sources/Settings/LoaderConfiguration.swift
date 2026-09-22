//
//  LoaderConfiguration.swift
//  News
//
//  Created by Ярослав Куприянов on 04.04.2024.
//

import Foundation

public enum LoaderConfiguration: String, CaseIterable, Identifiable {
    public var id: Self { return self }

    case rocket
    case hourGlass = "hourglass"
    case astronaut
    case hamster
    case kitten

    public var displayName: LocalizedStringResource {
        switch self {
        case .rocket: LocalizedStringResource("Loader.rocket")
        case .hourGlass: LocalizedStringResource("Loader.hourglass")
        case .astronaut: LocalizedStringResource("Loader.astronaut")
        case .hamster: LocalizedStringResource("Loader.hamster")
        case .kitten: LocalizedStringResource("Loader.kitten")
        }
    }
}
