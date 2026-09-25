//
//  File.swift
//  Features
//
//  Created by Slava on 25.09.2026.
//

import SwiftUI
import UIKit

struct HideSystemGrabberModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(GrabberHider())
    }
}

private struct GrabberHider: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            if let sheetVC = view.window?.rootViewController?.presentedViewController?
                .presentationController
            {
                if let containerView = sheetVC.containerView {
                    findAndHideGrabber(in: containerView)
                }
            }
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    private func findAndHideGrabber(in view: UIView) {
        let viewName = String(describing: type(of: view))
        if viewName.contains("_UIGrabber") {
            view.layer.filters = nil
            view.layer.opacity = 0.01
            view.layer.sublayers?.forEach { sublayer in
                sublayer.opacity = 0
                sublayer.backgroundColor = nil
                sublayer.filters = nil
            }
            return
        }
        for subview in view.subviews {
            findAndHideGrabber(in: subview)
        }
    }
}
