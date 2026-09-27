//
//  LoadingState.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 10.02.2025.
//

import Foundation

public enum LoadingStateModel {
    case loading
    case loaded(data: [Article])
    case error(message: LocalizedStringResource?)
}

extension LoadingStateModel: Equatable {
    public static func == (lhs: LoadingStateModel, rhs: LoadingStateModel) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading): return true
        case (let .loaded(dataLhs), let .loaded(dataRhs)): return dataLhs == dataRhs
        case (let .error(msgLhs), let .error(msgRhs)): return msgLhs == msgRhs
        default: return false
        }
    }
}
