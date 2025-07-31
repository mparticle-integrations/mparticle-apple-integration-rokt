#import <Foundation/Foundation.h>

@class RoktEvent;
@class MPRoktEvent;

NS_ASSUME_NONNULL_BEGIN

/// Utility class for mapping Rokt events to mParticle events
@interface MPRoktEventMapper : NSObject

/// Maps a RoktEvent to the corresponding MPRoktEvent
/// @param event The RoktEvent to map
/// @return The mapped MPRoktEvent, or nil if mapping fails
+ (MPRoktEvent * _Nullable)mapEvent:(RoktEvent *)event;

@end

NS_ASSUME_NONNULL_END