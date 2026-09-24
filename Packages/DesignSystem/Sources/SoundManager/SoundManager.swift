//
//  SoundManager.swift
//  News
//
//  Created by Ярослав Куприянов on 30.03.2024.
//

import AVKit

public protocol SoundManagerProtocol: Sendable {
    func play(_ name: String)
}

public final class SoundManager: SoundManagerProtocol, Sendable {
    private let engine: SoundEngineProtocol = SoundEngine()

    public init() {}

    public func play(_ name: String) {
        engine.play(name)
    }
}
