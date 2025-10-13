//
//  MainView.swift
//  News
//
//  Created by Ярослав Куприянов on 04.10.2025.
//

import Foundation
import SwiftUI

struct FavoritesView: View {
    @StateObject var viewModel: FavoritesViewModel
    
    var body: some View {
        content
    }
}

// MARK: - Content
private extension FavoritesView {
    var content: some View {
        FavoritesTopicsList(viewModel: viewModel)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    DesignedText(text: Texts.Favorites.Screen.title())
                        .font(.title)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    NavButton(
                        type: .removeFavorites(hasFavorites: viewModel.hasFavorites),
                        action: { viewModel.removeFavorites() }
                    )
                }
            }
            .navigationBarTitleDisplayMode(.inline)
    }
}
