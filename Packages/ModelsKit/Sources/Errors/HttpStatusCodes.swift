//
//  HttpStatusCodes.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Foundation
import LocalizationKit

public enum HttpStatusCodes: Int {
    case badRequest = 400
    case internalServerError = 500
    case notFound = 401
    // swiftlint:disable identifier_name
    case ok = 200
    // swiftlint:enable identifier_name
    case tooManyRequests = 429

    public var message: LocalizedStringResource {
        switch self {
        case .ok:
            Strings.ok
        case .badRequest:
            Errors.badRequest.localizedDescription
        case .internalServerError:
            Errors.serverError.localizedDescription
        case .notFound:
            Errors.unauthorized.localizedDescription
        case .tooManyRequests:
            Errors.tooManyRequests.localizedDescription
        }
    }
}
