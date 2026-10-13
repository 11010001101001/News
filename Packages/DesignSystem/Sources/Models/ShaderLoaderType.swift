//
//  ShaderLoaderType.swift
//  DesignSystem
//
//  Created by Slava on 13.10.2026.
//

import SwiftUI

public enum ShaderLoaderType: CaseIterable, Sendable, Codable, Identifiable {
    public var id: Self { return self }

    public static var tabImage: String { SFSymbols.hourglass.rawValue }

    case singularity
    case quantumOrbit
    case cyberpunkPrisma
    case auroraBorealis
    case holographic
    case matrixRain
    case halfLifeLambda

    public var shadowColor: Color {
        switch self {
        case .singularity: .indigo
        case .quantumOrbit: .yellow
        case .cyberpunkPrisma: .cyan
        case .auroraBorealis: .green
        case .holographic: .white
        case .matrixRain: .green
        case .halfLifeLambda: .orange
        }
    }

    func shader(time: Float, size: CGSize) -> Shader {
        switch self {
        case .singularity:
            ShaderLibrary.designSystem.singularityLoader(.float(time), .float2(size))
        case .quantumOrbit:
            ShaderLibrary.designSystem.quantumOrbitLoader(.float(time), .float2(size))
        case .cyberpunkPrisma:
            ShaderLibrary.designSystem.cyberpunkPrismaLoader(.float(time), .float2(size))
        case .auroraBorealis:
            ShaderLibrary.designSystem.auroraBorealisLoader(.float(time), .float2(size))
        case .holographic:
            ShaderLibrary.designSystem.holographicLoader(.float(time), .float2(size))
        case .matrixRain:
            ShaderLibrary.designSystem.matrixRainLoader(.float(time), .float2(size))
        case .halfLifeLambda:
            ShaderLibrary.designSystem.halfLifeLambdaLoader(.float(time), .float2(size))
        }
    }
}
