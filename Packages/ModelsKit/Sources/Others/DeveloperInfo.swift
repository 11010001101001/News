//
//  DeveloperInfo.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Foundation
import LocalizationKit

public struct DeveloperInfo {
    // eb4bc5c32bdd40ca937aa8f94ff2673a
    public static let apiKey = "8f825354e7354c71829cfb4cb15c4893"
    public static let shareInfo = String(localized: Strings.shareInfo)
    public static let contactLink = URL(string: "https://t.me/Yaroslav_Kupriyanov")!
    public static var currentAppVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Error in recognizing appVersion"
    }
}
