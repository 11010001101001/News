//
//  Errors.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Foundation

enum ApiError: LocalizedError {
    case invalidRequest(msg: String)
    case tooManyRequests(msg: String)
    case internalServerError(msg: String)
    case notFound(msg: String)
    case badRequest(msg: String)
    case mappingError(msg: String)
    case undefined(msg: String)
    case noConnection(msg: String)
}

struct Errors {
	static let topicLabelNoInfo = Texts.Errors.topicLabelNoInfo()
	static let badRequest = Texts.Errors.badRequest()
    static let unauthorized = Texts.Errors.unauthorized()
    static let tooManyRequests = Texts.Errors.tooManyRequests()
    static let serverError = Texts.Errors.serverError()
    static let timeout = Texts.Errors.timeout()
    static let mappingError = Texts.Errors.mappingError()
    static let invalidUrl = Texts.Errors.invalidUrl()
    static let responseError = Texts.Errors.responseError()
    static let undefinedError = Texts.Errors.undefinedError()
	static let imageLoadingError = Texts.Errors.imageLoadingError()
    static let noConnection = Texts.Errors.noConnection()
	static let loadingFailed = Texts.Errors.loadingFailed()
}
