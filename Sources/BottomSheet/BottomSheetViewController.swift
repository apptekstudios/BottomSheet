//
//  BottomSheetViewController.swift
//  BottomSheet
//

import UIKit
import SwiftUI
import Combine

@available(iOS 15, *)
class BottomSheetViewController<Content: View>: UIViewController, UISheetPresentationControllerDelegate {
    @Binding private var isPresented: Bool

    private var config: BottomSheetConfig
    var onDismiss: () -> Void

    private let contentView: UIHostingController<Content>

    init(
        isPresented: Binding<Bool>,
        config: BottomSheetConfig,
        onDismiss: @escaping () -> Void,
        content: Content
    ) {
        _isPresented = isPresented

        self.config = config
        self.onDismiss = onDismiss
        
        self.contentView = UIHostingController(rootView: content)

        super.init(nibName: nil, bundle: nil)
        self.isModalInPresentation = isModalInPresentation
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(contentView)
        view.addSubview(contentView.view)

        contentView.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.view.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = config.detents
            presentationController.largestUndimmedDetentIdentifier = config.largestUndimmedDetentIdentifier
            presentationController.prefersGrabberVisible = config.prefersGrabberVisible
            presentationController.prefersScrollingExpandsWhenScrolledToEdge = config.prefersScrollingExpandsWhenScrolledToEdge
            presentationController.prefersEdgeAttachedInCompactHeight = config.prefersEdgeAttachedInCompactHeight
            presentationController.selectedDetentIdentifier = config.selectedDetentBinding?.wrappedValue
            presentationController.widthFollowsPreferredContentSizeWhenEdgeAttached = config.widthFollowsPreferredContentSizeWhenEdgeAttached
            presentationController.delegate = self
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        isPresented = false
    }
    
    func update(content: Content, config: BottomSheetConfig) {
        let oldConfig = self.config
        self.config = config
        self.contentView.rootView = content
        if config.sheetPropertiesChanged(from: oldConfig), let presenter = sheetPresentationController {
            presenter.animateChanges {
                presenter.detents = config.detents
                presenter.largestUndimmedDetentIdentifier = config.largestUndimmedDetentIdentifier
                presenter.prefersGrabberVisible = config.prefersGrabberVisible
                presenter.prefersScrollingExpandsWhenScrolledToEdge = config.prefersScrollingExpandsWhenScrolledToEdge
                presenter.prefersEdgeAttachedInCompactHeight = config.prefersEdgeAttachedInCompactHeight
                presenter.selectedDetentIdentifier = config.selectedDetentBinding?.wrappedValue
                presenter.widthFollowsPreferredContentSizeWhenEdgeAttached = config.widthFollowsPreferredContentSizeWhenEdgeAttached
            }
        }
    }
    
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        if let selected = sheetPresentationController.selectedDetentIdentifier {
            config.selectedDetentBinding?.wrappedValue = selected
        }
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        onDismiss()
        config.onDismiss?()
    }
}
