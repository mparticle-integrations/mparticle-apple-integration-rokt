## Rokt Kit Integration

This repository contains the Rokt integration for the [mParticle Apple SDK](https://github.com/mParticle/mparticle-apple-sdk).

### Adding the integration

**NOTE: THESE ARE EXAMPLE INSTRUCTIONS FOR YOUR NEW KIT, THIS EXAMPLE KIT IS NOT MEANT TO BE INCLUDED IN A REAL APPLICATION**

1. Add the kit dependency to your app's Podfile, Cartfile, or SPM:

    ```
    pod 'mParticle-Rokt', '~> 8.0'
    ```

    OR

    ```
    github "mparticle-integrations/mparticle-apple-integration-rokt" ~> 8.0
    ```

2. Follow the mParticle iOS SDK [quick-start](https://github.com/mParticle/mparticle-apple-sdk), then rebuild and launch your app, and verify that you see `"Included kits: { Rokt }"` in your Xcode console 

> (This requires your mParticle log level to be at least Debug)

3. Reference mParticle's integration docs below to enable the integration.

### Documentation

[Rokt integration](https://docs.mparticle.com/integrations/rokt/event/)

### License

[Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0)
