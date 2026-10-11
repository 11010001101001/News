//
//  SettingsTip.swift
//  News
//
//  Created by Ярослав Куприянов on 11.04.2024.
//

import SwiftUI
import TipKit
import LocalizationKit

public struct SettingsTip: Tip {
    public var title: Text { Text(Strings.tipSettingsTitle) }
    public var message: Text? { Text(Strings.tipSettingsMessage) }
    public var image: Image? { Image(systemName: SFSymbols.lightbulbMax.rawValue) }

    public init() {}
}
