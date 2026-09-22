//
//  SettingsTip.swift
//  News
//
//  Created by Ярослав Куприянов on 11.04.2024.
//

import SwiftUI
import TipKit
import LocalizationKit
import DesignSystem

struct SettingsTip: Tip {
    var title: Text { Text(Strings.tipSettingsTitle) }
    var message: Text? { Text(Strings.tipSettingsMessage) }
    var image: Image? { Image(systemName: SFSymbols.lightbulbMax.rawValue) }
}
