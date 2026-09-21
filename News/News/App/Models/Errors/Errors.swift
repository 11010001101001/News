//
//  Errors.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Foundation

enum ApiError: LocalizedError {
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

enum Errors {
    case topicLabelNoInfo
    case badRequest
    case unauthorized
    case tooManyRequests
    case serverError
    case timeout
    case mappingError
    case invalidUrl
    case responseError
    case undefinedError
    case imageLoadingError
    case noConnection
    case loadingFailed

    var localizedDescription: LocalizedStringResource {
        switch self {
        case .topicLabelNoInfo: .errorsTopicLabelNoInfo
        case .badRequest: .errorsBadRequest
        case .unauthorized: .errorsUnauthorized
        case .tooManyRequests: .errorsTooManyRequests
        case .serverError: .errorsServerError
        case .timeout: .errorsTimeout
        case .mappingError: .errorsMapping
        case .invalidUrl: .errorsInvalidUrl
        case .responseError: .errorsResponseError
        case .undefinedError: .errorsUndefinedError
        case .imageLoadingError: .errorsImageLoadingError
        case .noConnection: .errorsNoConnection
        case .loadingFailed: .errorsLoadingFailed
        }
    }
}
