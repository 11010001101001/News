//
//  Errors.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Foundation
import LocalizationKit

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

public enum Errors {
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

    public var localizedDescription: LocalizedStringResource {
        switch self {
        case .topicLabelNoInfo: Strings.errorsTopicLabelNoInfo
        case .badRequest: Strings.errorsBadRequest
        case .unauthorized: Strings.errorsUnauthorized
        case .tooManyRequests: Strings.errorsTooManyRequests
        case .serverError: Strings.errorsServerError
        case .timeout: Strings.errorsTimeout
        case .mappingError: Strings.errorsMapping
        case .invalidUrl: Strings.errorsInvalidUrl
        case .responseError: Strings.errorsResponseError
        case .undefinedError: Strings.errorsUndefinedError
        case .imageLoadingError: Strings.errorsImageLoadingError
        case .noConnection: Strings.errorsNoConnection
        case .loadingFailed: Strings.errorsLoadingFailed
        }
    }
}
