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
