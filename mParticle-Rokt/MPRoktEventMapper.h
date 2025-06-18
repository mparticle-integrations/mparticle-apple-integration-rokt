#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MPRoktEvent;
@class RoktEvent;

@interface MPRoktEventMapper : NSObject

+ (nullable id<MPRoktEvent>)mapEvent:(RoktEvent *)event;

@end

NS_ASSUME_NONNULL_END 