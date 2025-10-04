//
//  SettingsTip.swift
//  News
//
//  Created by Ярослав Куприянов on 11.04.2024.
//

import SwiftUI
import TipKit

struct SettingsTip: Tip {
    var title: Text {
		Text(Texts.Tip.Settings.title())
    }

    var message: Text? {
		Text(Texts.Tip.Settings.message())
    }

    var image: Image? {
        Image(systemName: "lightbulb.max")
    }
}
