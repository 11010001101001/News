//
//  ViewModel+Loading.swift
//  News
//
//  Created by Ярослав Куприянов on 28.03.2024.
//

import Foundation
import Combine

// MARK: - Publisher

extension ViewModel {
    // swiftlint:disable line_length
    var newsPublisher: AnyPublisher<(data: Data, response: URLResponse), ApiError> {
        var urlString: String {
            let mode: Mode = keyWord == nil ? .category(category) : .keyword(keyWord ?? .empty)
            return switch mode {
            case .keyword(let keyword):
                "https://newsapi.org/v2/everything?q=\(keyword)&pageSize=\(Constants.newsCount)&language=ru&apiKey=\(DeveloperInfo.apiKey)"
            case .category(let category):
                "https://newsapi.org/v2/top-headlines?country=us&category=\(category)&pageSize=\(Constants.newsCount)&apiKey=\(DeveloperInfo.apiKey)"
            }
        }
        // swiftlint:enable line_length
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.invalidRequest(msg: Errors.invalidUrl))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .retry(3)
            .mapError { [weak self] error in
                self?.mapError(error) ?? ApiError.mappingError(msg: Errors.mappingError)
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - Logic
extension ViewModel {
    func loadNews(
        isRefresh: Bool = false,
        completion: Action = nil
    ) {
        if !isRefresh {
            loadingSucceed = false
            loadingFailed = false
        }

        newsPublisher
            .sink { [weak self] result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self?.handleError(error)
                }
            } receiveValue: { [weak self] value in
                self?.handleResponse(value, completion)
            }
            .store(in: &cancellables)
    }

    func refresh(completion: Action) {
        playRefresh()
        loadNews(isRefresh: true, completion: completion)
    }
}

// MARK: - Private
private extension ViewModel {
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
        let message: String

        switch error {
        case let .noConnection(msg):
            message = msg
        case let .mappingError(msg):
            message = msg
        default:
            message = Texts.Errors.unhandled()
        }
        notificationOccurred(.error)
        playError()
        loadingFailed = true
        failureReason = message
    }

    func handleResponse(
        _ value: (data: Data, response: URLResponse),
        _ completion: Action = nil
    ) {
        guard let response = value.response as? HTTPURLResponse,
              let model = try? JSONDecoder().decode(CommonInfo.self, from: value.data)
        else { return }

        let statusCode = response.statusCode

        switch statusCode {
        case 200:
            notificationOccurred(.success)
            playLoaded()
            loadingSucceed = true
			newsArray = sortIsRead(model.articles)

        default:
            notificationOccurred(.error)
            playError()
            loadingFailed = true
			failureReason = (HttpStatusCodes(rawValue: statusCode)?.message).orEmpty
        }

        completion?()
    }

	func sortIsRead(_ articles: [Article]?) -> [Article] {
		var read = [Article]()
		var notRead = [Article]()

		articles?.forEach {
			guard !$0.title.orEmpty.contains("Removed") else { return }
			let isRead = checkIsRead($0.key)
			if isRead {
				read.append($0)
			} else {
				notRead.append($0)
			}
		}

		return notRead + read
	}
}
