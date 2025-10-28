//
//  WebViewSheetModifier.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 11.02.2025.
//

import SwiftUI

struct WebViewSheetModifier: ViewModifier {
    @ObservedObject private var viewModel: DetailsViewModel
    @ObservedObject var webViewModel = WebViewModel()

    @Binding private var webViewPresented: Bool
    @State private var opacity = 1.0

    init(
        viewModel: DetailsViewModel,
        webViewPresented: Binding<Bool>,
        url: String
    ) {
        self.viewModel = viewModel
        _webViewPresented = webViewPresented
        webViewModel.url = URL(string: url)
    }

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $webViewPresented) {
                SheetNavigationContainer(
                    title: Texts.Screen.More.title()
                ) {
                    VerStack {
                        progressView
                        buildCoverContents()
                    }
                }
            }
    }
}

// MARK: - Cover contents
private extension WebViewSheetModifier {
    func buildCoverContents() -> some View {
        ZStack {
            loader
            webView
            error
        }
    }
}

// MARK: - Views
private extension WebViewSheetModifier {
    var loader: some View {
        Loader(
            loaderName: viewModel.loader,
            shadowColor: viewModel.loaderShadowColor
        )
        .frame(height: Constants.imageHeight)
        .opacity(webViewModel.loadingState.loaderOpacity)
    }

    var webView: some View {
        WebView(viewModel: webViewModel)
            .opacity(webViewModel.loadingState.contentOpacity)
    }

    var error: some View {
        ErrorView(title: webViewModel.loadingState.errorMessage, action: nil)
            .frame(height: Constants.imageHeight)
            .opacity(webViewModel.loadingState.errorOpacity)
    }

    var progressView: some View {
        ProgressView(value: webViewModel.progress)
            .scaleEffect(.init(width: 1.0, height: 0.3))
            .tint(.white)
            .offset(y: 1)
            .gloss(color: .white)
            .animation(.smooth, value: webViewModel.progress)
            .onChange(of: webViewModel.progress) { _, progress in
                guard progress == 1.0 else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    withAnimation {
                        opacity = .leastNonzeroMagnitude
                    }
                }
            }
            .opacity(opacity)
    }
}
