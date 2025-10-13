//
//  SFSymbols.swift
//  News
//
//  Created by Ярослав Куприянов on 13.10.2025.
//

import SwiftUI

enum SFSymbols: String {
    case star
    case starFill = "star.fill"

    var image: some View {
        Image(systemName: self.rawValue)
            .tint(.primary)
            .frame(width: 24, height: 24)
    }
}
