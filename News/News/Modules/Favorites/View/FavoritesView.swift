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

private extension FavoritesView {
    var content: some View {
        Text("Empty")
    }
}
