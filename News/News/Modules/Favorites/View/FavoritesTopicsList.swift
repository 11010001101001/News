//
//  FavoritesTopicsList.swift
//  News
//
//  Created by Ярослав Куприянов on 13.10.2025.
//

import Foundation
import SwiftUI

struct FavoritesTopicsList: View {
    @ObservedObject var viewModel: FavoritesViewModel

    var body: some View {
        ZStack {
            list
            emptyView
        }
    }
}

// MARK: - Private
private extension FavoritesTopicsList {
    var list: some View {
        ConditionalView(!viewModel.favorites.isEmpty) {
            ScrollView(.vertical) {
                ForEach(viewModel.favorites, id: \.self) { article in
                    ModuleBuilder.shared.build(.details(article.article))
                }
                .padding(.top, Constants.padding)
            }
        }
    }

    var emptyView: some View {
        ConditionalView(viewModel.favorites.isEmpty) {
            FavoritesEmptyView()
            .padding(.horizontal, CGFloat.sideInsets)
        }
    }
}
