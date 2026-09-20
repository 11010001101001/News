//
//  SettingsView.swift
//  News
//
//  Created by Ярослав Куприянов on 04.10.2025.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @State var viewModel: SettingsViewModel

    var body: some View {
        content
    }
}

// MARK: - Content
extension SettingsView {
    fileprivate var content: some View {
        SettingsList(viewModel: viewModel)
    }
}
