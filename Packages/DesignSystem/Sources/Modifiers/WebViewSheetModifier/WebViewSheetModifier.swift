//
//  WebViewSheetModifier.swift
//  News
//
//  Created by Yaroslav Kupriyanov on 11.02.2025.
//

import LocalizationKit
import SwiftUI

public struct WebViewSheetModifier: ViewModifier {
    private let loaderName: String
    @Binding private var webViewPresented: Bool

    private let webViewModel = WebViewModel()

    public init(
        loaderName: String,
        webViewPresented: Binding<Bool>,
        url: String
    ) {
        self.loaderName = loaderName
        _webViewPresented = webViewPresented
        webViewModel.url = URL(string: url)
    }

    public func body(content: Content) -> some View {
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
        Loader(name: loaderName)
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
            .animation(.smooth, value: webViewModel.estimatedProgress)
            .opacity(webViewModel.estimatedProgress <= 0.85 ? 1 : 0)
            .shadow(color: webViewModel.estimatedProgress > 0 ? .white : .clear, radius: 2, y: 2)
    }

    fileprivate var scrollProgressView: some View {
        ProgressView(value: webViewModel.scrollProgress)
            .frame(width: 60, height: 5)
            .tint(.blue)
            .animation(.smooth, value: webViewModel.scrollProgress)
            .shadow(color: webViewModel.scrollProgress > 0 ? .blue : .clear, radius: 2, y: 2)
            .sensoryFeedback(trigger: webViewModel.scrollProgress >= 0.98) { _, reached in
                reached ? .impact(flexibility: .solid, intensity: 0.7) : nil
            }
    }

    fileprivate var grabber: some View {
        ZStack {
            scrollProgressView
            estimatedProgressView
        }
        .padding(8)
        .glassEffectClear()
        .scaleEffect(webViewModel.scrollProgress >= 0.98 ? 1.1 : 1)
        .animation(
            .spring(duration: 0.2).repeatCount(1, autoreverses: true),
            value: webViewModel.scrollProgress >= 0.98
        )
    }
}
