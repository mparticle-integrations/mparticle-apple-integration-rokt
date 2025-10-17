#import <Foundation/Foundation.h>
#if defined(__has_include) && __has_include(<mParticle_Apple_SDK/mParticle.h>)
    #import <mParticle_Apple_SDK/mParticle.h>
    #import <mParticle_Apple_SDK/mParticle_Apple_SDK-Swift.h>
#elif defined(__has_include) && __has_include(<mParticle_Apple_SDK_NoLocation/mParticle.h>)
    #import <mParticle_Apple_SDK_NoLocation/mParticle.h>
    #import <mParticle_Apple_SDK_NoLocation/mParticle_Apple_SDK-Swift.h>
#else
    #import "mParticle.h"
    #import "mParticle_Apple_SDK-Swift.h"
#endif

@interface MPKitRokt : NSObject <MPKitProtocol>

@property (nonatomic, strong, nonnull) NSDictionary *configuration;
@property (nonatomic, strong, nullable) NSDictionary *launchOptions;
@property (nonatomic, unsafe_unretained, readonly) BOOL started;
@property (nonatomic, strong, nullable, readonly) id providerKitInstance;
@property (nonatomic, strong, nonnull, readonly) id kitInstance;
@property (nonatomic, strong, nonnull, readonly) NSNumber *sideloadedKitCode;

+ (NSDictionary<NSString *, NSString *> * _Nonnull)prepareAttributes:(NSDictionary<NSString *, NSString *> * _Nonnull)attributes filteredUser:(FilteredMParticleUser * _Nullable)filteredUser performMapping:(BOOL)performMapping;
+ (NSNumber * _Nullable)getRoktHashedEmailUserIdentityType;

@end
