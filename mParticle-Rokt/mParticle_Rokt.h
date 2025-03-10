#import <UIKit/UIKit.h>

FOUNDATION_EXPORT double mParticle_RoktVersionNumber;
FOUNDATION_EXPORT const unsigned char mParticle_RoktVersionString[];

#if defined(__has_include) && __has_include(<mParticle_Appboy/MPKitAppboy.h>)
    #import <mParticle_Rokt/MPKitRokt.h>
#else
    #import "MPKitRokt.h"
#endif
