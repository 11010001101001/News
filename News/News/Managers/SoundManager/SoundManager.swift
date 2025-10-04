//
//  SoundManager.swift
//  News
//
//  Created by Ярослав Куприянов on 30.03.2024.
//

import AVKit
import Combine

final class SoundManager {
    private let engine: SoundEngineProtocol
    private var refreshCancellable: AnyCancellable?
    private var errorCancellable: AnyCancellable?

    init(
        viewModel: MainViewModel,
        engine: SoundEngineProtocol = SoundEngine()
    ) {
        self.engine = engine
        
        func bind() {
            refreshCancellable = viewModel.$refreshSound
                .sink { [weak self] name in
                    self?.engine.play(name)
                }

            errorCancellable = viewModel.$errorSound
                .sink { [weak self] name in
                    self?.engine.play(name)
                }
        }

        bind()
    }

    deinit {
        refreshCancellable = nil
        errorCancellable = nil
    }
}
