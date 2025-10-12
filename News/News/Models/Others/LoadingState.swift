//
//  LoadingState.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 10.02.2025.
//
import Foundation

enum LoadingState {
    case loading
    case loaded(data: [Article])
    case error(message: String?)

    var loaderOpacity: CGFloat {
        switch self {
        case .loading: 1
        case .error, .loaded: 0
        }
    }

    var contentOpacity: CGFloat {
        switch self {
        case .loaded: 1
        case .error, .loading: 0
        }
    }

    var errorOpacity: CGFloat {
        switch self {
        case .loading, .loaded: 0
        case .error: 1
        }
    }

    var errorMessage: String? {
        switch self {
        case let .error(message): message
        case .loaded, .loading: nil
        }
    }
}

extension LoadingState: Equatable {
    static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (let .loaded(dataLhs), let .loaded(dataRhs)): return dataLhs == dataRhs
        case (let .error(msgLhs), let .error(msgRhs)): return msgLhs == msgRhs
        default: return false
        }
    }
}
