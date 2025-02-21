//
//  SoundManager.swift
//  News
//
//  Created by Ярослав Куприянов on 30.03.2024.
//

import AVKit
import Combine

final class SoundManager {
    private var player = AVAudioPlayer()
    private var refreshCancellable: AnyCancellable?
    private var loadedCancellable: AnyCancellable?
    private var errorCancellable: AnyCancellable?

    init(viewModel: ViewModel) {
        player.prepareToPlay()

        func bind() {
            refreshCancellable = viewModel.$refreshSound
                .sink { [weak self] name in
                    self?.playSound(soundFileName: name)
                }

            loadedCancellable = viewModel.$loadedSound
                .sink { [weak self] name in
                    self?.playSound(soundFileName: name)
                }

            errorCancellable = viewModel.$errorSound
                .sink { [weak self] name in
                    self?.playSound(soundFileName: name)
                }
        }

        bind()
    }

    deinit {
        refreshCancellable = nil
        loadedCancellable = nil
        errorCancellable = nil
    }

    func playSound(soundFileName: String) {
        guard !soundFileName.isEmpty,
              let urlPath = Bundle
            .main
            .path(forResource: soundFileName, ofType: "mp3") else { return }
        let url = URL(fileURLWithPath: urlPath)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
        } catch {
            fatalError("Error in playing sound...🙂")
        }
    }
}
