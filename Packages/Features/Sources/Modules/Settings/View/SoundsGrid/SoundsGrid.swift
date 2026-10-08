//
//  SoundsGrid.swift
//  Features
//
//  Created by Slava on 08.10.2026.
//

import Foundation
import SwiftUI
import ModelsKit
import DesignSystem

struct SoundsGrid: View {
    let viewModel: SettingsViewModel

    private let columns = Array(repeating: GridItem(.flexible()), count: 3)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(SoundTheme.allCases) { sound in
                    SoundCard(viewModel: viewModel, sound: sound)
                }
            }
            .padding()
        }
    }
}
