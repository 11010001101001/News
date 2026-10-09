//
//  ThermalManager.swift
//  Features
//
//  Created by Slava on 09.10.2026.
//

import Foundation

@MainActor
public protocol ThermalManagerProtocol: Sendable {
    var isOverheated: Bool { get }
}

@MainActor
@Observable
final class ThermalManager: ThermalManagerProtocol {
    private(set) var isOverheated = false
    private var observerTask: Task<Void, Never>?

    init() {
        checkThermalState()
        setupNotification()
    }

    isolated deinit {
        observerTask?.cancel()
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
        self.isOverheated = (state == .serious || state == .critical)
    }
}
