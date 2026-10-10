//
//  CategoryCard.swift
//  Features
//
//  Created by Slava on 08.10.2026.
//

import DesignSystem
import Foundation
import ModelsKit
import SwiftUI

struct CategoryCard: View {
    let viewModel: SettingsViewModel
    let category: NewsCategory

    var body: some View {
        VerStack(alignment: .center) {
            Image(systemName: category.image.rawValue)
                .font(.title2)
                .padding(.top, Constants.padding)
            Spacer()
            DesignedText(category.displayName)
                .font(.callout)
                .padding(.bottom, Constants.padding)
        }
        .frame(height: 90)
        .frame(maxWidth: .infinity)
        .markIsSelected(viewModel.category == category)
        .glassClearInteractive()
        .applyOrNotSettingsModifier(
            isEnabled: viewModel.category == category
        ) {
            viewModel.category = category
        }
    }
}
