# BottomSheet

BottomSheet enables use of UISheetPresentationController in SwiftUI with a simple .bottomSheet modifier.

1. [Requirements](#requirements)
2. [Integration](#integration)
3. [Usage](#usage)
    - [Presenting the Sheet](#presenting-the-sheet)
    - [Customizing the Sheet](#customizing-the-sheet)

## Credit
This repository is based off an initial implementation by @adamfootdev, with significant components remaining unchanged.

## Requirements

- iOS 15+
- Xcode 13+

## Integration

### Swift Package Manager

BottomSheet can be added to your app via Swift Package Manager in Xcode using the following configuration:

```swift
dependencies: [
    .package(url: "https://github.com/apptekstudios/BottomSheet.git", from: "1.0")
]
```

## Usage

To get started with BottomSheet, you'll need to import the framework first:

```swift
import BottomSheet
```

### Presenting the Sheet

You can then apply the .bottomSheet modifier to any SwiftUI view, ensuring you attach a binding to the isPresented property - just like the standard .sheet modifier:

```swift
.bottomSheet(isPresented: $isPresented) {
    Text("Hello, world!")
}
```

BottomSheet also supports passing an Optional item to it, displaying the sheet if the item is not nil:

```swift
// Some optional value
@State var item: String? = "Showing Sheet"
// In your view body
.bottomSheet(item: $item) { item in
    Text("\(item)")
}
```

### Customizing the Sheet

BottomSheet can be customized in the same way a UISheetPresentationController can be customized in UIKit. This is done by specifying additional properties in the modifier:

```swift
.bottomSheet(
    isPresented: $isPresented,
    config: .build {
        $0.detents = [.medium(), .large()],
        $0.prefersEdgeAttachedInCompactHeight = true
    },
    onDismiss: { print("Dismissed") }
) {
    Text("Hello, world!")
}
```

For more information on UISheetPresentationController, read Apple's documentation: https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller
