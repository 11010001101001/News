//
//  NetworkManager.swift
//  News
//
//  Created by Ярослав Куприянов on 10.10.2025.
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
    var loadingState: AnyPublisher<LoadingState, Never> { get }

    func loadNews(category: String, isRefresh: Bool)
}

final class NetworkManager: ObservableObject {
    var loadingState: AnyPublisher<LoadingState, Never> { loadingStateSubject.eraseToAnyPublisher() }

    private let loadingStateSubject = PassthroughSubject<LoadingState, Never>()
    private var cancellables = Set<AnyCancellable>()
}

// MARK: - NetworkManagerProtocol
extension NetworkManager: NetworkManagerProtocol {
    func loadNews(category: String, isRefresh: Bool) {
        guard let url = URL(string: Mode.category(category).urlString) else { return }

        if !isRefresh { loadingStateSubject.send(.loading) }

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
                self?.handleResponse(value)
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
        loadingStateSubject.send(.error(message: message))
    }

    func handleResponse(_ value: (data: Data, response: URLResponse)) {
        guard let response = value.response as? HTTPURLResponse,
              let model = try? JSONDecoder().decode(CommonInfo.self, from: value.data)
        else { return }

        let statusCode = response.statusCode

        switch statusCode {
        case HttpStatusCodes.ok.rawValue:
            loadingStateSubject.send(.loaded(data: model.articles.orEmpty))

        default:
            let message = (HttpStatusCodes(rawValue: statusCode)?.message).orEmpty
            loadingStateSubject.send(.error(message: message))
        }
    }
}
