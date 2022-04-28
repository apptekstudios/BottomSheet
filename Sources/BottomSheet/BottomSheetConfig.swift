//
//  BottomSheetConfig.swift
//  BottomSheet
//

import Foundation
import UIKit
import SwiftUI

///   Configuration for bottom sheet behaviour
///   - detents: An array containing all of the possible sizes for the sheet. This array must contain at least one element. When you set this value, specify detents in order from smallest to largest height.
///   - largestUndimmedDetentIdentifier: The largest detent that doesn't dim the view underneath the sheet.
///   - prefersGrabberVisible: A Boolean value that determines whether the sheet shows a grabber at the top.
///   - prefersScrollingExpandsWhenScrolledToEdge: A Boolean value that determines whether scrolling expands the sheet to a larger detent.
///   - prefersEdgeAttachedInCompactHeight: A Boolean value that determines whether the sheet attaches to the bottom edge of the screen in a compact-height size class.
///   - selectedDetentIdentifier: A binding to a identifier of the most recent detent that the user selected or that you set programmatically.
///   - widthFollowsPreferredContentSizeWhenEdgeAttached: A Boolean value that determines whether the sheet's width matches its view controller's preferred content size.
///   - isModalInPresentation: A Boolean value indicating whether the view controller enforces a modal behavior.
///   - onDismiss: The closure to execute when dismissing the sheet.
@available(iOS 15, *)
public struct BottomSheetConfig {
    public var detents: [UISheetPresentationController.Detent]
    public var largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    public var prefersGrabberVisible: Bool
    public var prefersScrollingExpandsWhenScrolledToEdge: Bool
    public var prefersEdgeAttachedInCompactHeight: Bool
    public var selectedDetentBinding: Binding<UISheetPresentationController.Detent.Identifier>?
    public var widthFollowsPreferredContentSizeWhenEdgeAttached: Bool
    public var isModalInPresentation: Bool
    public var onDismiss: (() -> Void)?
    
    public init(
        detents: [UISheetPresentationController.Detent] = [.medium(), .large()],
        largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
        prefersGrabberVisible: Bool = false,
        prefersScrollingExpandsWhenScrolledToEdge: Bool = true,
        prefersEdgeAttachedInCompactHeight: Bool = false,
        selectedDetentBinding: Binding<UISheetPresentationController.Detent.Identifier>? = nil,
        widthFollowsPreferredContentSizeWhenEdgeAttached: Bool = false,
        isModalInPresentation: Bool = false, onDismiss: (() -> Void)? = nil
    ) {
        self.detents = detents
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        self.prefersGrabberVisible = prefersGrabberVisible
        self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        self.selectedDetentBinding = selectedDetentBinding
        self.widthFollowsPreferredContentSizeWhenEdgeAttached = widthFollowsPreferredContentSizeWhenEdgeAttached
        self.isModalInPresentation = isModalInPresentation
        self.onDismiss = onDismiss
    }
    
    public static func builder(_ configure: (inout Self) -> Void) -> Self {
        var config = Self()
        configure(&config)
        return config
    }
    
    internal func sheetPropertiesChanged(from old: BottomSheetConfig) -> Bool {
        detents != old.detents
        || largestUndimmedDetentIdentifier != old.largestUndimmedDetentIdentifier
        || prefersGrabberVisible != old.prefersGrabberVisible
        || prefersScrollingExpandsWhenScrolledToEdge != old.prefersScrollingExpandsWhenScrolledToEdge
        || prefersEdgeAttachedInCompactHeight != old.prefersEdgeAttachedInCompactHeight
        || selectedDetentBinding?.wrappedValue != old.selectedDetentBinding?.wrappedValue
        || widthFollowsPreferredContentSizeWhenEdgeAttached != old.widthFollowsPreferredContentSizeWhenEdgeAttached
        || isModalInPresentation != old.isModalInPresentation
    }
    
}
