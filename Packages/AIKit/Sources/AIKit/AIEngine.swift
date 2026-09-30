//
//  AIEngine.swift
//  AIKit
//
//  Created by Slava on 28.09.2026.
//

import AIEngineCpp
import Foundation

public class Engine {
    private var llm = AIEngine.LocalLLM()

    public init() {}

    public func loadModel(path: String) -> Bool {
        let cppPath = std.string(path)
        return llm.loadModel(cppPath)
    }

    public func generate(_ promt: String) -> String {
        let cppPromt = std.string(promt)
        let result = llm.generate(cppPromt)
        return String(result)
    }
}

public extension Engine {
    var defaultModelPath: String? {
        Bundle.module.path(forResource: "qwen2.5-1.5b-instruct-q4_k_m", ofType: "gguf")
    }
}
