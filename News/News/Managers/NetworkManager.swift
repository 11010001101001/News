//
//  NetworkManager.swift
//  News
//
//  Created by Ярослав Куприянов on 10.10.2025.
//

import Foundation

protocol NetworkManagerProtocol: Sendable {
    func loadNews(category: String) async throws -> [Article]
}

actor NetworkManager: NetworkManagerProtocol {
    func loadNews(category: String) async throws -> [Article] {
        guard let url = URL(string: Mode.category(category).urlString) else {
            throw ApiError.mappingError(msg: Errors.mappingError)
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(from: url)
        } catch let urlError as URLError {
            if urlError.code == .notConnectedToInternet {
                throw ApiError.noConnection(msg: Errors.noConnection)
            } else {
                let errStr = "\(Errors.mappingError)/ errorCode:\(urlError.errorCode)/ code:\(urlError.code)"
                throw ApiError.mappingError(
                    msg: "\(errStr)/ loc.description:\(urlError.localizedDescription)"
                )
            }
        } catch {
            throw ApiError.mappingError(msg: error.localizedDescription)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.mappingError(msg: Errors.mappingError)
        }

        let statusCode = httpResponse.statusCode
        guard statusCode == HttpStatusCodes.ok.rawValue else {
            let message = (HttpStatusCodes(rawValue: statusCode)?.message).orEmpty
            throw ApiError.mappingError(msg: message)
        }

        guard let model = try? JSONDecoder().decode(CommonInfo.self, from: data) else {
            throw ApiError.mappingError(msg: Errors.mappingError)
        }

        return model.articles.orEmpty
    }
}
