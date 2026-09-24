//
//  WebView.swift
//  News
//
//  Created by Ярослав Куприянов on 15.04.2024.
//

import Foundation
import SwiftUI
import WebKit

public struct WebView: UIViewRepresentable {
    @Bindable var viewModel: WebViewModel

    public init(viewModel: WebViewModel) {
        self.viewModel = viewModel
    }

    public func makeUIView(context: Context) -> some WKWebView {
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

    public func updateUIView(_ webView: UIViewType, context: UIViewRepresentableContext<WebView>) {
        return
    }

    public func makeCoordinator() -> WKWebViewCoordinator {
        WKWebViewCoordinator(viewModel: viewModel)
    }
}

// MARK: Coordinator
extension WebView {
    public final class WKWebViewCoordinator: NSObject, WKNavigationDelegate, UIScrollViewDelegate {
        private var viewModel: WebViewModel

        init(viewModel: WebViewModel) {
            self.viewModel = viewModel
            super.init()
        }

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            Task { @MainActor in
                viewModel.loadingState = .loaded
            }
        }

        public func webView(
            _ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error
        ) {
            Task { @MainActor in
                viewModel.loadingState = .error(message: .init(stringLiteral: error.localizedDescription))
            }
        }

        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            Task { @MainActor in
                viewModel.loadingState = .loaded
            }
        }

        public func webView(
            _ webView: WKWebView,
            didFailProvisionalNavigation navigation: WKNavigation!,
            withError error: any Error
        ) {
            Task { @MainActor in
                viewModel.loadingState = .error(message: .init(stringLiteral: error.localizedDescription))
            }
        }

        private func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationResponse: WKNavigationResponse,
            decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
        ) {
            if navigationResponse.isForMainFrame,
                let httpResponse = navigationResponse.response as? HTTPURLResponse {
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

        public func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
