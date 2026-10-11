//
//  ApiError.swift
//  ModelsKit
//
//  Created by Slava on 12.10.2026.
//

import Foundation

public enum ApiError: LocalizedError {
    case invalidRequest(msg: LocalizedStringResource)
    case tooManyRequests(msg: LocalizedStringResource)
    case internalServerError(msg: LocalizedStringResource)
    case notFound(msg: LocalizedStringResource)
    case badRequest(msg: LocalizedStringResource)
    case mappingError(msg: LocalizedStringResource)
    case undefined(msg: LocalizedStringResource)
    case noConnection(msg: LocalizedStringResource)
    case definite(msg: LocalizedStringResource)
}
