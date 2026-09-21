//
//  SettingsTip.swift
//  News
//
//  Created by Ярослав Куприянов on 11.04.2024.
//

import SwiftUI
import TipKit

struct SettingsTip: Tip {
    var title: Text { Text(.tipSettingsTitle) }
    var message: Text? { Text(.tipSettingsMessage) }
    var image: Image? { Image(systemName: SFSymbols.lightbulbMax.rawValue) }
}
