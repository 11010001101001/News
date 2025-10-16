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
	static let padding: CGFloat = 16
	static let cornerRadius: CGFloat = 26
	static let imageHeight: CGFloat = 300
    static let detailsButtonsSpacing: CGFloat = 8
    static let gradientHeight: CGFloat = 100

	enum DefaultSettings {
		static let category = NewsCategory.business.rawValue
		static let soundTheme = SoundTheme.silentMode.rawValue
		static let loader = LoaderConfiguration.hourGlass.rawValue
		static let appIcon = AppIconConfiguration.globe.rawValue
	}
}
