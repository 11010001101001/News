//
//  DeveloperInfo.swift
//  News
//
//  Created by Ярослав Куприянов on 26.03.2024.
//

import Foundation

struct DeveloperInfo {
    // eb4bc5c32bdd40ca937aa8f94ff2673a
    static let apiKey = "8f825354e7354c71829cfb4cb15c4893"
    static let shareInfo = String(localized: .shareInfo)
    static let contactLink = URL(string: "https://t.me/Yaroslav_Kupriyanov")!
    static var currentAppVersion: String {
        (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String).or("Error in recognizing appVersion")
    }
}
