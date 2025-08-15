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
import mParticle_Apple_SDK
import mParticle_Rokt

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
        
        let userEmailIdentity = user.identities[NSNumber(value: MPIdentity.email.rawValue)]
        let userHashedEmailIdentity = user.identities[NSNumber(value: MPIdentity.other.rawValue)]
        
        let emailMismatch = email != nil && email != userEmailIdentity
        let hashedEmailMismatch = hashedEmail != nil && hashedEmail != userHashedEmailIdentity
        
        if emailMismatch || hashedEmailMismatch {
            // If there is an existing email or hashed email but it doesn't match what was passed in, warn the customer
            if emailMismatch {
                print("The existing email on the user (\(userEmailIdentity ?? "nil")) does not match the email passed in to `selectPlacements:` (\(email ?? "nil")). Please remember to sync the email identity to mParticle as soon as you receive it. We will now identify the user before creating the layout")
            }
            if hashedEmailMismatch {
                print("The existing hashed email on the user (\(userHashedEmailIdentity ?? "nil")) does not match the email passed in to `selectPlacements:` (\(hashedEmail ?? "nil")). Please remember to sync the email identity to mParticle as soon as you receive it. We will now identify the user before creating the layout")
            }
            
            syncIdentities(user: user, email: email, hashedEmail: hashedEmail, completion: completion)
        } else {
            completion()
        }
    }
    
    func syncIdentities(
        user: MParticleUser,
        email: String?,
        hashedEmail: String?,
        completion: @escaping () -> Void
    ) {
        let identityRequest = MPIdentityApiRequest(user: user)
        identityRequest.setIdentity(email, identityType: .email)
        identityRequest.setIdentity(hashedEmail, identityType: .other)
        
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
