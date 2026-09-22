//
//  WebViewSheetModifier.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 11.02.2025.
//

import SwiftUI
import DesignSystem
import LocalizationKit

struct WebViewSheetModifier: ViewModifier {
    @Bindable private var viewModel: DetailsViewModel
    @State var webViewModel = WebViewModel()

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
                    title: Strings.screenMoreTitle,
                ) {
                    VerStack {
                        estimatedProgressView
                        buildCoverContents()
                    }
                    .overlay(alignment: .top) {
                        scrollProgressView
                    }
                }
            }
    }
}

// MARK: - Cover contents
extension WebViewSheetModifier {
    fileprivate func buildCoverContents() -> some View {
        ZStack {
            loader
            webView
            error
        }
    }
}

// MARK: - Views
extension WebViewSheetModifier {
    fileprivate var loader: some View {
        Loader(
            loaderName: viewModel.loader,
            shadowColor: viewModel.loaderShadowColor
        )
        .frame(height: Constants.imageHeight)
        .opacity(webViewModel.loadingState.loaderOpacity)
    }

    fileprivate var webView: some View {
        WebView(viewModel: webViewModel)
            .opacity(webViewModel.loadingState.contentOpacity)
    }

    fileprivate var error: some View {
        ErrorView(title: webViewModel.loadingState.errorMessage, action: nil)
            .frame(height: Constants.imageHeight)
            .opacity(webViewModel.loadingState.errorOpacity)
    }

    fileprivate var estimatedProgressView: some View {
        ProgressView(value: webViewModel.estimatedProgress)
            .scaleEffect(.init(width: 1.0, height: 0.3))
            .tint(.white)
            .offset(y: 1)
            .gloss(color: .white)
            .animation(.smooth, value: webViewModel.estimatedProgress)
            .onChange(of: webViewModel.estimatedProgress) { _, progress in
                guard progress == 1.0 else { return }
                Task {
                    try? await Task.sleep(for: .seconds(0.7))
                    withAnimation {
                        opacity = .leastNonzeroMagnitude
                    }
                }
            }
            .opacity(opacity)
    }

    fileprivate var scrollProgressView: some View {
        ProgressView(value: webViewModel.scrollProgress)
            .scaleEffect(.init(width: 1.0, height: 20))
            .tint(Color.gray.opacity(0.5))
            .offset(y: -40)
            .animation(.smooth, value: webViewModel.scrollProgress)
    }
}
