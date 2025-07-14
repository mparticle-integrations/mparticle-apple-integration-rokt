#import "MPKitRokt.h"
#import <Rokt_Widget/Rokt_Widget-Swift.h>
#import <mParticle_Rokt/mParticle_Rokt-Swift.h>

NSString * const kMPRemoteConfigKitHashesKey = @"hs";
NSString * const kMPRemoteConfigUserAttributeFilter = @"ua";
NSString * const MPKitRoktErrorDomain = @"com.mparticle.kits.rokt";
NSString * const MPKitRoktErrorMessageKey = @"mParticle-Rokt Error";
NSString * const kMPPlacementAttributesMapping = @"placementAttributesMapping";
static __weak MPKitRokt *roktKit = nil;

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
    roktKit = self;
    
    NSString *sdkVersion = [MParticle sharedInstance].version;
    // https://go.mparticle.com/work/SQDSDKS-7379
    NSString *kitVersion = @"8.2.0";

    // Initialize Rokt SDK here
    [Rokt initWithRoktTagId:partnerId mParticleSdkVersion:sdkVersion mParticleKitVersion:kitVersion onInitComplete:^(BOOL InitComplete) {
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

/// \param identifier The name that should be displayed in the widget
///
/// \param attributes A string dictionary containing the parameters that should be displayed in the widget
///
/// \param embeddedViews A dictionary of RoktEmbeddedViews with their names
///
/// \param callbacks Object that contains all possible callbacks for selectPlacements
///
/// \param filteredUser The current user when this placement was requested. Filtered for the kit as per settings in the mParticle UI
///
- (MPKitExecStatus *)executeWithIdentifier:(NSString * _Nullable)identifier
                              attributes:(NSDictionary<NSString *, NSString *> * _Nonnull)attributes
                           embeddedViews:(NSDictionary<NSString *, MPRoktEmbeddedView *> * _Nullable)embeddedViews
                                  config:(MPRoktConfig * _Nullable)mpRoktConfig
                               callbacks:(MPRoktEventCallback * _Nullable)callbacks
                            filteredUser:(FilteredMParticleUser * _Nonnull)filteredUser {
    NSDictionary<NSString *, NSString *> *finalAtt = [MPKitRokt prepareAttributes:attributes filteredUser:filteredUser performMapping:NO];
    
    //Convert MPRoktConfig to RoktConfig
    RoktConfig *roktConfig = [MPKitRokt convertMPRoktConfig:mpRoktConfig];
    
    [Rokt executeWithViewName:identifier
                   attributes:finalAtt
                   placements:[self confirmEmbeddedViews:embeddedViews]
                       config:roktConfig
                       onLoad:callbacks.onLoad
                     onUnLoad:callbacks.onUnLoad
 onShouldShowLoadingIndicator:callbacks.onShouldShowLoadingIndicator
 onShouldHideLoadingIndicator:callbacks.onShouldHideLoadingIndicator
         onEmbeddedSizeChange:callbacks.onEmbeddedSizeChange
    ];
    
    return [[MPKitExecStatus alloc] initWithSDKCode:[[self class] kitCode] returnCode:MPKitReturnCodeSuccess];
}

/// \param wrapperSdk The type of wrapper SDK
///
/// \param wrapperSdkVersion A string representing the wrapper SDK version
///
- (nonnull MPKitExecStatus *)setWrapperSdk:(MPWrapperSdk)wrapperSdk version:(nonnull NSString *)wrapperSdkVersion {
    RoktFrameworkType roktFrameworkType = [self mapMPWrapperSdkToRoktFrameworkType:wrapperSdk];
    [Rokt setFrameworkTypeWithFrameworkType:roktFrameworkType];

    return [[MPKitExecStatus alloc] initWithSDKCode:[[self class] kitCode] returnCode:MPKitReturnCodeSuccess];
}

- (RoktFrameworkType)mapMPWrapperSdkToRoktFrameworkType:(MPWrapperSdk)wrapperSdk {
    switch (wrapperSdk) {
        case MPWrapperSdkCordova:
            return RoktFrameworkTypeCordova;
        case MPWrapperSdkReactNative:
            return RoktFrameworkTypeReactNative;
        case MPWrapperSdkFlutter:
            return RoktFrameworkTypeFlutter;
        default:
            return RoktFrameworkTypeIOS;
    }
}

- (NSDictionary<NSString *, RoktEmbeddedView *> * _Nullable) confirmEmbeddedViews:(NSDictionary<NSString *, MPRoktEmbeddedView *> * _Nullable)embeddedViews {
    NSMutableDictionary <NSString *, RoktEmbeddedView *> *safePlacements = [NSMutableDictionary dictionary];

    for (NSString* key in embeddedViews) {
        MPRoktEmbeddedView *mpView = [embeddedViews objectForKey:key];

        if ([mpView isKindOfClass:MPRoktEmbeddedView.class]) {
            // Create a new RoktEmbeddedView instance
            RoktEmbeddedView *roktView = [[RoktEmbeddedView alloc] initWithFrame:mpView.bounds];
            // Add the RoktEmbeddedView as a child view of MPRoktEmbeddedView
            [mpView addSubview:roktView];
            // Add the RoktEmbeddedView to our safe placements dictionary
            [safePlacements setObject:roktView forKey:key];
        }
    }

    return safePlacements;
}

+ (NSDictionary<NSString *, NSString *> *)confirmSandboxAttribute:(NSDictionary<NSString *, NSString *> * _Nullable)attributes {
    NSMutableDictionary<NSString *, NSString *> *finalAttributes = attributes.mutableCopy;
    NSString *sandboxKey = @"sandbox";
    
    // Determine the value of the sandbox attribute based off the current environment
    NSString *sandboxValue = ([[MParticle sharedInstance] environment] == MPEnvironmentDevelopment) ? @"true" : @"false";
    
    if (finalAttributes != nil) {
        // Only set sandbox if it`s not set by the client
        if (![finalAttributes.allKeys containsObject:sandboxKey]) {
            finalAttributes[sandboxKey] = sandboxValue;
        }
    } else {
        finalAttributes = [[NSMutableDictionary alloc] initWithDictionary:@{sandboxKey: sandboxValue}];
    }
    
    return finalAttributes;
}

+ (NSDictionary<NSString *, NSString *> * _Nonnull)prepareAttributes:(NSDictionary<NSString *, NSString *> * _Nonnull)attributes filteredUser:(FilteredMParticleUser * _Nullable)filteredUser performMapping:(BOOL)performMapping {
    if (filteredUser == nil && roktKit != nil) {
        filteredUser = [[[MPKitAPI alloc] init] getCurrentUserWithKit:roktKit];
    }
    NSDictionary<NSString *, NSString *> *mpAttributes = [filteredUser.userAttributes transformValuesToString];
    if (performMapping) {
        mpAttributes = [self mapAttributes:attributes filteredUser:filteredUser];
    }
    
    NSMutableDictionary<NSString *, NSString *> *finalAtt = [[NSMutableDictionary alloc] init];
    [finalAtt addEntriesFromDictionary:mpAttributes];
    
    // Add MPID to the attributes being passed to the Rokt SDK
    if (filteredUser.userId.stringValue != nil) {
        [finalAtt addEntriesFromDictionary:@{@"mpid": filteredUser.userId.stringValue}];
    }
    
    // Add all known user identities to the attributes being passed to the Rokt SDK
    [self addIdentityAttributes:finalAtt filteredUser:filteredUser];
    
    // The core SDK does not set sandbox on the user, but we must pass it to Rokt if provided
    NSString *sandboxKey = @"sandbox";
    if (attributes[sandboxKey] != nil) {
        [finalAtt addEntriesFromDictionary:@{sandboxKey: attributes[sandboxKey]}];
    }
    
    return [self confirmSandboxAttribute:finalAtt];
}

+ (NSDictionary<NSString *, NSString *> *)mapAttributes:(NSDictionary<NSString *, NSString *> * _Nullable)attributes filteredUser:(FilteredMParticleUser * _Nonnull)filteredUser {
    NSArray<NSDictionary<NSString *, NSString *> *> *attributeMap = nil;
    
    // Get the kit configuration
    NSArray<NSDictionary *> *kitConfigs = [MParticle sharedInstance].kitContainer_PRIVATE.originalConfig.copy;
    NSDictionary *roktKitConfig;
    for (NSDictionary *kitConfig in kitConfigs) {
        if (kitConfig[@"id"] != nil && [kitConfig[@"id"] integerValue] == 181) {
            roktKitConfig = kitConfig;
        }
    }
    
    // Return nil if no Rokt Kit configuration found
    if (!roktKitConfig) {
        return attributes;
    }
    
    // Get the placement attributes map
    NSString *strAttributeMap;
    NSData *dataAttributeMap;
    // Rokt Kit is available though there may not be an attribute map
    attributeMap = @[];
    if (roktKitConfig[kMPPlacementAttributesMapping] != [NSNull null]) {
        strAttributeMap = [roktKitConfig[kMPPlacementAttributesMapping] stringByRemovingPercentEncoding];
        dataAttributeMap = [strAttributeMap dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    if (dataAttributeMap != nil) {
        // Convert it to an array of dictionaries
        NSError *error = nil;
        
        @try {
            attributeMap = [NSJSONSerialization JSONObjectWithData:dataAttributeMap options:kNilOptions error:&error];
        } @catch (NSException *exception) {
        }
        
        if (attributeMap && !error) {
            NSLog(@"%@", attributeMap);
        } else {
            NSLog(@"%@", error);
        }
    }
    
    if (attributeMap) {
        NSMutableDictionary *mappedAttributes = attributes.mutableCopy;
        for (NSDictionary<NSString *, NSString *> *map in attributeMap) {
            NSString *mapFrom = map[@"map"];
            NSString *mapTo = map[@"value"];
            if (mappedAttributes[mapFrom]) {
                NSString * value = mappedAttributes[mapFrom];
                [mappedAttributes removeObjectForKey:mapFrom];
                mappedAttributes[mapTo] = value;
            }
        }
        for (NSString *key in mappedAttributes) {
            if (![key isEqual:@"sandbox"]) {
                [[MParticle sharedInstance].identity.currentUser setUserAttribute:key value:mappedAttributes[key]];
            }
        }
        
        // Add userAttributes to the attributes sent to Rokt
        for (NSString *uaKey in filteredUser.userAttributes) {
            if (![mappedAttributes.allKeys containsObject:uaKey]) {
                mappedAttributes[uaKey] = filteredUser.userAttributes[uaKey];
            }
        }
        
        return [mappedAttributes transformValuesToString];
    } else {
        return attributes;
    }
}

+ (void)addIdentityAttributes:(NSMutableDictionary<NSString *, NSString *> * _Nullable)attributes filteredUser:(FilteredMParticleUser * _Nonnull)filteredUser {
    NSMutableDictionary<NSString *, NSString *> *identityAttributes = [[NSMutableDictionary alloc] init];
    for (NSNumber *identityNumberKey in filteredUser.userIdentities) {
        NSString *identityStringKey = [MPKitRokt stringForIdentityType:identityNumberKey.unsignedIntegerValue];
        [identityAttributes setObject:filteredUser.userIdentities[identityNumberKey] forKey:identityStringKey];
    }
    
    if (attributes != nil) {
        [attributes addEntriesFromDictionary:identityAttributes];
    } else {
        attributes = identityAttributes;
    }
}

+ (RoktConfig *)convertMPRoktConfig:(MPRoktConfig *)mpRoktConfig {
    if (mpRoktConfig != nil) {
        Builder *builder = [[Builder alloc] init];

        if (mpRoktConfig.cacheDuration != nil) {
            CacheConfig *cacheConfig = [[CacheConfig alloc] initWithCacheDuration:mpRoktConfig.cacheDuration.doubleValue cacheAttributes:mpRoktConfig.cacheAttributes];
            builder = [builder cacheConfig:cacheConfig];
        }
        
        builder = [builder colorMode:(ColorMode)mpRoktConfig.colorMode];
        
        RoktConfig *config = [builder build];
        
        return config;
    }
    
    return nil;
}

+ (NSString *)stringForIdentityType:(MPIdentity)identityType {
    switch (identityType) {
        case MPIdentityCustomerId:
            return @"customerid";
            
        case MPIdentityEmail:
            return @"email";
            
        case MPIdentityFacebook:
            return @"facebook";
            
        case MPIdentityFacebookCustomAudienceId:
            return @"facebookcustomaudienceid";
            
        case MPIdentityGoogle:
            return @"google";
            
        case MPIdentityMicrosoft:
            return @"microsoft";
            
        case MPIdentityOther:
            return @"other";
            
        case MPIdentityTwitter:
            return @"twitter";
            
        case MPIdentityYahoo:
            return @"yahoo";
            
        case MPIdentityOther2:
            return @"other2";
            
        case MPIdentityOther3:
            return @"other3";
            
        case MPIdentityOther4:
            return @"other4";
            
        case MPIdentityOther5:
            return @"other5";
            
        case MPIdentityOther6:
            return @"other6";
            
        case MPIdentityOther7:
            return @"other7";
            
        case MPIdentityOther8:
            return @"other8";
            
        case MPIdentityOther9:
            return @"other9";
            
        case MPIdentityOther10:
            return @"other10";
            
        case MPIdentityMobileNumber:
            return @"mobile_number";
            
        case MPIdentityPhoneNumber2:
            return @"phone_number_2";
            
        case MPIdentityPhoneNumber3:
            return @"phone_number_3";
            
        case MPIdentityIOSAdvertiserId:
            return @"ios_idfa";
            
        case MPIdentityIOSVendorId:
            return @"ios_idfv";
            
        case MPIdentityPushToken:
            return @"push_token";
            
        case MPIdentityDeviceApplicationStamp:
            return @"device_application_stamp";
            
        default:
            return nil;
    }
}

- (MPKitExecStatus *)purchaseFinalized:(NSString *)placementId catalogItemId:(NSString *)catalogItemId success:(NSNumber *)success {
    if (placementId != nil && catalogItemId != nil && success != nil) {
        if (@available(iOS 15.0, *)) {
            [Rokt purchaseFinalizedWithPlacementId:placementId catalogItemId:catalogItemId success:success.boolValue];
            return [[MPKitExecStatus alloc] initWithSDKCode:[[self class] kitCode] returnCode:MPKitReturnCodeSuccess];
        }
        return [[MPKitExecStatus alloc] initWithSDKCode:[[self class] kitCode] returnCode:MPKitReturnCodeUnavailable];
    }
    return [[MPKitExecStatus alloc] initWithSDKCode:[[self class] kitCode] returnCode:MPKitReturnCodeFail];
}

- (MPKitExecStatus *)events:(NSString *)identifier onEvent:(void (^)(MPRoktEvent * _Nonnull))onEvent {
    [Rokt eventsWithViewName:identifier onEvent:^(RoktEvent * _Nonnull event) {
        MPRoktEvent *mpEvent = [MPRoktEventMapper mapEvent:event];
        if (mpEvent) {
            onEvent(mpEvent);
        }
    }];
    return [[MPKitExecStatus alloc] initWithSDKCode:[[self class] kitCode] returnCode:MPKitReturnCodeSuccess];
}

- (MPKitExecStatus *)close {
    [Rokt close];
    return [[MPKitExecStatus alloc] initWithSDKCode:[[self class] kitCode] returnCode:MPKitReturnCodeSuccess];
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
