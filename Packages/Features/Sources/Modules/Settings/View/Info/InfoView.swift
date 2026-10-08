//
//  InfoView.swift
//  News
//
//  Created by Ярослав Куприянов on 16.11.2024.
//

import Foundation
import SwiftUI
import LocalizationKit
import ModelsKit
import DesignSystem

struct InfoView: View {
    @Bindable var viewModel: SettingsViewModel

    var body: some View {
        ScrollView {
            VerStack(spacing: 30) {
                InfoGrid(viewModel: viewModel)
                HeroCard(entry: viewModel.entry)
            }
            .padding([.horizontal, .bottom])
        }
    }
}
