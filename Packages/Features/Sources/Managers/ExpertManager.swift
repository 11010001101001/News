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
    private let thermalManager: ThermalManagerProtocol

    init(thermalManager: ThermalManagerProtocol) {
        self.thermalManager = thermalManager
        engine.loadModel()
    }

    func generateOpinion(from text: String) -> Rating {
        guard !Task.isCancelled else { return .error }
        guard !thermalManager.isOverheated else { return .cooling }

        let systemPrompt = String(localized: Strings.expertPrompt)

        let fullPrompt =
            "<|im_start|>system\n" + "\(systemPrompt)\n" + "<|im_end|>\n" + "<|im_start|>user\n"
            + "\(text)\n" + "<|im_end|>\n" + "<|im_start|>assistant\n"

        let result = engine.generate(fullPrompt)

        return Rating.validRatings.first(where: { result.contains($0.rawValue) }) ?? .error
    }
}
