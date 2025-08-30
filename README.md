## Rokt Kit Integration

This repository contains the Rokt integration for the [mParticle Apple SDK](https://github.com/mParticle/mparticle-apple-sdk).

### Adding the integration

**NOTE: THESE ARE EXAMPLE INSTRUCTIONS FOR YOUR NEW KIT, THIS EXAMPLE KIT IS NOT MEANT TO BE INCLUDED IN A REAL APPLICATION**

1. Add the kit dependency to your app's `Podfile` or `SPM`:
   

   #### CocoaPods: 
    ```ruby
    pod 'mParticle-Rokt', '~> 8.0'

    # If you'd like to use a version of the mParticle SDK that doesn't include any location tracking
    # nor links the CoreLocation framework, use this pod instead:
    # pod 'mParticle-Rokt/SwiftNoLocation', '~> 8.0'
    ```

    #### Swift Package Manager
    To integrate the SDK using Swift Package Manager, open your Xcode project and click on your project in the file list on the left, then select your Project in the middle of the window. Click on the **Package Dependencies** tab, and press the **"+"** button underneath the list of packages.

    Enter the repository URL `https://github.com/mparticle-integrations/mparticle-apple-integration-rokt` in the search box on the top right, choose `mparticle-apple-integration-rokt` from the list of packages, and set the **Dependency Rule** to *Up to Next Major Version*. Then click the **Add Package** button.

    Finally, choose either the package product `mParticle-Rokt`, or if you'd like to use a version of the SDK that doesn’t include any location tracking nor links the CoreLocation framework, choose `mParticle-Rokt-NoLocation`.

2. Follow the mParticle iOS SDK [quick-start](https://github.com/mParticle/mparticle-apple-sdk), then rebuild and launch your app, and verify that you see `"Included kits: { Rokt }"` in your Xcode console 

> (This requires your mParticle log level to be at least Debug)

3. Reference mParticle's integration docs below to enable the integration.

### Documentation

[Rokt integration](https://docs.mparticle.com/integrations/rokt/event/)

### License

[Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0)
