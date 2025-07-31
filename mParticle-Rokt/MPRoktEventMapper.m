#import "MPRoktEventMapper.h"
#import <Rokt_Widget/Rokt_Widget-Swift.h>
#import <mParticle_Apple_SDK/mParticle_Apple_SDK-Swift.h>

@implementation MPRoktEventMapper

+ (MPRoktEvent * _Nullable)mapEvent:(RoktEvent *)event {
    if (!event) {
        return nil;
    }
    
    // Check for RoktEvent.InitComplete
    if ([event isKindOfClass:[RoktEventInitComplete class]]) {
        RoktEventInitComplete *initComplete = (RoktEventInitComplete *)event;
        return [MPRoktEvent MPRoktInitCompleteWithSuccess:initComplete.success];
    }
    
    // Check for RoktEvent.ShowLoadingIndicator
    if ([event isKindOfClass:[RoktEventShowLoadingIndicator class]]) {
        return [MPRoktEvent MPRoktShowLoadingIndicator];
    }
    
    // Check for RoktEvent.HideLoadingIndicator
    if ([event isKindOfClass:[RoktEventHideLoadingIndicator class]]) {
        return [MPRoktEvent MPRoktHideLoadingIndicator];
    }
    
    // Check for RoktEvent.PlacementInteractive
    if ([event isKindOfClass:[RoktEventPlacementInteractive class]]) {
        RoktEventPlacementInteractive *placementInteractive = (RoktEventPlacementInteractive *)event;
        return [MPRoktEvent MPRoktPlacementInteractiveWithPlacementId:placementInteractive.placementId];
    }
    
    // Check for RoktEvent.PlacementReady
    if ([event isKindOfClass:[RoktEventPlacementReady class]]) {
        RoktEventPlacementReady *placementReady = (RoktEventPlacementReady *)event;
        return [MPRoktEvent MPRoktPlacementReadyWithPlacementId:placementReady.placementId];
    }
    
    // Check for RoktEvent.OfferEngagement
    if ([event isKindOfClass:[RoktEventOfferEngagement class]]) {
        RoktEventOfferEngagement *offerEngagement = (RoktEventOfferEngagement *)event;
        return [MPRoktEvent MPRoktOfferEngagementWithPlacementId:offerEngagement.placementId];
    }
    
    // Check for RoktEvent.OpenUrl
    if ([event isKindOfClass:[RoktEventOpenUrl class]]) {
        RoktEventOpenUrl *openUrl = (RoktEventOpenUrl *)event;
        return [MPRoktEvent MPRoktOpenUrlWithPlacementId:openUrl.placementId url:openUrl.url];
    }
    
    // Check for RoktEvent.PositiveEngagement
    if ([event isKindOfClass:[RoktEventPositiveEngagement class]]) {
        RoktEventPositiveEngagement *positiveEngagement = (RoktEventPositiveEngagement *)event;
        return [MPRoktEvent MPRoktPositiveEngagementWithPlacementId:positiveEngagement.placementId];
    }
    
    // Check for RoktEvent.PlacementClosed
    if ([event isKindOfClass:[RoktEventPlacementClosed class]]) {
        RoktEventPlacementClosed *placementClosed = (RoktEventPlacementClosed *)event;
        return [MPRoktEvent MPRoktPlacementClosedWithPlacementId:placementClosed.placementId];
    }
    
    // Check for RoktEvent.PlacementCompleted
    if ([event isKindOfClass:[RoktEventPlacementCompleted class]]) {
        RoktEventPlacementCompleted *placementCompleted = (RoktEventPlacementCompleted *)event;
        return [MPRoktEvent MPRoktPlacementCompletedWithPlacementId:placementCompleted.placementId];
    }
    
    // Check for RoktEvent.PlacementFailure
    if ([event isKindOfClass:[RoktEventPlacementFailure class]]) {
        RoktEventPlacementFailure *placementFailure = (RoktEventPlacementFailure *)event;
        return [MPRoktEvent MPRoktPlacementFailureWithPlacementId:placementFailure.placementId];
    }
    
    // Check for RoktEvent.FirstPositiveEngagement
    if ([event isKindOfClass:[RoktEventFirstPositiveEngagement class]]) {
        RoktEventFirstPositiveEngagement *firstPositiveEngagement = (RoktEventFirstPositiveEngagement *)event;
        return [MPRoktEvent MPRoktFirstPositiveEngagementWithPlacementId:firstPositiveEngagement.placementId];
    }
    
    // Check for RoktEvent.CartItemInstantPurchase
    if ([event isKindOfClass:[RoktEventCartItemInstantPurchase class]]) {
        RoktEventCartItemInstantPurchase *cartItemInstantPurchase = (RoktEventCartItemInstantPurchase *)event;
        
        // Handle nil coalescing for name field
        NSString *name = cartItemInstantPurchase.name ?: @"";
        
        return [MPRoktEvent MPRoktCartItemInstantPurchaseWithPlacementId:cartItemInstantPurchase.placementId
                                                                    name:name
                                                              cartItemId:cartItemInstantPurchase.cartItemId
                                                           catalogItemId:cartItemInstantPurchase.catalogItemId
                                                                currency:cartItemInstantPurchase.currency
                                                             description:cartItemInstantPurchase.description
                                                         linkedProductId:cartItemInstantPurchase.linkedProductId
                                                            providerData:cartItemInstantPurchase.providerData
                                                                quantity:cartItemInstantPurchase.quantity
                                                              totalPrice:cartItemInstantPurchase.totalPrice
                                                               unitPrice:cartItemInstantPurchase.unitPrice];
    }
    
    // Default case - return nil if no matching event type found
    return nil;
}

@end