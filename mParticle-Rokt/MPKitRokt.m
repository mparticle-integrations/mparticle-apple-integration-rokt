#import "MPKitRokt.h"
#import <Rokt_Widget/Rokt_Widget-Swift.h>

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
    [Rokt initWithRoktTagId:partnerId];

    [self start];

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
    Whenever remove user attribute is called, this callback will update with the latest attributes in Rokt.
*/
- (MPKitExecStatus *)onRemoveUserAttribute:(FilteredMParticleUser *)user {
    [Rokt setAttributes: [self processAttributesFromUser: user]];
    return [self execStatus:MPKitReturnCodeSuccess];
}

/*
    Whenever set user attribute is called, this callback will update the attributes in Rokt.
*/
- (MPKitExecStatus *)onSetUserAttribute:(FilteredMParticleUser *)user {
    [Rokt setAttributes: [self processAttributesFromUser: user]];
    return [self execStatus:MPKitReturnCodeSuccess];
}

- (MPKitExecStatus *)setUserAttribute:(NSString *)key values:(NSArray *)values {
    [Rokt updateAttributeWithKey:[self prefixKey:key] value:[self mapToString:values]];
    return [self execStatus:MPKitReturnCodeSuccess];
}

- (MPKitExecStatus *)setUserAttribute:(NSString *)key value:(id)value {
    [Rokt updateAttributeWithKey:[self prefixKey:key] value:[self mapToString:value]];
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
    update attributes whenever identify is done
*/
- (MPKitExecStatus *)onIdentifyComplete:(FilteredMParticleUser *)user request:(FilteredMPIdentityApiRequest *)request {
    [Rokt setAttributes: [self processAttributesFromUser: user]];
    return [self execStatus:MPKitReturnCodeSuccess];
}

/*
    Update attributes when the user logs in
*/
- (MPKitExecStatus *)onLoginComplete:(FilteredMParticleUser *)user request:(FilteredMPIdentityApiRequest *)request {
    [Rokt setAttributes: [self processAttributesFromUser: user]];
    return [self execStatus:MPKitReturnCodeSuccess];
}

/*
    Update attributes of logged out identity when the user logs out
*/
- (MPKitExecStatus *)onLogoutComplete:(FilteredMParticleUser *)user request:(FilteredMPIdentityApiRequest *)request {
    [Rokt setAttributes: [self processAttributesFromUser: user]];
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

#pragma mark Helper

- (NSDictionary<NSString *, NSString *> *)processAttributesFromUser:(FilteredMParticleUser *)user  {
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithObject:[user.userId stringValue] forKey:@"mpid"];

    [user.userAttributes enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        NSString *prefixedKey = [self prefixKey:key];
        [mutableDict setObject:[self mapToString:obj] forKey:prefixedKey];
    }];

    return mutableDict;
}

- (NSString *)prefixKey:(NSString *)key {
    return [NSString stringWithFormat:@"mp_%@", key];
}

- (NSString *)mapToString:(id)value {
    if ([NSJSONSerialization isValidJSONObject:value]) {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:value options:0 error:&error];

        if (data && !error) {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (jsonString) {
                return jsonString;
            }
        } else {
            NSLog(@"Rokt: Failed to serialize attribute to JSON: %@", error);
        }
    }
    // Fallback to description if not a valid JSON object or serialization failed
    return[value description];
}

@end
