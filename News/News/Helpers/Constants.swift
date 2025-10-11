//
//  Constants.swift
//  News
//
//  Created by Ярослав Куприянов on 10.04.2024.
//

import Foundation
import SwiftUI

public enum Constants {
	static let newsCount = "100"
	static let storageCapacity = 500
	static let needDropCount = 250
	static let padding: CGFloat = 16
	static let cornerRadius: CGFloat = 26
	static let imageHeight: CGFloat = 300

	enum DefaultSettings {
		static let category = Category.business.rawValue
		static let soundTheme = SoundTheme.silentMode.rawValue
		static let loader = LoaderConfiguration.hourGlass.rawValue
		static let appIcon = AppIconConfiguration.globe.rawValue
	}
}
