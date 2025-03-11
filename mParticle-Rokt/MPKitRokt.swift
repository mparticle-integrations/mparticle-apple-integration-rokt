//
// MPKitRoktAlter.swift
// mParticle-Rokt
//
// Created by Danial on 3/11/25.
// Copyright © 2025 mParticle. All rights reserved.
//

import Foundation
import mParticle_Apple_SDK
import Rokt_Widget

/// Error domain for the Rokt kit
public let MPKitRoktAlterErrorDomain = "com.mparticle.kits.rokt"
/// Error message key for the Rokt kit
public let MPKitRoktAlterErrorMessageKey = "mParticle-Rokt Error"

@objc public class MPKitRokt: NSObject, MPKitProtocol {
    // MARK: - Properties
    
    @objc public var configuration: [AnyHashable: Any] = [:]
    @objc public var launchOptions: [AnyHashable: Any]?
    @objc private(set) public var started = false
    
    // MARK: - Class Methods
    
    /**
     mParticle will supply a unique kit code for you. Please contact our team
     */
    @objc public static func kitCode() -> NSNumber {
        return 181 // Replace with the actual kit code assigned by mParticle
    }
    
    @objc public func load() {
        if let kitRegister = MPKitRegister(name: "Rokt", className: "MPKitRokt") {
            MParticle.registerExtension(kitRegister)
        }
    }

    // MARK: - Private Methods
    
    private func execStatus(_ returnCode: MPKitReturnCode) -> MPKitExecStatus {
        return MPKitExecStatus(sdkCode: MPKitRokt.kitCode(), returnCode: returnCode)
    }

    // MARK: - MPKitInstanceProtocol methods
    
    // MARK: Kit instance and lifecycle
    
    @objc public func didFinishLaunching(withConfiguration configuration: [AnyHashable: Any]) -> MPKitExecStatus {
        guard let accountId = configuration["accountId"] as? String else {
            return execStatus(.requirementsNotMet)
        }
        
        self.configuration = configuration
        // Initialize Rokt SDK here
        Rokt.initWith(roktTagId: accountId)
        
        start()
        
        return execStatus(.success)
    }

    public func start() {
        var kitPredicate: Int = 0
        
        DispatchQueue.once(token: &kitPredicate) {
            self.started = true
            
            DispatchQueue.main.async {
                let userInfo = [mParticleKitInstanceKey: MPKitRokt.kitCode()]
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: NSNotification.Name.mParticleKitDidBecomeActive.rawValue),
                                              object: nil,
                                            userInfo: userInfo)
            }
        }
    }

    // MARK: - User attributes and identities
    
    @objc public func setUserIdentity(_ identityString: String?, identityType: MPUserIdentity) -> MPKitExecStatus {
        var execStatus: MPKitExecStatus
        
        if identityType == .email {
            // Set user email in Rokt SDK
            // Rokt.setUserEmail(identityString)
            execStatus = MPKitExecStatus(sdkCode: MPKitRokt.kitCode(), returnCode: .success)
        } else if identityType == .customerId {
            // Set user ID in Rokt SDK
            // Rokt.setUserId(identityString)
            execStatus = MPKitExecStatus(sdkCode: MPKitRokt.kitCode(), returnCode: .success)
        } else {
            execStatus = MPKitExecStatus(sdkCode: MPKitRokt.kitCode(), returnCode: .unavailable)
        }
        
        return execStatus
    }

    // MARK: - Event tracking
    
    @objc public func logEvent(_ event: MPEvent) -> MPKitExecStatus {
        // Track event in Rokt SDK
        // Rokt.trackEvent(event.name)
        
        let execStatus = MPKitExecStatus(sdkCode: MPKitRokt.kitCode(), returnCode: .success)
        return execStatus
    }

    // MARK: Application
    
    /**
     Implement this method if your SDK handles a user interacting with a remote notification action
     */
    @objc public func handleAction(withIdentifier identifier: String?, for userInfo: [AnyHashable: Any]) -> MPKitExecStatus {
        /*  Your code goes here.
            If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
            Please see MPKitExecStatus.h for all exec status codes
         */
        
        return execStatus(.success)
    }

    /**
     Implement this method if your SDK receives and handles remote notifications
     */
    @objc public func receivedUserNotification(_ userInfo: [AnyHashable: Any]) -> MPKitExecStatus {
        /*  Your code goes here.
            If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
            Please see MPKitExecStatus.h for all exec status codes
         */
        
        return execStatus(.success)
    }
    
    /**
     Implement this method if your SDK registers the device token for remote notifications
     */
    @objc public func setDeviceToken(_ deviceToken: Data) -> MPKitExecStatus {
        /*  Your code goes here.
            If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
            Please see MPKitExecStatus.h for all exec status codes
         */
        
        return execStatus(.success)
    }

    /**
     Implement this method if your SDK handles continueUserActivity method from the App Delegate
     */
    @objc public func `continue`(_ userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> MPKitExecStatus {
        /*  Your code goes here.
            If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
            Please see MPKitExecStatus.h for all exec status codes
         */
        
        return execStatus(.success)
    }

    /**
     Implement this method if your SDK handles the iOS 9 and above App Delegate method to open URL with options
     */
    @objc public func open(_ url: URL, options: [String: Any]?) -> MPKitExecStatus {
        /*  Your code goes here.
            If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
            Please see MPKitExecStatus.h for all exec status codes
         */
        
        return execStatus(.success)
    }
    
    /**
     Implement this method if your SDK handles the iOS 8 and below App Delegate method open URL
     */
    @objc public func open(_ url: URL, sourceApplication: String?, annotation: Any?) -> MPKitExecStatus {
        /*  Your code goes here.
            If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
            Please see MPKitExecStatus.h for all exec status codes
         */
        
        return execStatus(.success)
    }

    // MARK: User attributes
    
    /**
     Implement this method if your SDK allows for incrementing numeric user attributes.
     */
    @objc public func onIncrementUserAttribute(_ user: FilteredMParticleUser) -> MPKitExecStatus {
        /*  Your code goes here.
            If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
            Please see MPKitExecStatus.h for all exec status codes
         */
        
        return execStatus(.success)
    }

    /**
     Implement this method if your SDK resets user attributes.
     */
    @objc public func onRemoveUserAttribute(_ user: FilteredMParticleUser) -> MPKitExecStatus {
        /*  Your code goes here.
            If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
            Please see MPKitExecStatus.h for all exec status codes
         */
        
        return execStatus(.success)
    }
    
    /**
     Implement this method if your SDK sets user attributes.
     */
    @objc public func onSetUserAttribute(_ user: FilteredMParticleUser) -> MPKitExecStatus {
        /*  Your code goes here.
            If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
            Please see MPKitExecStatus.h for all exec status codes
         */
        
        return execStatus(.success)
    }
    
    /**
     Implement this method if your SDK supports setting value-less attributes
     */
    @objc public func onSetUserTag(_ user: FilteredMParticleUser) -> MPKitExecStatus {
        /*  Your code goes here.
            If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
            Please see MPKitExecStatus.h for all exec status codes
         */
        
        return execStatus(.success)
    }

    // MARK: Identity
    
    /**
     Implement this method if your SDK should be notified any time the mParticle ID (MPID) changes. This will occur on initial install of the app, and potentially after a login or logout.
     */
    @objc public func onIdentifyComplete(_ user: FilteredMParticleUser, request: FilteredMPIdentityApiRequest) -> MPKitExecStatus {
        /*  Your code goes here.
            If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
            Please see MPKitExecStatus.h for all exec status codes
         */
        
        return execStatus(.success)
    }
    
    /**
     Implement this method if your SDK should be notified when the user logs in
     */
    @objc public func onLoginComplete(_ user: FilteredMParticleUser, request: FilteredMPIdentityApiRequest) -> MPKitExecStatus {
        /*  Your code goes here.
            If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
            Please see MPKitExecStatus.h for all exec status codes
         */
        
        return execStatus(.success)
    }

    /**
     Implement this method if your SDK should be notified when the user logs out
     */
    @objc public func onLogoutComplete(_ user: FilteredMParticleUser, request: FilteredMPIdentityApiRequest) -> MPKitExecStatus {
        /*  Your code goes here.
            If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
            Please see MPKitExecStatus.h for all exec status codes
         */
        
        return execStatus(.success)
    }
    
    /**
     Implement this method if your SDK should be notified when user identities change
     */
    @objc public func onModifyComplete(_ user: FilteredMParticleUser, request: FilteredMPIdentityApiRequest) -> MPKitExecStatus {
        /*  Your code goes here.
            If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
            Please see MPKitExecStatus.h for all exec status codes
         */
        
        return execStatus(.success)
    }

    // MARK: Events
    
    /**
     Implement this method if your SDK wants to log any kind of events.
     Please see MPBaseEvent.h
     */
    @objc public func logBaseEvent(_ event: MPBaseEvent) -> MPKitExecStatus {
        if let event = event as? MPEvent {
            return routeEvent(event)
        } else if let event = event as? MPCommerceEvent {
            return routeCommerceEvent(event)
        } else {
            return execStatus(.unavailable)
        }
    }

    /**
     Implement this method if your SDK logs user events.
     This requires logBaseEvent to be implemented as well.
     Please see MPEvent.h
     */
    @objc public func routeEvent(_ event: MPEvent) -> MPKitExecStatus {
        /*  Your code goes here.
            If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
            Please see MPKitExecStatus.h for all exec status codes
         */
        
        return execStatus(.success)
    }
    
    /**
     Implement this method if your SDK logs screen events
     Please see MPEvent.h
     */
    @objc public func logScreen(_ event: MPEvent) -> MPKitExecStatus {
        /*  Your code goes here.
            If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
            Please see MPKitExecStatus.h for all exec status codes
         */
        
        return execStatus(.success)
    }

    // MARK: e-Commerce
    
    /**
     Implement this method if your SDK supports commerce events.
     This requires logBaseEvent to be implemented as well.
     If your SDK does support commerce event, but does not support all commerce event actions available in the mParticle SDK,
     expand the received commerce event into regular events and log them accordingly (see sample code below)
     Please see MPCommerceEvent.h > MPCommerceEventAction for complete list
     */
    @objc public func routeCommerceEvent(_ commerceEvent: MPCommerceEvent) -> MPKitExecStatus {
        let execStatus = execStatus(.success)

        // In this example, this SDK only supports the Purchase commerce event action
        if commerceEvent.action == .purchase {
            /* Your code goes here. */
            
            execStatus.incrementForwardCount()
        } else { // Other commerce events are expanded and logged as regular events
            let expandedInstructions = commerceEvent.expandedInstructions()
            
            for commerceEventInstruction in expandedInstructions ?? [] {
                routeEvent(commerceEventInstruction.event)
                execStatus.incrementForwardCount()
            }
        }
        
        return execStatus
    }
    
    // MARK: Assorted
    
    /**
     Implement this method if your SDK implements an opt out mechanism for users.
     */
    @objc public func setOptOut(_ optOut: Bool) -> MPKitExecStatus {
        /*  Your code goes here.
            If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
            Please see MPKitExecStatus.h for all exec status codes
         */
        
        return execStatus(.success)
    }
}

// MARK: - Extensions

extension DispatchQueue {
    private static var _onceTracker = [String]()
    
    static func once(token: inout Int, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        token = 1
        block()
    }
}
