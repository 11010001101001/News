//
//  HttpStatusCodes.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Foundation

enum HttpStatusCodes: Int {
	case badRequest = 400
	case internalServerError = 500
	case notFound = 401
	// swiftlint:disable identifier_name
	case ok = 200
	// swiftlint:enable identifier_name
	case tooManyRequests = 429

	var message: String {
		switch self {
		case .ok:
			Texts.Loading.State.ok()
		case .badRequest:
			Errors.badRequest
		case .internalServerError:
			Errors.serverError
		case .notFound:
			Errors.unauthorized
		case .tooManyRequests:
			Errors.tooManyRequests
		}
	}
}
