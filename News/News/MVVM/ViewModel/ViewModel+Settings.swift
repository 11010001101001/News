//
//  ViewModel+Settings.swift
//  News
//
//  Created by Ярослав Куприянов on 28.03.2024.
//

import Foundation
import UIKit

extension ViewModel {
	private(set) var soundTheme: String {
		get { savedSettings?.first?.soundTheme ?? SoundTheme.silentMode.rawValue }
		set {
			savedSettings?.first?.soundTheme = newValue
			configureNotifications()
		}
	}

	private(set) var category: String {
		get { savedSettings?.first?.category ?? Category.technology.rawValue }
		set { savedSettings?.first?.category = newValue }
	}

	private(set) var loader: String {
		get { savedSettings?.first?.loader ?? LoaderConfiguration.hourGlass.rawValue }
		set { savedSettings?.first?.loader = newValue }
	}

	private(set) var appIcon: String {
		get { savedSettings?.first?.appIcon ?? AppIconConfiguration.globe.rawValue }
		set {
			savedSettings?.first?.appIcon = newValue

			let iconName = AppIconConfiguration.init(rawValue: newValue)?.iconName ?? .empty

			UIApplication.shared.setAlternateIconName(iconName) { error in
				if let error {
					fatalError("File \(newValue): \(error.localizedDescription)")
				}
			}
		}
	}

	var watchedTopics: [String] {
		get { savedSettings?.first?.watchedTopics ?? [] }
		set { savedSettings?.first?.watchedTopics = newValue }
	}

	func applySettings(_ name: String) {
		switch name {
		case let name where Category.allCases.contains(where: { $0.rawValue == name }):
			guard name != category else {
				notificationOccurred(.error)
				return
			}
			category = name
			loadNews()
		case let name where SoundTheme.allCases.contains(where: { $0.rawValue == name }):
			guard name != soundTheme else {
				notificationOccurred(.error)
				return
			}
			soundTheme = name
			notificationOccurred(.success)
		case let name where LoaderConfiguration.allCases.contains(where: { $0.rawValue == name }):
			guard name != loader else {
				notificationOccurred(.error)
				return
			}
			loader = name
			redrawContentViewLoader()
			notificationOccurred(.success)
		case let name where AppIconConfiguration.allCases.contains(where: { $0.rawValue == name }):
			guard name != appIcon else {
				notificationOccurred(.error)
				return
			}
			appIcon = name
			notificationOccurred(.success)
		default:
			break
		}
	}

	func checkIsEnabled(_ settingName: String) -> Bool {
		[
			soundTheme,
			category,
			loader,
			appIcon
		].first(where: { $0 == settingName }) != nil
	}
}

// MARK: - Helpers
extension ViewModel {
	func redrawContentViewLoader() {
		id = Int.random(in: .zero...Int.max)
	}
}
