import Foundation
import SwiftUI
import ModelsKit

@Observable
@MainActor
final class FavoritesViewModel {
    // MARK: Internal variables
    var favoriteTopics: [Article] {
        get { settingsManager.favoriteTopics }
        set { settingsManager.save(favorites: newValue) }
    }

    // MARK: Private variables
    private let settingsManager: SettingsManagerProtocol
    private let motionManager: MotionManagerProtocol

    // MARK: Init
    init(
        settingsManager: SettingsManagerProtocol,
        motionManager: MotionManagerProtocol
    ) {
        self.settingsManager = settingsManager
        self.motionManager = motionManager
    }
}

// MARK: - Public
extension FavoritesViewModel {
    var hasFavorites: Bool {
        !settingsManager.favoriteTopics.isEmpty
    }

    func removeFavorites() {
        favoriteTopics.removeAll()
    }

    func startMotion(completion: @escaping (CGPoint) -> Void) {
        motionManager.start(completion: completion)
    }

    func stopMotion() {
        motionManager.stop()
    }
}
