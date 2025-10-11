//
//  SoundManager.swift
//  News
//
//  Created by Ярослав Куприянов on 30.03.2024.
//

import AVKit
import Combine

protocol SoundManagerProtocol {
    func bind(to publisher: AnyPublisher<String, Never>)
}

final class SoundManager {
    private let engine: SoundEngineProtocol = SoundEngine()
    private var cancellables = Set<AnyCancellable>()
}

// MARK: - SoundManagerProtocol
extension SoundManager: SoundManagerProtocol {
    func bind(to publisher: AnyPublisher<String, Never>) {
        publisher
            .sink { [weak self] name in
                self?.engine.play(name)
            }
            .store(in: &cancellables)
    }
}
