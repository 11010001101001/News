//
//  WebView.swift
//  News
//
//  Created by Ярослав Куприянов on 15.04.2024.
//

import Foundation
import WebKit
import SwiftUI

final class WebViewModel: ObservableObject {
    @Published var url: URL?
    @Published var loadingState: LoadingState = .loading
    @Published var progress: Double = 0.0

    init(url: URL? = nil) {
        self.url = url
    }
}

struct WebView: UIViewRepresentable {
    @ObservedObject var viewModel: WebViewModel

    private let webView = WKWebView()

    func makeUIView(context: Context) -> some WKWebView {
        webView.navigationDelegate = context.coordinator
        if let url = viewModel.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }

    func updateUIView(_ webView: UIViewType, context: UIViewRepresentableContext<WebView>) {
        return
    }

    func makeCoordinator() -> WKWebViewCoordinator {
        WKWebViewCoordinator(viewModel: viewModel, parent: self)
    }
}

// MARK: Coordinator
extension WebView {
    final class WKWebViewCoordinator: NSObject, WKNavigationDelegate, ObservableObject {
        private var viewModel: WebViewModel
        private let parent: WebView
        private var observer: NSKeyValueObservation?

        init(viewModel: WebViewModel, parent: WebView) {
            self.viewModel = viewModel
            self.parent = parent
            super.init()

            observer = self.parent.webView.observe(\.estimatedProgress) { webView, _ in
                DispatchQueue.main.async {
                    viewModel.progress = webView.estimatedProgress
                }
            }
        }

        deinit {
            observer = nil
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            viewModel.loadingState = .loaded(data: [])
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            viewModel.loadingState = .error(message: error.localizedDescription)
        }

//        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//            viewModel.loadingState = .loading
//                .loaded(data: [])
//        }

        func webView(
            _ webView: WKWebView,
            didFailProvisionalNavigation navigation: WKNavigation!,
            withError error: any Error
        ) {
            viewModel.loadingState = .error(message: error.localizedDescription)
        }

        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationResponse: WKNavigationResponse,
            decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
        ) {
            if navigationResponse.isForMainFrame,
               let httpResponse = navigationResponse.response as? HTTPURLResponse {
                if httpResponse.statusCode == 403 {
                    DispatchQueue.main.async {
                        self.viewModel.loadingState = .error(message: "Access denied")
                    }
                    decisionHandler(.cancel)
                    return
                }
            }
            decisionHandler(.allow)
        }
    }
}
