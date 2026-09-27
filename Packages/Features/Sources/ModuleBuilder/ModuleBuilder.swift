import Foundation
import SwiftUI
import CoreKit
import DesignSystem

@MainActor
public struct ModuleBuilder {
    public static let shared = ModuleBuilder()

    private let soundManager: SoundManagerProtocol = SoundManager()
    private let vibrateManager: VibrateManagerProtocol = VibrateManager()
    private let notificationManager: NotificationManagerProtocol = NotificationManager()
    private let cacheManager: CacheManagerProtocol = CacheManager()
    private let settingsManager: SettingsManagerProtocol = SettingsManager()
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    private let widgetsManager: WidgetsManagerProtocol = WidgetsManager()

    @ViewBuilder
    public func build(_ module: Module) -> some View {
        switch module {
        case .main:
            let viewModel = MainViewModel(
                soundManager: soundManager,
                vibrateManager: vibrateManager,
                notificationManager: notificationManager,
                settingsManager: settingsManager,
                networkManager: networkManager,
                widgetsManager: widgetsManager
            )
            MainView(viewModel: viewModel)

        case .details(let article):
            let viewModel = DetailsViewModel(
                cacheManager: cacheManager,
                settingsManager: settingsManager,
                vibrateManager: vibrateManager,
                widgetsManager: widgetsManager
            )
            DetailsView(viewModel: viewModel, article: article)

        case .settings:
            let viewModel = SettingsViewModel(
                soundManager: soundManager,
                vibrateManager: vibrateManager,
                notificationManager: notificationManager,
                settingsManager: settingsManager,
                networkManager: networkManager
            )
            SettingsView(viewModel: viewModel)

        case .favorites:
            let viewModel = FavoritesViewModel(
                settingsManager: settingsManager
            )
            FavoritesView(viewModel: viewModel)
        }
    }
}
