//
//  MainView.swift
//  News
//
//  Created by Ярослав Куприянов on 04.10.2025.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel

    var body: some View {
        content
    }
}

// MARK: - Content
private extension SettingsView {
    var content: some View {
        SettingsList(viewModel: viewModel)
    }
}
