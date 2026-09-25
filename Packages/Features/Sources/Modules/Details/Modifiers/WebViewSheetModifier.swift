//
//  WebViewSheetModifier.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 11.02.2025.
//

import DesignSystem
import LocalizationKit
import SwiftUI

struct WebViewSheetModifier: ViewModifier {
    @Bindable private var viewModel: DetailsViewModel
    @Binding private var webViewPresented: Bool

    private let webViewModel = WebViewModel()

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
                buildCoverContents()
                    .ignoresSafeArea(.all, edges: .bottom)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
                    .modifier(HideSystemGrabberModifier())
                    .overlay(alignment: .top) {
                        grabber
                            .padding(.top, 6)
                    }
                    .onDisappear {
                        if !webViewPresented {
                            webViewModel.estimatedProgress = 0
                            webViewModel.scrollProgress = 0
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
            .frame(width: 60, height: 5)
            .tint(.white)
            .gloss(color: .white)
            .animation(.smooth, value: webViewModel.estimatedProgress)
            .opacity(webViewModel.estimatedProgress <= 0.85 ? 1 : 0)
    }

    fileprivate var scrollProgressView: some View {
        ProgressView(value: webViewModel.scrollProgress)
            .frame(width: 60, height: 5)
            .tint(.blue)
            .animation(.smooth, value: webViewModel.scrollProgress)
    }

    fileprivate var grabber: some View {
        ZStack {
            scrollProgressView
            estimatedProgressView
        }
        .background(Color.white, in: Capsule())
        .glassEffect(.regular)
    }
}
