import Foundation
import SwiftUI

final class DetailsViewModel: Observable, ObservableObject {
    @Published var imageCacheData: (image: AnyObject, key: AnyObject)?

    var cacheManager: CacheManager?

    private(set) var loader: String {
        get { savedSettings?.first?.loader ?? LoaderConfiguration.hourGlass.rawValue }
        set { savedSettings?.first?.loader = newValue }
    }

    var loaderShadowColor: Color {
        LoaderConfiguration(rawValue: loader)?.shadowColor ?? .clear
    }

    var savedSettings: [SettingsModel]?
    
    var watchedTopics: [String] {
        get { savedSettings?.first?.watchedTopics ?? [] }
        set { savedSettings?.first?.watchedTopics = newValue }
    }
    
    func checkIsRead(_ key: String) -> Bool {
        watchedTopics.contains(where: { $0 == key })
    }

    func cache(object: AnyObject, key: AnyObject) {
        imageCacheData = (object, key)
    }

    func getCachedImage(key: AnyObject) -> Image? {
        cacheManager?.getCachedImage(key: key)
    }

    func markAsRead(_ key: String) {
        let isViewed = checkIsRead(key)

        guard !isViewed else { return }

        watchedTopics.append(key)
        clearStorageIfNeeded()
    }

    private func clearStorageIfNeeded() {
        guard watchedTopics.count >= Constants.storageCapacity else { return }
        watchedTopics = Array(watchedTopics.dropFirst(Constants.needDropCount))
    }

    init() {
        cacheManager = CacheManager(viewModel: self)
    }

    deinit {
        cacheManager = nil
    }
}
