//
//  SoundEngine.swift
//  News
//
//  Created by Ярослав Куприянов on 29.09.2025.
//

import AVFoundation

protocol SoundEngineProtocol: Sendable {
    func play(_ name: String)
}

final class SoundEngine: SoundEngineProtocol, @unchecked Sendable {
    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private var buffers: [String: AVAudioPCMBuffer] = [:]

    init() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
        Task.detached(priority: .high) {
            try? AVAudioSession.sharedInstance().setActive(true)
        }

        engine.attach(player)
        prewarm()
    }
}

// MARK: - SoundEngineProtocol
extension SoundEngine {
    func play(_ name: String) {
        guard let buffer = buffers[name] else { return }
        if !engine.isRunning {
            try? engine.start()
        }
        player.stop()
        player.scheduleBuffer(buffer, at: nil, options: .interrupts, completionHandler: nil)
        if !player.isPlaying {
            try? player.playAudio()
        }
    }
}

// MARK: - Private
extension SoundEngine {
    fileprivate func prewarm() {
        if let urls = Bundle.module.urls(forResourcesWithExtension: "mp3", subdirectory: nil) {
            for url in urls {
                load(name: url.deletingPathExtension().lastPathComponent)
            }
        }

        if let firstBuffer = buffers.values.first {
            try? engine.connectNode(player, to: engine.mainMixerNode, format: firstBuffer.format)
            try? engine.start()
        }
    }

    fileprivate func load(name: String) {
        guard let url = Bundle.module.url(forResource: name, withExtension: "mp3"),
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
            print("Failed to read audio buffer for \(name): \(error)")
        }
    }
}
