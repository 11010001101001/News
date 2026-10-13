//
//  ExpertManager.swift
//  AIKit
//
//  Created by Slava on 28.09.2026.
//

@preconcurrency import CoreMotion
import Engine
import Foundation
import LocalizationKit
import ModelsKit

protocol MotionManagerProtocol: Sendable {
    func start(completion: @escaping (CGPoint) -> Void)
    func stop()
}

final class MotionManager: MotionManagerProtocol {
    private let manager = CMMotionManager()

    func start(completion: @escaping (CGPoint) -> Void) {
        guard manager.isDeviceMotionAvailable, !manager.isDeviceMotionActive else { return }

        manager.deviceMotionUpdateInterval = 1.0 / 60
        manager.startDeviceMotionUpdates(to: .main) { motion, _ in
            guard let accel = motion?.gravity else { return }
            completion(.init(x: accel.x, y: accel.y))
        }
    }

    func stop() {
        manager.stopDeviceMotionUpdates()
    }
}
