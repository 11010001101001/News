//
//  Loader.swift
//  News
//
//  Created by Ярослав Куприянов on 31.03.2024.
//

import Lottie
import SwiftUI

public struct Loader: View {
    let name: String

    public init(name: String) {
        self.name = name
    }

    public var body: some View {
        HorStack {
            Spacer()
            LottieView(animation: .named(name, bundle: .designSystem))
                .playing(loopMode: .loop)
                .id(name)
                .scaleEffect(0.70)
                .frame(maxWidth: 170, maxHeight: 170)
            Spacer()
        }
    }
}
