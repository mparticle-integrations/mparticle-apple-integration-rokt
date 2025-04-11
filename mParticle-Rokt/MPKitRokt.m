#import "MPKitRokt.h"
#import <Rokt_Widget/Rokt_Widget-Swift.h>

NSString * const kMPRemoteConfigKitHashesKey = @"hs";
NSString * const kMPRemoteConfigUserAttributeFilter = @"ua";
NSString * const MPKitRoktErrorDomain = @"com.mparticle.kits.rokt";
NSString * const MPKitRoktErrorMessageKey = @"mParticle-Rokt Error";

@interface MPKitRokt () <MPKitProtocol>

@property (nonatomic, unsafe_unretained) BOOL started;

@end

@implementation MPKitRokt

/*
    mParticle will supply a unique kit code for you. Please contact our team
*/
+ (NSNumber *)kitCode {
    return @181; // Replace with the actual kit code assigned by mParticle
}

+ (void)load {
    MPKitRegister *kitRegister = [[MPKitRegister alloc] initWithName:@"Rokt" className:@"MPKitRokt"];
    [MParticle registerExtension:kitRegister];
}

- (MPKitExecStatus *)execStatus:(MPKitReturnCode)returnCode {
    return [[MPKitExecStatus alloc] initWithSDKCode:self.class.kitCode returnCode:returnCode];
}

#pragma mark - MPKitInstanceProtocol methods

#pragma mark Kit instance and lifecycle
- (MPKitExecStatus *)didFinishLaunchingWithConfiguration:(NSDictionary *)configuration {
    NSString *partnerId = configuration[@"accountId"];

    if (!partnerId) {
        return [self execStatus:MPKitReturnCodeRequirementsNotMet];
    }

    _configuration = configuration;

    // Initialize Rokt SDK here
    [Rokt initWithRoktTagId:partnerId onInitComplete:^(BOOL InitComplete) {
        if (InitComplete) {
            [self start];
            NSDictionary *userInfo = @{mParticleKitInstanceKey:[[self class] kitCode]};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"mParticle.Rokt.Initialized"
                                                                object:nil
                                                              userInfo:userInfo];
        }
    }];
    
    return [self execStatus:MPKitReturnCodeSuccess];
}

- (void)start {
    static dispatch_once_t kitPredicate;

    dispatch_once(&kitPredicate, ^{
        self->_started = YES;

        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *userInfo = @{mParticleKitInstanceKey:[[self class] kitCode]};

            [[NSNotificationCenter defaultCenter] postNotificationName:mParticleKitDidBecomeActiveNotification
                                                                object:nil
                                                              userInfo:userInfo];
        });
    });
}

/// \param viewName The name that should be displayed in the widget
///
/// \param attributes A string dictionary containing the parameters that should be displayed in the widget
///
/// \param placements A dictionary of RoktEmbeddedViews with their names
///
/// \param onLoad Function to execute right after the widget is successfully loaded and displayed
///
/// \param onUnLoad Function to execute right after widget is unloaded, there is no widget or there is an exception
///
/// \param onShouldShowLoadingIndicator Function to execute when the loading indicator should be shown
///
/// \param onShouldHideLoadingIndicator Function to execute when the loading indicator should be hidden
///
/// \param onEmbeddedSizeChange Function to execute when size of embeddedView change, the first item is selected
/// Placement and second item is widget height
///
- (MPKitExecStatus *)executeWithViewName:(NSString * _Nullable)viewName
                              attributes:(NSDictionary<NSString *, NSString *> * _Nonnull)attributes
                              placements:(NSDictionary<NSString *, RoktEmbeddedView *> * _Nullable)placements
                                  onLoad:(void (^ _Nullable)(void))onLoad
                                onUnLoad:(void (^ _Nullable)(void))onUnLoad
            onShouldShowLoadingIndicator:(void (^ _Nullable)(void))onShouldShowLoadingIndicator
            onShouldHideLoadingIndicator:(void (^ _Nullable)(void))onShouldHideLoadingIndicator
                    onEmbeddedSizeChange:(void (^ _Nullable)(NSString * _Nonnull, CGFloat))onEmbeddedSizeChange
                            filteredUser:(FilteredMParticleUser * _Nonnull)filteredUser {
    NSDictionary<NSString *, NSString *> *mpAttributes = [filteredUser.userAttributes transformValuesToString];
    NSMutableDictionary<NSString *, NSString *> *finalAtt = [[NSMutableDictionary alloc] init];
    [finalAtt addEntriesFromDictionary:mpAttributes];
    if (filteredUser.userId.stringValue != nil) {
        [finalAtt addEntriesFromDictionary:@{@"mpid": filteredUser.userId.stringValue}];
    }
    NSString *sandboxKey = @"sandbox";
    if (attributes[sandboxKey] != nil) {
        [finalAtt addEntriesFromDictionary:@{sandboxKey: attributes[sandboxKey]}];
    }
    
    [Rokt executeWithViewName:viewName
                   attributes:finalAtt
                   placements:[self confirmPlacements:placements]
                       onLoad:onLoad
                     onUnLoad:onUnLoad
 onShouldShowLoadingIndicator:onShouldShowLoadingIndicator
 onShouldHideLoadingIndicator:onShouldHideLoadingIndicator
         onEmbeddedSizeChange:onEmbeddedSizeChange
    ];
    
    return [[MPKitExecStatus alloc] initWithSDKCode:[[self class] kitCode] returnCode:MPKitReturnCodeSuccess];
}

- (NSDictionary<NSString *, RoktEmbeddedView *> * _Nullable) confirmPlacements:(NSDictionary<NSString *, RoktEmbeddedView *> * _Nullable)placements {
    NSMutableDictionary <NSString *, RoktEmbeddedView *> *safePlacements = [NSMutableDictionary dictionary];
    
    for (NSString* key in placements) {
        id value = [placements objectForKey:key];
        
        if ([value isKindOfClass:RoktEmbeddedView.class]) {
            [safePlacements setObject:value forKey:key];
        }
    }
    
    return safePlacements;
}

#pragma mark - User attributes and identities

- (MPKitExecStatus *)setUserIdentity:(NSString *)identityString identityType:(MPUserIdentity)identityType {
    MPKitExecStatus *execStatus = nil;
    
    if (identityType == MPUserIdentityEmail) {
        // Set user email in Rokt SDK
        // [Rokt setUserEmail:identityString];
        execStatus = [[MPKitExecStatus alloc] initWithSDKCode:[[self class] kitCode] returnCode:MPKitReturnCodeSuccess];
    } else if (identityType == MPUserIdentityCustomerId) {
        // Set user ID in Rokt SDK
        // [Rokt setUserId:identityString];
        execStatus = [[MPKitExecStatus alloc] initWithSDKCode:[[self class] kitCode] returnCode:MPKitReturnCodeSuccess];
    } else {
        execStatus = [[MPKitExecStatus alloc] initWithSDKCode:[[self class] kitCode] returnCode:MPKitReturnCodeUnavailable];
    }
    
    return execStatus;
}

#pragma mark - Event tracking

- (MPKitExecStatus *)logEvent:(MPEvent *)event {
    // Track event in Rokt SDK
    // [Rokt trackEvent:event.name];
    
    MPKitExecStatus *execStatus = [[MPKitExecStatus alloc] initWithSDKCode:[[self class] kitCode] returnCode:MPKitReturnCodeSuccess];
    return execStatus;
}

#pragma mark Application
/*
    Implement this method if your SDK handles a user interacting with a remote notification action
*/
 - (MPKitExecStatus *)handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo {
     /*  Your code goes here.
         If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
         Please see MPKitExecStatus.h for all exec status codes
      */

     return [self execStatus:MPKitReturnCodeSuccess];
 }

/*
    Implement this method if your SDK receives and handles remote notifications
*/
 - (MPKitExecStatus *)receivedUserNotification:(NSDictionary *)userInfo {
     /*  Your code goes here.
         If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
         Please see MPKitExecStatus.h for all exec status codes
      */

     return [self execStatus:MPKitReturnCodeSuccess];
 }

/*
    Implement this method if your SDK registers the device token for remote notifications
*/
 - (MPKitExecStatus *)setDeviceToken:(NSData *)deviceToken {
     /*  Your code goes here.
         If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
         Please see MPKitExecStatus.h for all exec status codes
      */

     return [self execStatus:MPKitReturnCodeSuccess];
 }

/*
    Implement this method if your SDK handles continueUserActivity method from the App Delegate
*/
 - (nonnull MPKitExecStatus *)continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(void(^ _Nonnull)(NSArray * _Nullable restorableObjects))restorationHandler {
     /*  Your code goes here.
         If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
         Please see MPKitExecStatus.h for all exec status codes
      */

     return [self execStatus:MPKitReturnCodeSuccess];
 }

/*
    Implement this method if your SDK handles the iOS 9 and above App Delegate method to open URL with options
*/
 - (nonnull MPKitExecStatus *)openURL:(nonnull NSURL *)url options:(nullable NSDictionary<NSString *, id> *)options {
     /*  Your code goes here.
         If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
         Please see MPKitExecStatus.h for all exec status codes
      */

     return [self execStatus:MPKitReturnCodeSuccess];
 }

/*
    Implement this method if your SDK handles the iOS 8 and below App Delegate method open URL
*/
 - (nonnull MPKitExecStatus *)openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nullable id)annotation {
     /*  Your code goes here.
         If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
         Please see MPKitExecStatus.h for all exec status codes
      */

     return [self execStatus:MPKitReturnCodeSuccess];
 }

#pragma mark User attributes
/*
    Implement this method if your SDK allows for incrementing numeric user attributes.
*/
- (MPKitExecStatus *)onIncrementUserAttribute:(FilteredMParticleUser *)user {
     /*  Your code goes here.
         If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
         Please see MPKitExecStatus.h for all exec status codes
      */

     return [self execStatus:MPKitReturnCodeSuccess];
}

/*
    Implement this method if your SDK resets user attributes.
*/
- (MPKitExecStatus *)onRemoveUserAttribute:(FilteredMParticleUser *)user {
     /*  Your code goes here.
         If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
         Please see MPKitExecStatus.h for all exec status codes
      */

     return [self execStatus:MPKitReturnCodeSuccess];
}

/*
    Implement this method if your SDK sets user attributes.
*/
- (MPKitExecStatus *)onSetUserAttribute:(FilteredMParticleUser *)user {
     /*  Your code goes here.
         If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
         Please see MPKitExecStatus.h for all exec status codes
      */

     return [self execStatus:MPKitReturnCodeSuccess];
}

/*
    Implement this method if your SDK supports setting value-less attributes
*/
- (MPKitExecStatus *)onSetUserTag:(FilteredMParticleUser *)user {
     /*  Your code goes here.
         If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
         Please see MPKitExecStatus.h for all exec status codes
      */

     return [self execStatus:MPKitReturnCodeSuccess];
}

#pragma mark Identity
/*
    Implement this method if your SDK should be notified any time the mParticle ID (MPID) changes. This will occur on initial install of the app, and potentially after a login or logout.
*/
- (MPKitExecStatus *)onIdentifyComplete:(FilteredMParticleUser *)user request:(FilteredMPIdentityApiRequest *)request {
     /*  Your code goes here.
         If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
         Please see MPKitExecStatus.h for all exec status codes
      */

     return [self execStatus:MPKitReturnCodeSuccess];
}

/*
    Implement this method if your SDK should be notified when the user logs in
*/
- (MPKitExecStatus *)onLoginComplete:(FilteredMParticleUser *)user request:(FilteredMPIdentityApiRequest *)request {
     /*  Your code goes here.
         If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
         Please see MPKitExecStatus.h for all exec status codes
      */

     return [self execStatus:MPKitReturnCodeSuccess];
}

/*
    Implement this method if your SDK should be notified when the user logs out
*/
- (MPKitExecStatus *)onLogoutComplete:(FilteredMParticleUser *)user request:(FilteredMPIdentityApiRequest *)request {
     /*  Your code goes here.
         If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
         Please see MPKitExecStatus.h for all exec status codes
      */

     return [self execStatus:MPKitReturnCodeSuccess];
}

/*
    Implement this method if your SDK should be notified when user identities change
*/
- (MPKitExecStatus *)onModifyComplete:(FilteredMParticleUser *)user request:(FilteredMPIdentityApiRequest *)request {
     /*  Your code goes here.
         If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
         Please see MPKitExecStatus.h for all exec status codes
      */

     return [self execStatus:MPKitReturnCodeSuccess];
}

#pragma mark Events
/*
    Implement this method if your SDK wants to log any kind of events.
    Please see MPBaseEvent.h
*/
- (nonnull MPKitExecStatus *)logBaseEvent:(nonnull MPBaseEvent *)event {
    if ([event isKindOfClass:[MPEvent class]]) {
        return [self routeEvent:(MPEvent *)event];
    } else if ([event isKindOfClass:[MPCommerceEvent class]]) {
        return [self routeCommerceEvent:(MPCommerceEvent *)event];
    } else {
        return [self execStatus:MPKitReturnCodeUnavailable];
    }
}
/*
    Implement this method if your SDK logs user events.
    This requires logBaseEvent to be implemented as well.
    Please see MPEvent.h
*/
 - (MPKitExecStatus *)routeEvent:(MPEvent *)event {
     /*  Your code goes here.
         If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
         Please see MPKitExecStatus.h for all exec status codes
      */

     return [self execStatus:MPKitReturnCodeSuccess];
 }
/*
    Implement this method if your SDK logs screen events
    Please see MPEvent.h
*/
 - (MPKitExecStatus *)logScreen:(MPEvent *)event {
     /*  Your code goes here.
         If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
         Please see MPKitExecStatus.h for all exec status codes
      */

     return [self execStatus:MPKitReturnCodeSuccess];
 }

#pragma mark e-Commerce
/*
    Implement this method if your SDK supports commerce events.
    This requires logBaseEvent to be implemented as well.
    If your SDK does support commerce event, but does not support all commerce event actions available in the mParticle SDK,
    expand the received commerce event into regular events and log them accordingly (see sample code below)
    Please see MPCommerceEvent.h > MPCommerceEventAction for complete list
*/
 - (MPKitExecStatus *)routeCommerceEvent:(MPCommerceEvent *)commerceEvent {
     MPKitExecStatus *execStatus = [self execStatus:MPKitReturnCodeSuccess];

     // In this example, this SDK only supports the 'Purchase' commerce event action
     if (commerceEvent.action == MPCommerceEventActionPurchase) {
             /* Your code goes here. */

             [execStatus incrementForwardCount];
     } else { // Other commerce events are expanded and logged as regular events
         NSArray *expandedInstructions = [commerceEvent expandedInstructions];

         for (MPCommerceEventInstruction *commerceEventInstruction in expandedInstructions) {
             [self routeEvent:commerceEventInstruction.event];
             [execStatus incrementForwardCount];
         }
     }

     return execStatus;
 }

#pragma mark Assorted
/*
    Implement this method if your SDK implements an opt out mechanism for users.
*/
 - (MPKitExecStatus *)setOptOut:(BOOL)optOut {
     /*  Your code goes here.
         If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
         Please see MPKitExecStatus.h for all exec status codes
      */

     return [self execStatus:MPKitReturnCodeSuccess];
 }

@end
