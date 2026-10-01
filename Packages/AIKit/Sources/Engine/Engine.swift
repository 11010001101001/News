//
//  AIEngine.swift
//  AIKit
//
//  Created by Slava on 28.09.2026.
//

import Bridge
import Foundation

public class Engine {
    private var llm = AIEngine.LocalLLM()

    private var modelPath: String? {
        Bundle.module.path(forResource: "qwen2.5-1.5b-instruct-q4_k_m", ofType: "gguf")
    }

    public init() {}

    @discardableResult
    public func loadModel() -> Bool {
        guard let modelPath else { return false }
        let cppPath = std.string(modelPath)
        return llm.loadModel(cppPath)
    }

    public func generate(_ promt: String) -> String {
        let cppPromt = std.string(promt)
        let result = llm.generate(cppPromt)
        return String(result)
    }
}
