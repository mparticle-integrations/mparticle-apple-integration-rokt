//
//  MPRoktLayout.swift
//  mParticle-Rokt
//
//  Copyright 2025 Rokt Pte Ltd
//
//  Licensed under the Rokt Software Development Kit (SDK) Terms of Use
//  Version 2.0 (the "License");
//
//  You may not use this file except in compliance with the License.
//
//  You may obtain a copy of the License at https://rokt.com/sdk-license-2-0/

import SwiftUI
import Rokt_Widget
#if canImport(mParticle_Apple_SDK_NoLocation)
import mParticle_Apple_SDK_NoLocation
import mParticle_Rokt_NoLocation
#else
import mParticle_Apple_SDK
import mParticle_Rokt
#endif

@available(iOS 15, *)
public class MPRoktLayout {
    public var roktLayout: RoktLayout? = nil
    let mparticle = MParticle.sharedInstance()

    public init(
        sdkTriggered: Binding<Bool>,
        viewName: String? = nil,
        locationName: String = "",
        attributes: [String: String],
        config: RoktConfig? = nil,
        onEvent: ((RoktEvent) -> Void)? = nil
    ) {
        confirmUser(attributes: attributes) {
            let preparedAttributes = MPKitRokt.prepareAttributes(attributes, filteredUser: Optional<FilteredMParticleUser>.none, performMapping: true)

            self.roktLayout = RoktLayout.init(
                sdkTriggered: sdkTriggered,
                viewName: viewName,
                locationName: locationName,
                attributes: preparedAttributes,
                config: config,
                onEvent: onEvent
            )
        }
    }
    
    func confirmUser(
        attributes: [String: String]?,
        completion: @escaping () -> Void
    ) {
        guard let user = mparticle.identity.currentUser else {
            completion()
            return
        }
        let email = attributes?["email"]
        let hashedEmail = attributes?["emailsha256"]
        let hashedEmailIdentity = MPKitRokt.getHashedEmailUserIdentityType()
        
        let userEmailIdentity = user.identities[NSNumber(value: MPIdentity.email.rawValue)]
        
        let emailMismatch: Bool = {
            guard let email = email,
                  let userEmail = user.identities[NSNumber(value: MPIdentity.email.rawValue)] else {
                return false
            }
            return email != userEmail
        }()
        let hashedEmailMismatch: Bool = {
            guard let hashedEmail = hashedEmail,
                  let hashedEmailIdentity = hashedEmailIdentity,
                  let userHashedEmail = user.identities[hashedEmailIdentity] else {
                return false
            }
            return hashedEmail != userHashedEmail
        }()
        
        if emailMismatch || hashedEmailMismatch {
            // If there is an existing email or hashed email but it doesn't match what was passed in, warn the customer
            if emailMismatch {
                print("The existing email on the user (\(userEmailIdentity ?? "nil")) does not match the email passed in to `selectPlacements:` (\(email ?? "nil")). Please remember to sync the email identity to mParticle as soon as you receive it. We will now identify the user before creating the layout")
            }
            if hashedEmailMismatch {
                print("The existing hashed email on the user (\(user.identities[hashedEmailIdentity ?? NSNumber(value: -1)] ?? "nil")) does not match the email passed in to `selectPlacements:` (\(hashedEmail ?? "nil")). Please remember to sync the hashed email identity to mParticle as soon as you receive it. We will now identify the user before creating the layout")
            }
            
            syncIdentities(user: user, email: email, hashedEmail: hashedEmail, hashedEmailKey: hashedEmailIdentity, completion: completion)
        } else {
            completion()
        }
    }
    
    func syncIdentities(
        user: MParticleUser,
        email: String?,
        hashedEmail: String?,
        hashedEmailKey: NSNumber?,
        completion: @escaping () -> Void
    ) {
        let identityRequest = MPIdentityApiRequest(user: user)
        identityRequest.setIdentity(email, identityType: .email)
        if let hashedEmailKey = hashedEmailKey {
            identityRequest.setIdentity(hashedEmail, identityType: MPIdentity(rawValue: hashedEmailKey.uintValue) ?? .other)
        }
        
        mparticle.identity.identify(identityRequest) {apiResult, error in
            if let error = error {
                print("Failed to sync email from selectPlacement to user: \(error)")
                completion()
            } else {
                if let identities = apiResult?.user.identities {
                    print("Updated user identity based off selectPlacement's attributes: \(identities)")
                }
                completion()
            }
        }
    }
}
