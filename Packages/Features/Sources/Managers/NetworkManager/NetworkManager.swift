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

final class NetworkManager: NetworkManagerProtocol {
    func loadNews(category: String) async throws -> [Article] {
        let url = try makeURL(category: category)
        let (data, response) = try await fetch(url)
        try validate(response)
        return try decode(data).articles.orEmpty
    }
}

private extension NetworkManager {
    func makeURL(category: String) throws -> URL {
        guard let url = URL(string: Mode.category(category).urlString) else {
            throw ApiError.mappingError(msg: Strings.errorsMapping)
        }
        return url
    }

    func fetch(_ url: URL) async throws -> (Data, URLResponse) {
        do {
            return try await URLSession.shared.data(from: url)
        } catch let error as URLError where error.code == .cancelled {
            throw CancellationError()
        } catch let error as URLError where error.code == .notConnectedToInternet {
            throw ApiError.noConnection(msg: Strings.errorsNoConnection)
        } catch let error as URLError {
            let info = "errorCode:\(error.errorCode)/ code:\(error.code)/ loc.description:\(error.localizedDescription)"
            let error = "\(Errors.mappingError)/ \(info)"
            throw ApiError.mappingError(msg: .init(stringLiteral: error))
        } catch {
            throw ApiError.mappingError(msg: Strings.errorsMapping)
        }
    }

    func validate(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else {
            throw ApiError.mappingError(msg: Strings.errorsMapping)
        }
        guard http.statusCode == HttpStatusCodes.ok.rawValue else {
            let message = HttpStatusCodes(rawValue: http.statusCode)?.message ?? Strings.errorsUnhandled
            throw ApiError.definite(msg: message)
        }
    }

    func decode(_ data: Data) throws -> CommonInfo {
        guard let model = try? JSONDecoder().decode(CommonInfo.self, from: data) else {
            throw ApiError.mappingError(msg: Strings.errorsMapping)
        }
        return model
    }
}
