//
//  InfoGrid.swift
//  Features
//
//  Created by Slava on 08.10.2026.
//

import Foundation
import SwiftUI
import DesignSystem
import ModelsKit

struct InfoGrid: View {
    @Bindable var viewModel: SettingsViewModel

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            LanguageCard(viewModel: viewModel)
            ContactCard(viewModel: viewModel)
        }
        .padding(.top)
    }
}
