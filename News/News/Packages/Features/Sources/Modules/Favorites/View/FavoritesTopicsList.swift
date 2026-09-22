//
//  FavoritesTopicsList.swift
//  News
//
//  Created by Ярослав Куприянов on 13.10.2025.
//

import Foundation
import SwiftUI
import DesignSystem

struct FavoritesTopicsList: View {
    @Bindable var viewModel: FavoritesViewModel

    var body: some View {
        ZStack {
            list
            emptyView
        }
    }
}

// MARK: - Private
extension FavoritesTopicsList {
    fileprivate var list: some View {
        ConditionalView(!viewModel.favoriteTopics.isEmpty) {
            ScrollView(.vertical) {
                ForEach(viewModel.favoriteTopics, id: \.self) { article in
                    ModuleBuilder.shared.build(.details(article.article))
                }
                .padding(.top, Constants.padding)
            }
        }
    }

    fileprivate var emptyView: some View {
        ConditionalView(viewModel.favoriteTopics.isEmpty) {
            FavoritesEmptyView()
                .padding(.horizontal, CGFloat.sideInsets)
        }
    }
}
