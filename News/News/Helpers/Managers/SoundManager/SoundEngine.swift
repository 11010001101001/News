//
//  SoundEngine.swift
//  News
//
//  Created by Ярослав Куприянов on 29.09.2025.
//

import AVFoundation

protocol SoundEngineProtocol {
    func play(_ name: String)
}

final class SoundEngine {
    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private var buffers: [String: AVAudioPCMBuffer] = [:]

    init() {
        try? AVAudioSession.sharedInstance().setCategory(.ambient, options: .mixWithOthers)
        try? AVAudioSession.sharedInstance().setActive(true)
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: nil)
        try? engine.start()
        loadSounds()
    }
}

// MARK: - Private
private extension SoundEngine {
    func loadSounds() {
        guard let url = Bundle.main.url(forResource: "Sounds", withExtension: nil) else { return }
        if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: nil) {
            for case let fileURL as URL in enumerator where fileURL.pathExtension == "mp3" {
                load(name: fileURL.deletingPathExtension().lastPathComponent)
            }
        }
    }

    func load(name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3"),
              let file = try? AVAudioFile(forReading: url),
              let buffer = AVAudioPCMBuffer(
                pcmFormat: file.processingFormat,
                frameCapacity: AVAudioFrameCount(file.length)
              )
        else { return }

        do {
            try file.read(into: buffer)
            buffers[name] = buffer
        } catch {
            fatalError("Shaize!")
        }
    }
}

// MARK: - SoundEngineProtocol
extension SoundEngine: SoundEngineProtocol {
    func play(_ name: String) {
        guard let buffer = buffers[name] else { return }
        player.play()
        player.scheduleBuffer(buffer, at: nil, options: .interrupts, completionHandler: nil)
    }
}
