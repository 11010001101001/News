//
//  ThermalManager.swift
//  Features
//
//  Created by Slava on 09.10.2026.
//

import Foundation

public protocol PowerManagerProtocol: Sendable {
    var isLowPower: Bool { get }
}

@Observable
final class PowerManager: PowerManagerProtocol, @unchecked Sendable {
    private(set) var isLowPower = false
    private var observerTask: Task<Void, Never>?

    init() {
        checkPowerState()
        setupNotification()
    }

    deinit {
        observerTask?.cancel()
    }

    private func setupNotification() {
        observerTask = Task { @MainActor [weak self] in
            let notifications = NotificationCenter.default.notifications(
                named: Notification.Name.NSProcessInfoPowerStateDidChange
            )

            for await _ in notifications {
                self?.checkPowerState()
            }
        }
    }

    private func checkPowerState() {
        isLowPower = ProcessInfo.processInfo.isLowPowerModeEnabled
    }
}
