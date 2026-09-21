//
//  WebView.swift
//  News
//
//  Created by Ярослав Куприянов on 15.04.2024.
//

import Foundation
import SwiftUI
import WebKit

@Observable
@MainActor
final class WebViewModel {
    var url: URL?
    var loadingState: LoadingState = .loading
    var estimatedProgress: Double = .zero
    var scrollProgress: Double = .zero

    private var progressObservation: NSKeyValueObservation?

    init(url: URL? = nil) {
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

struct WebView: UIViewRepresentable {
    @Bindable var viewModel: WebViewModel

    func makeUIView(context: Context) -> some WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.scrollView.delegate = context.coordinator

        if let url = viewModel.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }

        viewModel.bind(to: webView)
        return webView
    }

    func updateUIView(_ webView: UIViewType, context: UIViewRepresentableContext<WebView>) {
        return
    }

    func makeCoordinator() -> WKWebViewCoordinator {
        WKWebViewCoordinator(viewModel: viewModel)
    }
}

// MARK: Coordinator
extension WebView {
    final class WKWebViewCoordinator: NSObject, WKNavigationDelegate, UIScrollViewDelegate {
        private var viewModel: WebViewModel

        init(viewModel: WebViewModel) {
            self.viewModel = viewModel
            super.init()
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            Task { @MainActor in
                viewModel.loadingState = .loaded(data: [])
            }
        }

        func webView(
            _ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error
        ) {
            Task { @MainActor in
                viewModel.loadingState = .error(message: .init(stringLiteral: error.localizedDescription))
            }
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
        {
            Task { @MainActor in
                viewModel.loadingState = .loaded(data: [])
            }
        }

        func webView(
            _ webView: WKWebView,
            didFailProvisionalNavigation navigation: WKNavigation!,
            withError error: any Error
        ) {
            Task { @MainActor in
                viewModel.loadingState = .error(message: .init(stringLiteral: error.localizedDescription))
            }
        }

        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationResponse: WKNavigationResponse,
            decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
        ) {
            if navigationResponse.isForMainFrame,
                let httpResponse = navigationResponse.response as? HTTPURLResponse
            {
                if httpResponse.statusCode == 403 {
                    Task { @MainActor [weak self] in
                        self?.viewModel.loadingState = .error(message: "Access denied")
                    }
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let height = scrollView.contentSize.height - scrollView.frame.height
            guard height > 0 else {
                Task { @MainActor in
                    viewModel.scrollProgress = 0
                }
                return
            }
            let ratio = scrollView.contentOffset.y / height
            let scrollProgress = max(0, min(1, Double(ratio)))
            Task { @MainActor in
                viewModel.scrollProgress = scrollProgress
            }
        }
    }
}
