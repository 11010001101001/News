//
//  NetworkManager.swift
//  News
//
//  Created by Ярослав Куприянов on 10.10.2025.
//

import Foundation
import ModelsKit
import LocalizationKit

public protocol NetworkManagerProtocol: Sendable {
    func loadNews(category: String) async throws -> [Article]
}

actor NetworkManager: NetworkManagerProtocol {
    func loadNews(category: String) async throws -> [Article] {
        guard let url = URL(string: Mode.category(category).urlString) else {
            throw ApiError.mappingError(msg: Strings.errorsMapping)
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch let urlError as URLError {
            if urlError.code == .notConnectedToInternet {
                throw ApiError.noConnection(msg: Strings.errorsNoConnection)
            } else {
                let errStr =
                    "\(Errors.mappingError)/ errorCode:\(urlError.errorCode)/ code:\(urlError.code)"
                throw ApiError.mappingError(
                    msg: "\(errStr)/ loc.description:\(urlError.localizedDescription)"
                )
            }
        } catch {
            throw ApiError.mappingError(msg: Strings.errorsMapping)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.mappingError(msg: Strings.errorsMapping)
        }

        let statusCode = httpResponse.statusCode

        guard statusCode == HttpStatusCodes.ok.rawValue else {
            let message = HttpStatusCodes(rawValue: statusCode)?.message ?? Strings.errorsUnhandled
            throw ApiError.definite(msg: message)
        }

        guard let model = try? JSONDecoder().decode(CommonInfo.self, from: data) else {
            throw ApiError.mappingError(msg: Strings.errorsMapping)
        }

        return model.articles.orEmpty
    }
}
