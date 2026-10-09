//
//  ThermalManager.swift
//  Features
//
//  Created by Slava on 09.10.2026.
//

import Foundation

public protocol ThermalManagerProtocol: Sendable {
    var isOverheated: Bool { get }
}

@Observable
final class ThermalManager: ThermalManagerProtocol, @unchecked Sendable {
    private(set) var isOverheated = false
    private var observerTask: Task<Void, Never>?
    private var cooldownTask: Task<Void, Never>?

    init() {
        checkThermalState()
        setupNotification()
    }

    deinit {
        observerTask?.cancel()
        cooldownTask?.cancel()
    }

    private func setupNotification() {
        observerTask = Task { @MainActor [weak self] in
            let notifications = NotificationCenter.default.notifications(
                named: ProcessInfo.thermalStateDidChangeNotification
            )

            for await _ in notifications {
                self?.checkThermalState()
            }
        }
    }

    private func checkThermalState() {
        let state = ProcessInfo.processInfo.thermalState

        if state == .serious || state == .critical || state == .fair {
            cooldownTask?.cancel()
            cooldownTask = nil
            isOverheated = true
        } else if isOverheated && cooldownTask == nil {
            cooldownTask = Task { @MainActor [weak self] in
                try? await Task.sleep(nanoseconds: 180_000_000_000)
                guard !Task.isCancelled else { return }
                self?.isOverheated = false
                self?.cooldownTask = nil
            }
        }
    }
}
