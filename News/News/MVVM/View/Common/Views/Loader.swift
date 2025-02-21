//
//  Loader.swift
//  News
//
//  Created by Ярослав Куприянов on 31.03.2024.
//

import SwiftUI
import Lottie
import Combine

struct Loader: View {
    private let loaderName: String
    private let shadowColor: Color

    init(loaderName: String, shadowColor: Color) {
        self.loaderName = loaderName
        self.shadowColor = shadowColor
    }

    var body: some View {
        LottieView(animation: .named(loaderName))
            .playing(loopMode: .loop)
            .scaleEffect(0.30)
			.gloss(color: shadowColor, isBorderHighlighted: true)
    }
}

#Preview {
    Loader(loaderName: "astronaut", shadowColor: .red)
}
