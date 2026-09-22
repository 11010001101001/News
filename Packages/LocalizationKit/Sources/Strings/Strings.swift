import Foundation

public enum Strings {
    // MARK: - General / Dynamic Keys
    public static var accessDenied: LocalizedStringResource {
        LocalizedStringResource("Access denied", bundle: .atURL(Bundle.module.bundleURL))
    }
    // swiftlint:disable identifier_name
    public static var ok: LocalizedStringResource {
        LocalizedStringResource("OK", bundle: .atURL(Bundle.module.bundleURL))
    }
    // swiftlint:enable identifier_name
    public static var separator: LocalizedStringResource {
        LocalizedStringResource(">>", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var userLevel: LocalizedStringResource {
        LocalizedStringResource("lvl:", bundle: .atURL(Bundle.module.bundleURL))
    }

    // MARK: - Actions
    public static var actionsOpen: LocalizedStringResource {
        LocalizedStringResource("Actions.open", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var actionsReload: LocalizedStringResource {
        LocalizedStringResource("Actions.reload", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var actionsShare: LocalizedStringResource {
        LocalizedStringResource("Actions.share", bundle: .atURL(Bundle.module.bundleURL))
    }

    // MARK: - App Info & Icons
    public static var appContactUs: LocalizedStringResource {
        LocalizedStringResource("app.contactUs", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static func appVersion(_ version: String) -> LocalizedStringResource {
        LocalizedStringResource(
            "app.version",
            defaultValue: "App version: \(version)",
            bundle: .atURL(Bundle.module.bundleURL)
        )
    }
    public static var appIconCat: LocalizedStringResource {
        LocalizedStringResource("AppIcon.cat", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var appIconDart: LocalizedStringResource {
        LocalizedStringResource("AppIcon.dart", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var appIconGlobe: LocalizedStringResource {
        LocalizedStringResource("AppIcon.globe", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var appIconTitle: LocalizedStringResource {
        LocalizedStringResource("AppIcon.title", bundle: .atURL(Bundle.module.bundleURL))
    }

    // MARK: - Categories
    public static var categoryBusiness: LocalizedStringResource {
        LocalizedStringResource("Category.business", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var categoryEntertainment: LocalizedStringResource {
        LocalizedStringResource("Category.entertainment", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var categoryGeneral: LocalizedStringResource {
        LocalizedStringResource("Category.general", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var categoryHealth: LocalizedStringResource {
        LocalizedStringResource("Category.health", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var categoryScience: LocalizedStringResource {
        LocalizedStringResource("Category.science", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var categorySports: LocalizedStringResource {
        LocalizedStringResource("Category.sports", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var categoryTechnology: LocalizedStringResource {
        LocalizedStringResource("Category.technology", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var categoryTitle: LocalizedStringResource {
        LocalizedStringResource("Category.title", bundle: .atURL(Bundle.module.bundleURL))
    }

    // MARK: - Context Menu
    public static var contextMenuAddToFavorites: LocalizedStringResource {
        LocalizedStringResource("ContextMenu.addToFavorites", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var contextMenuCopy: LocalizedStringResource {
        LocalizedStringResource("ContextMenu.copy", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var contextMenuMarkAsRead: LocalizedStringResource {
        LocalizedStringResource("ContextMenu.markAsRead", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var contextMenuMarkAsUnread: LocalizedStringResource {
        LocalizedStringResource("ContextMenu.markAsUnread", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var contextMenuRemoveFromFavorites: LocalizedStringResource {
        LocalizedStringResource("ContextMenu.removeFromFavorites", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var contextMenuShare: LocalizedStringResource {
        LocalizedStringResource("ContextMenu.share", bundle: .atURL(Bundle.module.bundleURL))
    }

    // MARK: - Errors
    public static var errorsBadRequest: LocalizedStringResource {
        LocalizedStringResource("errors.badRequest", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var errorsImageLoadingError: LocalizedStringResource {
        LocalizedStringResource("errors.imageLoadingError", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var errorsInvalidUrl: LocalizedStringResource {
        LocalizedStringResource("errors.invalidUrl", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var errorsLoadingFailed: LocalizedStringResource {
        LocalizedStringResource("errors.loadingFailed", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var errorsMapping: LocalizedStringResource {
        LocalizedStringResource("errors.mapping", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var errorsNoConnection: LocalizedStringResource {
        LocalizedStringResource("errors.noConnection", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var errorsResponseError: LocalizedStringResource {
        LocalizedStringResource("errors.responseError", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var errorsServerError: LocalizedStringResource {
        LocalizedStringResource("errors.serverError", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var errorsTimeout: LocalizedStringResource {
        LocalizedStringResource("errors.timeout", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var errorsTooManyRequests: LocalizedStringResource {
        LocalizedStringResource("errors.tooManyRequests", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var errorsTopicLabelNoInfo: LocalizedStringResource {
        LocalizedStringResource("errors.topicLabelNoInfo", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var errorsUnauthorized: LocalizedStringResource {
        LocalizedStringResource("errors.unauthorized", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var errorsUndefinedError: LocalizedStringResource {
        LocalizedStringResource("errors.undefinedError", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var errorsUnhandled: LocalizedStringResource {
        LocalizedStringResource("errors.unhandled", bundle: .atURL(Bundle.module.bundleURL))
    }

    // MARK: - Favorites
    public static var favoritesAdd: LocalizedStringResource {
        LocalizedStringResource("Favorites.add", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var favoritesEmpty: LocalizedStringResource {
        LocalizedStringResource("Favorites.empty", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var favoritesScreenTitle: LocalizedStringResource {
        LocalizedStringResource("Favorites.screen.title", bundle: .atURL(Bundle.module.bundleURL))
    }

    // MARK: - Info & Keyword
    public static var infoTitle: LocalizedStringResource {
        LocalizedStringResource("Info.title", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var keywordPromt: LocalizedStringResource {
        LocalizedStringResource("Keyword.promt", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var keywordTitle: LocalizedStringResource {
        LocalizedStringResource("Keyword.title", bundle: .atURL(Bundle.module.bundleURL))
    }

    // MARK: - Loaders
    public static var loaderAstronaut: LocalizedStringResource {
        LocalizedStringResource("Loader.astronaut", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var loaderHamster: LocalizedStringResource {
        LocalizedStringResource("Loader.hamster", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var loaderHourglass: LocalizedStringResource {
        LocalizedStringResource("Loader.hourglass", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var loaderKitten: LocalizedStringResource {
        LocalizedStringResource("Loader.kitten", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var loaderRocket: LocalizedStringResource {
        LocalizedStringResource("Loader.rocket", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var loaderTitle: LocalizedStringResource {
        LocalizedStringResource("Loader.title", bundle: .atURL(Bundle.module.bundleURL))
    }

    // MARK: - Notifications
    public static var notificationBody: LocalizedStringResource {
        LocalizedStringResource("notification.body", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var notificationTitle: LocalizedStringResource {
        LocalizedStringResource("notification.title", bundle: .atURL(Bundle.module.bundleURL))
    }

    // MARK: - Screens & Settings
    public static var screenDetailsTitle: LocalizedStringResource {
        LocalizedStringResource("screen.details.title", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var screenMoreTitle: LocalizedStringResource {
        LocalizedStringResource("screen.more.title", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var screenSettingsTitle: LocalizedStringResource {
        LocalizedStringResource("screen.settings.title", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var settingsLanguage: LocalizedStringResource {
        LocalizedStringResource("Settings.language", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var settingsSelectLanguage: LocalizedStringResource {
        LocalizedStringResource("Settings.selectLanguage", bundle: .atURL(Bundle.module.bundleURL))
    }

    // MARK: - Share
    public static var shareInfo: LocalizedStringResource {
        LocalizedStringResource("share.info", bundle: .atURL(Bundle.module.bundleURL))
    }

    // MARK: - Sounds
    public static var soundCats: LocalizedStringResource {
        LocalizedStringResource("Sound.cats", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var soundSilentMode: LocalizedStringResource {
        LocalizedStringResource("Sound.silentMode", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var soundStarwars: LocalizedStringResource {
        LocalizedStringResource("Sound.starwars", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var soundTitle: LocalizedStringResource {
        LocalizedStringResource("Sound.title", bundle: .atURL(Bundle.module.bundleURL))
    }

    // MARK: - Misc & Widgets
    public static var stateNoDescription: LocalizedStringResource {
        LocalizedStringResource("state.noDescription", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var tipSettingsMessage: LocalizedStringResource {
        LocalizedStringResource("tip.settings.message", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var tipSettingsTitle: LocalizedStringResource {
        LocalizedStringResource("tip.settings.title", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var widgetsInstuction: LocalizedStringResource {
        LocalizedStringResource("Widgets.instuction", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static var widgetsLevels: LocalizedStringResource {
        LocalizedStringResource("Widgets.levels", bundle: .atURL(Bundle.module.bundleURL))
    }
    public static func widgetsRange(_ range: String) -> LocalizedStringResource {
        LocalizedStringResource(
            "Widgets.range",
            defaultValue: "Range: \(range)",
            bundle: .atURL(Bundle.module.bundleURL)
        )
    }
}
