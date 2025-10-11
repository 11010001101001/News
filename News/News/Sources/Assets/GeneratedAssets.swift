// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import UIKit

public extension UIImage {
	static var appIcons = UIImage(named: "AppIcons.imageset", in: Bundle(for: BundleToken.self), with: .none)!

	enum Colors {
		public static var accentColor = UIImage(named: "AccentColor.imageset", in: Bundle(for: BundleToken.self), with: .none)!
		public static var rowBackgroundColor = UIImage(named: "RowBackgroundColor.imageset", in: Bundle(for: BundleToken.self), with: .none)!
		public static var shadowHighlightColor = UIImage(named: "ShadowHighlightColor.imageset", in: Bundle(for: BundleToken.self), with: .none)!
	}

	enum Errors {
		public static var errorCat = UIImage(named: "ErrorCat.imageset", in: Bundle(for: BundleToken.self), with: .none)!
	}

	enum Images {
		public static var cat = UIImage(named: "Cat.imageset", in: Bundle(for: BundleToken.self), with: .none)!
		public static var dart = UIImage(named: "Dart.imageset", in: Bundle(for: BundleToken.self), with: .none)!
		public static var globe = UIImage(named: "Globe.imageset", in: Bundle(for: BundleToken.self), with: .none)!
	}

	enum LaunchScreenImages {
		public static var hl3 = UIImage(named: "Hl3.imageset", in: Bundle(for: BundleToken.self), with: .none)!
	}

}
// swiftlint:enable all
private final class BundleToken {}
