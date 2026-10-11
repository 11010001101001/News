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
    private let powerManager: PowerManagerProtocol
    private var isLoaded = false

    init(
        thermalManager: ThermalManagerProtocol,
        powerManager: PowerManagerProtocol
    ) {
        self.thermalManager = thermalManager
        self.powerManager = powerManager
    }

    func generateOpinion(from text: String) -> Rating {
        guard !Task.isCancelled else { return .error }
        guard !powerManager.isLowPower else { return .lowPower }
        guard !thermalManager.isOverheated else { return .cooling }

        if !isLoaded { isLoaded = engine.loadModel() }
        guard isLoaded else { return .modelNotLoaded }

        let systemPrompt = String(localized: Strings.expertPrompt)

        let fullPrompt =
            "<|im_start|>system\n" + "\(systemPrompt)\n" + "<|im_end|>\n" + "<|im_start|>user\n"
            + "\(text)\n" + "<|im_end|>\n" + "<|im_start|>assistant\n"

        let result = engine.generate(fullPrompt)

        return Rating.validRatings.first(where: { result.contains($0.rawValue) }) ?? .error
    }
}
