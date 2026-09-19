//
//  SoundManager.swift
//  News
//
//  Created by Ярослав Куприянов on 30.03.2024.
//

import AVKit

protocol SoundManagerProtocol: Sendable {
    func play(_ name: String)
}

final class SoundManager: SoundManagerProtocol, Sendable {
    private let engine: SoundEngineProtocol = SoundEngine()

    func play(_ name: String) {
        engine.play(name)
    }
}
