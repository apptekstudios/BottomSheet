//
//  BottomSheet.swift
//  BottomSheet
//

import SwiftUI

@available(iOS 15, *)
struct BottomSheetPresenter<T, ContentView: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var itemBinding: T?
    var config: BottomSheetConfig
    var content: (T) -> ContentView
    
    func makeUIViewController(context: Context) -> PresenterController {
        let presenter = PresenterController()
        context.coordinator.presenter = presenter
        return presenter
    }
    
    func updateUIViewController(_ uiViewController: PresenterController, context: Context) {
        context.coordinator.updateState(self)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class PresenterController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            view.isHidden = true
        }
    }
    
    class Coordinator {
        typealias Parent = BottomSheetPresenter<T, ContentView>
        
        var presenter: UIViewController?
        var controller: BottomSheetViewController<ContentView>?
        
        func updateState(_ parent: Parent) {
            if parent.isPresented, let item = parent.itemBinding {
                if let controller = controller, presenter?.presentedViewController == controller {
                    controller.update(content: parent.content(item), config: parent.config)
                } else {
                    let controller = BottomSheetViewController(
                        isPresented: parent.$isPresented,
                        config: parent.config,
                        onDismiss: {
                            parent.isPresented = false
                            parent.config.onDismiss?()
                        },
                        content: parent.content(item)
                    )
                    presenter?.present(controller, animated: true)
                    self.controller = controller
                }
            } else {
                if presenter?.presentedViewController == controller {
                    parent.config.onDismiss?()
                    presenter?.dismiss(animated: true)
                }
                controller = nil
            }
        }
    }
}

@available(iOS 15, *)
extension View {
    
    /// Presents a bottom sheet when the binding to a Boolean value you provide is true. The bottom sheet
    /// can also be customised in the same way as a UISheetPresentationController can be.
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the sheet that you create in the modifier’s content closure.
    ///   - config: Configuration for the sheet (see `BottomSheetConfig` documentation
    ///   - contentView: A closure that returns the content of the sheet.
    public func bottomSheet<ContentView: View>(
        isPresented: Binding<Bool>,
        config: BottomSheetConfig = .init(),
        @ViewBuilder contentView: @escaping () -> ContentView
    ) -> some View {
        self.background(
            BottomSheetPresenter<Void, ContentView>(
                isPresented: isPresented,
                itemBinding: .constant(()),
                config: config,
                content: contentView
            )
        )
    }
    
    /// Presents a bottom sheet when the binding to an Optinal item you pass to it is not nil. The bottom sheet
    /// can also be customised in the same way as a UISheetPresentationController can be.
    /// - Parameters:
    ///   - item: A binding to an Optional item that determines whether to present the sheet that you create in the modifier’s content closure.
    ///   - config: Configuration for the sheet (see `BottomSheetConfig` documentation
    ///   - contentView: A closure that returns the content of the sheet.
    public func bottomSheet<T, ContentView: View>(
        item: Binding<T?>,
        config: BottomSheetConfig = .init(),
        @ViewBuilder contentView: @escaping (T) -> ContentView
    ) -> some View {
        self.background(
            BottomSheetPresenter(
                isPresented: Binding<Bool>(get: { item.wrappedValue != nil }, set: { if !$0 { item.wrappedValue = nil }}),
                itemBinding: item,
                config: config,
                content: contentView
            )
        )
    }
}

