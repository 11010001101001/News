//
//  AppIconGrid.swift
//  Features
//
//  Created by Slava on 08.10.2026.
//

import Foundation
import SwiftUI
import DesignSystem
import ModelsKit

struct AppIconGrid: View {
    @Bindable var viewModel: SettingsViewModel

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(AppIconConfiguration.allCases) { appIcon in
                    AppIconCard(viewModel: viewModel, appIcon: appIcon)
                }
            }
            .padding()
        }
    }
}
