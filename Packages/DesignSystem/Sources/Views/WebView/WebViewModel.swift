//
//  File.swift
//  DesignSystem
//
//  Created by Slava on 22.09.2026.
//

import Foundation
import WebKit

@Observable
@MainActor
public final class WebViewModel {
    public var url: URL?
    public var loadingState: LoadingStateDesign = .loading
    public var estimatedProgress: Double = .zero
    public var scrollProgress: Double = .zero

    private var progressObservation: NSKeyValueObservation?

    public init(url: URL? = nil) {
        self.url = url
    }

    func bind(to webView: WKWebView) {
        progressObservation?.invalidate()
        progressObservation = webView.observe(\.estimatedProgress, options: [.new]) {
            [weak self] _, change in
            guard let progress = change.newValue else { return }
            Task { @MainActor [weak self] in
                self?.estimatedProgress = progress
            }
        }
    }
}
