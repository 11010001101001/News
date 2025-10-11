//
//  NetworkManager.swift
//  News
//
//  Created by Ярослав Куприянов on 10.10.2025.
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
    var loadingFailed: AnyPublisher<Bool, Never> { get }
    var loadingSucceeded: AnyPublisher<Bool, Never> { get }
    var errorMessage: AnyPublisher<String, Never> { get }
    var newsArray: AnyPublisher<[Article], Never> { get }

    func loadNews(
        category: String,
        isRefresh: Bool,
        completion: Action?
    )
}

final class NetworkManager: ObservableObject {
    var loadingFailed: AnyPublisher<Bool, Never> { loadingFailedSubject.eraseToAnyPublisher() }
    var loadingSucceeded: AnyPublisher<Bool, Never> { loadingSucceededSubject.eraseToAnyPublisher() }
    var errorMessage: AnyPublisher<String, Never> { errorMessageSubject.eraseToAnyPublisher() }
    var newsArray: AnyPublisher<[Article], Never> { newsArraySubject.eraseToAnyPublisher() }

    private let loadingFailedSubject = PassthroughSubject<Bool, Never>()
    private let loadingSucceededSubject = PassthroughSubject<Bool, Never>()
    private let errorMessageSubject = PassthroughSubject<String, Never>()
    private let newsArraySubject = PassthroughSubject<[Article], Never>()
    private var cancellables = Set<AnyCancellable>()
}

// MARK: - NetworkManagerProtocol
extension NetworkManager: NetworkManagerProtocol {
    func loadNews(
        category: String,
        isRefresh: Bool,
        completion: Action?
    ) {
        guard let url = URL(string: Mode.category(category).urlString) else { return }

        if !isRefresh {
            loadingSucceededSubject.send(false)
            loadingFailedSubject.send(false)
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .retry(3)
            .mapError { [weak self] error in
                self?.mapError(error) ?? ApiError.mappingError(msg: Errors.mappingError)
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .sink { [weak self] result in
                switch result {
                case .finished:
                    break
                case let .failure(error):
                    self?.handleError(error)
                }
            } receiveValue: { [weak self] value in
                self?.handleResponse(value, completion)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private
private extension NetworkManager {
    func mapError(_ error: Publishers.Retry<URLSession.DataTaskPublisher>.Failure) -> ApiError {
        let urlError = error as URLError
        return switch urlError.errorCode {
        case -1009:
            ApiError.noConnection(msg: Errors.noConnection)
        default:
            ApiError.mappingError(msg: Errors.mappingError)
        }
    }

    func handleError(_ error: ApiError) {
        let message: String = switch error {
        case let .noConnection(msg): msg
        case let .mappingError(msg): msg
        default: Texts.Errors.unhandled()
        }
        loadingFailedSubject.send(true)
        errorMessageSubject.send(message)
    }

    func handleResponse(
        _ value: (data: Data, response: URLResponse),
        _ completion: Action? = nil
    ) {
        guard let response = value.response as? HTTPURLResponse,
              let model = try? JSONDecoder().decode(CommonInfo.self, from: value.data)
        else { return }

        let statusCode = response.statusCode

        switch statusCode {
        case HttpStatusCodes.ok.rawValue:
            newsArraySubject.send(model.articles.orEmpty)
            loadingSucceededSubject.send(true)

        default:
            errorMessageSubject.send((HttpStatusCodes(rawValue: statusCode)?.message).orEmpty)
            loadingFailedSubject.send(true)
        }

        completion??()
    }
}
