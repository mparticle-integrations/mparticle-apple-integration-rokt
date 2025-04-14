# Rokt Integration Example App

This example app demonstrates how to integrate and use the mParticle Rokt kit in an iOS application. It shows how to initialize the SDK and display a Rokt embedded view in your app.

## Features

- Initializes the mParticle SDK with the Rokt kit
- Demonstrates how to create and display a Rokt embedded view
- Shows how to pass user attributes to personalize the Rokt experience
- Provides a simple UI to trigger the Rokt layout

## Setup

1. Clone this repository
2. Open `Example.xcodeproj` in Xcode
3. Set your mParticle API key and initialize the SDK in the AppDelegate within the `application:didFinishLaunchingWithOptions:` method:
   ```swift
   // In AppDelegate.swift
   MParticle.sharedInstance().start(with: MParticleOptions(key: "YOUR_API_KEY", secret: "YOUR_API_SECRET"))
   ```
4. Run the app on a simulator or device

## How It Works

The example app consists of two main screens:

1. **Home Screen (`HomeViewController`)**: 
   - Displays a simple UI with a button to launch the Rokt experience
   - Contains basic styling and layout setup

2. **Sample Screen (`SampleViewController`)**:
   - Creates a Rokt embedded view and adds it to the view hierarchy
   - Initializes the Rokt integration with user attributes
   - Demonstrates how to use callbacks for various Rokt widget events (loading, unloading, size changes)

### Code Example

Here's the key integration code from `SampleViewController.swift`:

```swift
MParticle
    .sharedInstance()
    .rokt
    .selectPlacements(
        "RoktEmbeddedExperience",  // View name for the Rokt experience
        attributes: attributes,     // User attributes
        placements: ["RoktEmbedded1": roktEmbeddedView],  // Placement name and view
        onLoad: {
            // Optional callback for when the Rokt placement loads
        },
        onUnLoad: {
            // Optional callback for when the Rokt placement unloads
        },
        onShouldShowLoadingIndicator: {
            // Optional callback to show a loading indicator
        },
        onShouldHideLoadingIndicator: {
            // Optional callback to hide a loading indicator
        },
        onEmbeddedSizeChange: { selectedPlacement, widgetHeight in
            // Optional callback for placement size changes
        }
    )
```

## Requirements

- iOS 12.0+
- Xcode 15.0+
- mParticle iOS SDK
- Rokt Widget SDK

## Notes

- Replace the placeholder mParticle API key and secret with your actual credentials

For more details on the mParticle Rokt integration, refer to the [documentation](https://docs.mparticle.com/integrations/rokt/event/). 