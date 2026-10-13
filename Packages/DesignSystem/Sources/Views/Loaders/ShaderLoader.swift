//
//  ShaderLoader.swift
//  News
//
//  Created by Ярослав Куприянов on 31.03.2024.
//

import SwiftUI

public struct ShaderLoader: View {
    private let type: ShaderLoaderType

    @State private var startDate = Date()

    public init(type: ShaderLoaderType) {
        self.type = type
    }

    public var body: some View {
        TimelineView(.animation) { context in
            let time = Float(context.date.timeIntervalSince(startDate))

            Rectangle()
                .fill(Color.indigo.opacity(0.3))
                .visualEffect { content, proxy in
                    content.layerEffect(
                        type.shader(time: time, size: proxy.size),
                        maxSampleOffset: .zero
                    )
                }
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius, style: .continuous))
        }
    }
}
