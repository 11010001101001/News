//
//  CategoryGrid.swift
//  Features
//
//  Created by Slava on 08.10.2026.
//

import Foundation
import SwiftUI
import DesignSystem
import ModelsKit

struct CategoryGrid: View {
    @Bindable var viewModel: SettingsViewModel

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VerStack(spacing: 30) {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(NewsCategory.allCases) { category in
                        CategoryCard(viewModel: viewModel, category: category)
                    }
                }

                KeywordSection(viewModel: viewModel)
            }
            .padding()
        }
    }
}
