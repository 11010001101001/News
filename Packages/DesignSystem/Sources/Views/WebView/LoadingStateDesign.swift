//
//  File.swift
//  DesignSystem
//
//  Created by Slava on 22.09.2026.
//

import Foundation

public enum LoadingStateDesign {
    case loading
    case loaded
    case error(message: LocalizedStringResource?)

    public var loaderOpacity: CGFloat {
        switch self {
        case .loading: 1
        case .error, .loaded: 0
        }
    }

    public var contentOpacity: CGFloat {
        switch self {
        case .loaded: 1
        case .error, .loading: 0
        }
    }

    public var errorOpacity: CGFloat {
        switch self {
        case .loading, .loaded: 0
        case .error: 1
        }
    }

    public var errorMessage: LocalizedStringResource? {
        switch self {
        case .error(let message): message
        case .loaded, .loading: nil
        }
    }
}
