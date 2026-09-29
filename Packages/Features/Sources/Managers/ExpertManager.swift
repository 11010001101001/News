//
//  ExpertManager.swift
//  AIKit
//
//  Created by Slava on 28.09.2026.
//

import AIKit
import Foundation
import LocalizationKit
import ModelsKit

protocol ExpertManagerProtocol: Sendable {
    func generateOpinion(from text: String) async -> Rating
}

actor ExpertManager: ExpertManagerProtocol {
    private let engine = Engine()

    init() {
        Task {
            await loadModel()
        }
    }

    @discardableResult
    public func loadModel() async -> Bool {
        guard
            let modelPath = Bundle.main.path(
                forResource: "qwen2.5-1.5b-instruct-q4_k_m", ofType: "gguf")
        else {
            return false
        }
        return engine.loadModel(path: modelPath)
    }

    func generateOpinion(from text: String) -> Rating {
        let systemPrompt = String(localized: Strings.expertPromt)

        let fullPrompt =
            "<|im_start|>system\n" + "\(systemPrompt)\n" + "<|im_end|>\n" + "<|im_start|>user\n"
            + "\(text)\n" + "<|im_end|>\n" + "<|im_start|>assistant\n"

        let labels = Rating.allCases
        let result = engine.generate(fullPrompt)

        if let label = labels.first(where: { result.contains($0.rawValue) }) {
            return label
        }

        return .loading
    }
}
