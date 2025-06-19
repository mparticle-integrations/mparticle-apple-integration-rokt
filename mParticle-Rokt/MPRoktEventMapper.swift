import Foundation
import mParticle_Apple_SDK
import Rokt_Widget

/// Utility class for mapping Rokt events to mParticle events
@objc(MPRoktEventMapper)
@objcMembers
public class MPRoktEventMapper: NSObject {

    /// Maps a RoktEvent to the corresponding MPRoktEvent
    /// - Parameter event: The RoktEvent to map
    /// - Returns: The mapped MPRoktEvent, or nil if mapping fails
    @objc(mapEvent:)
    public static func mapEvent(_ event: RoktEvent) -> MPRoktEvent? {
        switch event {
        case let initComplete as RoktEvent.InitComplete:
            return MPRoktEvent.MPRoktInitComplete(success: initComplete.success)
            
        case is RoktEvent.ShowLoadingIndicator:
            return MPRoktEvent.MPRoktShowLoadingIndicator()
            
        case is RoktEvent.HideLoadingIndicator:
            return MPRoktEvent.MPRoktHideLoadingIndicator()
            
        case let placementInteractive as RoktEvent.PlacementInteractive:
            return MPRoktEvent.MPRoktPlacementInteractive(placementId: placementInteractive.placementId)
            
        case let placementReady as RoktEvent.PlacementReady:
            return MPRoktEvent.MPRoktPlacementReady(placementId: placementReady.placementId)
            
        case let offerEngagement as RoktEvent.OfferEngagement:
            return MPRoktEvent.MPRoktOfferEngagement(placementId: offerEngagement.placementId)
            
        case let openUrl as RoktEvent.OpenUrl:
            return MPRoktEvent.MPRoktOpenUrl(placementId: openUrl.placementId, url: openUrl.url)
            
        case let positiveEngagement as RoktEvent.PositiveEngagement:
            return MPRoktEvent.MPRoktPositiveEngagement(placementId: positiveEngagement.placementId)
            
        case let placementClosed as RoktEvent.PlacementClosed:
            return MPRoktEvent.MPRoktPlacementClosed(placementId: placementClosed.placementId)
            
        case let placementCompleted as RoktEvent.PlacementCompleted:
            return MPRoktEvent.MPRoktPlacementCompleted(placementId: placementCompleted.placementId)
            
        case let placementFailure as RoktEvent.PlacementFailure:
            return MPRoktEvent.MPRoktPlacementFailure(placementId: placementFailure.placementId)
            
        case let firstPositiveEngagement as RoktEvent.FirstPositiveEngagement:
            return MPRoktEvent.MPRoktFirstPositiveEngagement(
                placementId: firstPositiveEngagement.placementId,
                onFulfillmentAttributesUpdate: firstPositiveEngagement.setFulfillmentAttributes
            )
            
        case let cartItemInstantPurchase as RoktEvent.CartItemInstantPurchase:
            return MPRoktEvent.MPRoktCartItemInstantPurchase(
                placementId: cartItemInstantPurchase.placementId,
                name: cartItemInstantPurchase.name ?? "",
                cartItemId: cartItemInstantPurchase.cartItemId,
                catalogItemId: cartItemInstantPurchase.catalogItemId,
                currency: cartItemInstantPurchase.currency,
                description: cartItemInstantPurchase.description,
                linkedProductId: cartItemInstantPurchase.linkedProductId,
                providerData: cartItemInstantPurchase.providerData,
                quantity: cartItemInstantPurchase.quantity,
                totalPrice: cartItemInstantPurchase.totalPrice,
                unitPrice: cartItemInstantPurchase.unitPrice
            )
            
        default:
            return nil
        }
    }
}
