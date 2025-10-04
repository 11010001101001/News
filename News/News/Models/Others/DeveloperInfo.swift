//
//  DeveloperInfo.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Foundation

struct DeveloperInfo {
	static let apiKey = Texts.App.apiKey1()
	static let shareInfo = Texts.Share.info()
	static let contactLink = URL(string: Texts.App.telegram())!
	static var currentAppVersion: String {
		Texts.App.version(
			Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Error in recognizing appVersion"
		)
	}
}
