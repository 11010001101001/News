//
//  ExpertManager.swift
//  AIKit
//
//  Created by Slava on 28.09.2026.
//

import Engine
import Foundation
import LocalizationKit
import ModelsKit

protocol ExpertManagerProtocol: Sendable {
    func generateOpinion(from text: String) async -> Rating
}

actor ExpertManager: ExpertManagerProtocol {
    private let engine = Engine()

    init() {
        engine.loadModel()
    }

    func generateOpinion(from text: String) -> Rating {
        guard !Task.isCancelled else { return .error }

        let systemPrompt = String(localized: Strings.expertPromt)

        let fullPrompt =
            "<|im_start|>system\n" + "\(systemPrompt)\n" + "<|im_end|>\n" + "<|im_start|>user\n"
            + "\(text)\n" + "<|im_end|>\n" + "<|im_start|>assistant\n"

        let result = engine.generate(fullPrompt)

        return Rating.validRatings.first(where: { result.contains($0.rawValue) }) ?? .error
    }
}
