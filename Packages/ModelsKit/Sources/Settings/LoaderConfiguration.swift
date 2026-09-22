//
//  LoaderConfiguration.swift
//  News
//
//  Created by Ярослав Куприянов on 04.04.2024.
//

import Foundation
import LocalizationKit

public enum LoaderConfiguration: String, CaseIterable, Identifiable {
    public var id: Self { return self }

    case rocket
    case hourGlass = "hourglass"
    case astronaut
    case hamster
    case kitten

    public var displayName: LocalizedStringResource {
        switch self {
        case .rocket: Strings.loaderRocket
        case .hourGlass: Strings.loaderHourglass
        case .astronaut: Strings.loaderAstronaut
        case .hamster: Strings.loaderHamster
        case .kitten: Strings.loaderKitten
        }
    }
}
