import SwiftUI

public enum Images {
    // MARK: - Images
    public static var cat: Image { Image("cat", bundle: .module) }
    public static var dart: Image { Image("dart", bundle: .module) }
    public static var globe: Image { Image("globe", bundle: .module) }

    // MARK: - Errors & Empty States
    public static var errorCat: Image { Image("ErrorCat", bundle: .module) }
    public static var favoritesEmptyCat: Image { Image("FavoritesEmptyCat", bundle: .module) }

    // MARK: - Launch Screen
    public static var hl3: Image { Image("hl3", bundle: .module) }
}
