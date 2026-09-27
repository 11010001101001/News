//
//  FavoritesTopicsList.swift
//  News
//
//  Created by Ярослав Куприянов on 13.10.2025.
//

import DesignSystem
import Foundation
import SwiftUI

struct FavoritesTopicsList: View {
    @Bindable var viewModel: FavoritesViewModel

    var body: some View {
        GradientScrollView {
            Group {
                list
                emptyView
            }
            .padding(.top, Constants.padding)
        }
    }
}

// MARK: - Private
extension FavoritesTopicsList {
    fileprivate var list: some View {
        ConditionalView(!viewModel.favoriteTopics.isEmpty) {
            ForEach(viewModel.favoriteTopics, id: \.self) { article in
                ModuleBuilder.shared.build(.details(article.article))
            }
        }
    }

    fileprivate var emptyView: some View {
        ConditionalView(viewModel.favoriteTopics.isEmpty) {
            FavoritesEmptyView()
        }
    }
}
