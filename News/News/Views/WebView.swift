//
//  WebView.swift
//  News
//
//  Created by Ярослав Куприянов on 15.04.2024.
//

import Foundation
import WebKit
import SwiftUI
import Combine

final class WebViewModel: ObservableObject {
    @Published var url: URL?
    @Published var loadingState: LoadingState = .loading
    @Published var estimatedProgress: Double = .zero
    @Published var scrollProgress: Double = .zero

    private var cancellables = Set<AnyCancellable>()

    init(url: URL? = nil) {
        self.url = url
    }

    func bind(to webView: WKWebView) {
        cancellables.removeAll()

        webView.publisher(for: \.estimatedProgress)
            .receive(on: RunLoop.main)
            .assign(to: &$estimatedProgress)
    }
}

struct WebView: UIViewRepresentable {
    @ObservedObject var viewModel: WebViewModel

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
    final class WKWebViewCoordinator: NSObject, WKNavigationDelegate, ObservableObject, UIScrollViewDelegate {
        private var viewModel: WebViewModel

        init(viewModel: WebViewModel) {
            self.viewModel = viewModel
            super.init()
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            viewModel.loadingState = .loaded(data: [])
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            viewModel.loadingState = .error(message: error.localizedDescription)
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            viewModel.loadingState = .loaded(data: [])
        }

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
                    DispatchQueue.main.async { [weak self] in
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
                viewModel.scrollProgress = 0
                return
            }
            let ratio = scrollView.contentOffset.y / height
            viewModel.scrollProgress = max(0, min(1, ratio))
        }
    }
}
