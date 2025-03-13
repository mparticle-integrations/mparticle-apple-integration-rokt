// Generated by Apple Swift version 5.10 (swiftlang-5.10.0.13 clang-1500.3.9.4)
#ifndef ROKT_WIDGET_SWIFT_H
#define ROKT_WIDGET_SWIFT_H
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#if defined(__OBJC__)
#include <Foundation/Foundation.h>
#endif
#if defined(__cplusplus)
#include <cstdint>
#include <cstddef>
#include <cstdbool>
#include <cstring>
#include <stdlib.h>
#include <new>
#include <type_traits>
#else
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include <string.h>
#endif
#if defined(__cplusplus)
#if defined(__arm64e__) && __has_include(<ptrauth.h>)
# include <ptrauth.h>
#else
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreserved-macro-identifier"
# ifndef __ptrauth_swift_value_witness_function_pointer
#  define __ptrauth_swift_value_witness_function_pointer(x)
# endif
# ifndef __ptrauth_swift_class_method_pointer
#  define __ptrauth_swift_class_method_pointer(x)
# endif
#pragma clang diagnostic pop
#endif
#endif

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...) 
# endif
#endif
#if !defined(SWIFT_RUNTIME_NAME)
# if __has_attribute(objc_runtime_name)
#  define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
# else
#  define SWIFT_RUNTIME_NAME(X) 
# endif
#endif
#if !defined(SWIFT_COMPILE_NAME)
# if __has_attribute(swift_name)
#  define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
# else
#  define SWIFT_COMPILE_NAME(X) 
# endif
#endif
#if !defined(SWIFT_METHOD_FAMILY)
# if __has_attribute(objc_method_family)
#  define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
# else
#  define SWIFT_METHOD_FAMILY(X) 
# endif
#endif
#if !defined(SWIFT_NOESCAPE)
# if __has_attribute(noescape)
#  define SWIFT_NOESCAPE __attribute__((noescape))
# else
#  define SWIFT_NOESCAPE 
# endif
#endif
#if !defined(SWIFT_RELEASES_ARGUMENT)
# if __has_attribute(ns_consumed)
#  define SWIFT_RELEASES_ARGUMENT __attribute__((ns_consumed))
# else
#  define SWIFT_RELEASES_ARGUMENT 
# endif
#endif
#if !defined(SWIFT_WARN_UNUSED_RESULT)
# if __has_attribute(warn_unused_result)
#  define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
# else
#  define SWIFT_WARN_UNUSED_RESULT 
# endif
#endif
#if !defined(SWIFT_NORETURN)
# if __has_attribute(noreturn)
#  define SWIFT_NORETURN __attribute__((noreturn))
# else
#  define SWIFT_NORETURN 
# endif
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA 
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA 
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA 
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif
#if !defined(SWIFT_RESILIENT_CLASS)
# if __has_attribute(objc_class_stub)
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME) __attribute__((objc_class_stub))
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_class_stub)) SWIFT_CLASS_NAMED(SWIFT_NAME)
# else
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME)
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) SWIFT_CLASS_NAMED(SWIFT_NAME)
# endif
#endif
#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif
#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER 
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility) 
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_WEAK_IMPORT)
# define SWIFT_WEAK_IMPORT __attribute__((weak_import))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED_OBJC)
# if __has_feature(attribute_diagnose_if_objc)
#  define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
# else
#  define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
# endif
#endif
#if defined(__OBJC__)
#if !defined(IBSegueAction)
# define IBSegueAction 
#endif
#endif
#if !defined(SWIFT_EXTERN)
# if defined(__cplusplus)
#  define SWIFT_EXTERN extern "C"
# else
#  define SWIFT_EXTERN extern
# endif
#endif
#if !defined(SWIFT_CALL)
# define SWIFT_CALL __attribute__((swiftcall))
#endif
#if !defined(SWIFT_INDIRECT_RESULT)
# define SWIFT_INDIRECT_RESULT __attribute__((swift_indirect_result))
#endif
#if !defined(SWIFT_CONTEXT)
# define SWIFT_CONTEXT __attribute__((swift_context))
#endif
#if !defined(SWIFT_ERROR_RESULT)
# define SWIFT_ERROR_RESULT __attribute__((swift_error_result))
#endif
#if defined(__cplusplus)
# define SWIFT_NOEXCEPT noexcept
#else
# define SWIFT_NOEXCEPT 
#endif
#if !defined(SWIFT_C_INLINE_THUNK)
# if __has_attribute(always_inline)
# if __has_attribute(nodebug)
#  define SWIFT_C_INLINE_THUNK inline __attribute__((always_inline)) __attribute__((nodebug))
# else
#  define SWIFT_C_INLINE_THUNK inline __attribute__((always_inline))
# endif
# else
#  define SWIFT_C_INLINE_THUNK inline
# endif
#endif
#if defined(_WIN32)
#if !defined(SWIFT_IMPORT_STDLIB_SYMBOL)
# define SWIFT_IMPORT_STDLIB_SYMBOL __declspec(dllimport)
#endif
#else
#if !defined(SWIFT_IMPORT_STDLIB_SYMBOL)
# define SWIFT_IMPORT_STDLIB_SYMBOL 
#endif
#endif
#if defined(__OBJC__)
#if __has_feature(objc_modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import CoreFoundation;
@import Foundation;
@import ObjectiveC;
@import SafariServices;
@import UIKit;
#endif

#endif
#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"
#pragma clang diagnostic ignored "-Wdollar-in-identifier-extension"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="Rokt_Widget",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif

#if defined(__OBJC__)



enum RoktFrameworkType : NSInteger;
@class NSString;
@class RoktEmbeddedView;
@class RoktConfig;
enum RoktEventType : NSInteger;
@class RoktEventHandler;
@class RoktEvent;
enum RoktEnvironment : NSInteger;

/// Rokt class to initialize and siplay Rokt’s widget
SWIFT_CLASS("_TtC11Rokt_Widget4Rokt")
@interface Rokt : NSObject
/// Rokt private initializer. Only available for the singleton object <code>shared</code>
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
+ (void)setFrameworkTypeWithFrameworkType:(enum RoktFrameworkType)frameworkType;
/// Rokt developer facing initializer. Sets default launch delay and API timeout
/// \param roktTagId The tag id provided by Rokt, associated with your account.
///
+ (void)initWithRoktTagId:(NSString * _Nonnull)roktTagId SWIFT_METHOD_FAMILY(none);
/// Rokt developer facing initializer. Sets default launch delay and API timeout
/// \param roktTagId The tag id provided by Rokt, associated with your account.
///
/// \param onInitComplete Function to execute when the SDK has finished initialization
///
+ (void)initWithRoktTagId:(NSString * _Nonnull)roktTagId onInitComplete:(void (^ _Nonnull)(BOOL))onInitComplete SWIFT_METHOD_FAMILY(none);
/// Rokt developer facing execute
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
+ (void)executeWithViewName:(NSString * _Nullable)viewName attributes:(NSDictionary<NSString *, NSString *> * _Nonnull)attributes placements:(NSDictionary<NSString *, RoktEmbeddedView *> * _Nullable)placements onLoad:(void (^ _Nullable)(void))onLoad onUnLoad:(void (^ _Nullable)(void))onUnLoad onShouldShowLoadingIndicator:(void (^ _Nullable)(void))onShouldShowLoadingIndicator onShouldHideLoadingIndicator:(void (^ _Nullable)(void))onShouldHideLoadingIndicator onEmbeddedSizeChange:(void (^ _Nullable)(NSString * _Nonnull, CGFloat))onEmbeddedSizeChange;
/// Rokt developer facing execute
/// \param viewName The name that should be displayed in the widget
///
/// \param attributes A string dictionary containing the parameters that should be displayed in the widget
///
/// \param placements A dictionary of RoktEmbeddedViews with their names
///
/// \param config An object which defines RoktConfig
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
+ (void)executeWithViewName:(NSString * _Nullable)viewName attributes:(NSDictionary<NSString *, NSString *> * _Nonnull)attributes placements:(NSDictionary<NSString *, RoktEmbeddedView *> * _Nullable)placements config:(RoktConfig * _Nullable)config onLoad:(void (^ _Nullable)(void))onLoad onUnLoad:(void (^ _Nullable)(void))onUnLoad onShouldShowLoadingIndicator:(void (^ _Nullable)(void))onShouldShowLoadingIndicator onShouldHideLoadingIndicator:(void (^ _Nullable)(void))onShouldHideLoadingIndicator onEmbeddedSizeChange:(void (^ _Nullable)(NSString * _Nonnull, CGFloat))onEmbeddedSizeChange;
/// Rokt developer facing execute
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
/// \param onEvent Function to execute when some events triggered, the first item is eventType  and
/// second is eventHandler
///
+ (void)execute2stepWithViewName:(NSString * _Nullable)viewName attributes:(NSDictionary<NSString *, NSString *> * _Nonnull)attributes placements:(NSDictionary<NSString *, RoktEmbeddedView *> * _Nullable)placements onLoad:(void (^ _Nullable)(void))onLoad onUnLoad:(void (^ _Nullable)(void))onUnLoad onShouldShowLoadingIndicator:(void (^ _Nullable)(void))onShouldShowLoadingIndicator onShouldHideLoadingIndicator:(void (^ _Nullable)(void))onShouldHideLoadingIndicator onEmbeddedSizeChange:(void (^ _Nullable)(NSString * _Nonnull, CGFloat))onEmbeddedSizeChange onEvent:(void (^ _Nullable)(enum RoktEventType, RoktEventHandler * _Nonnull))onEvent;
/// Rokt developer facing execute
/// \param viewName The name that should be displayed in the widget
///
/// \param attributes A string dictionary containing the parameters that should be displayed in the widget
///
/// \param placements A dictionary of RoktEmbeddedViews with their names
///
/// \param config An object which defines RoktConfig
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
/// \param onEvent Function to execute when some events triggered, the first item is eventType  and
/// second is eventHandler
///
+ (void)execute2stepWithViewName:(NSString * _Nullable)viewName attributes:(NSDictionary<NSString *, NSString *> * _Nonnull)attributes placements:(NSDictionary<NSString *, RoktEmbeddedView *> * _Nullable)placements config:(RoktConfig * _Nullable)config onLoad:(void (^ _Nullable)(void))onLoad onUnLoad:(void (^ _Nullable)(void))onUnLoad onShouldShowLoadingIndicator:(void (^ _Nullable)(void))onShouldShowLoadingIndicator onShouldHideLoadingIndicator:(void (^ _Nullable)(void))onShouldHideLoadingIndicator onEmbeddedSizeChange:(void (^ _Nullable)(NSString * _Nonnull, CGFloat))onEmbeddedSizeChange onEvent:(void (^ _Nullable)(enum RoktEventType, RoktEventHandler * _Nonnull))onEvent;
/// Rokt developer facing execute
/// \param viewName The name that should be displayed in the widget
///
/// \param attributes A string dictionary containing the parameters that should be displayed in the widget
///
/// \param placements A dictionary of RoktEmbeddedViews with their names
///
/// \param onEvent Function to execute when some events triggered, the first item is RoktEvent
///
/// \param onEmbeddedSizeChange Function to execute when size of embeddedView change, the first item is selected
/// Placement and second item is widget height
///
+ (void)executeWithEventsWithViewName:(NSString * _Nullable)viewName attributes:(NSDictionary<NSString *, NSString *> * _Nonnull)attributes placements:(NSDictionary<NSString *, RoktEmbeddedView *> * _Nullable)placements onEvent:(void (^ _Nullable)(RoktEvent * _Nonnull))onEvent onEmbeddedSizeChange:(void (^ _Nullable)(NSString * _Nonnull, CGFloat))onEmbeddedSizeChange;
/// Rokt developer facing execute
/// \param viewName The name that should be displayed in the widget
///
/// \param attributes A string dictionary containing the parameters that should be displayed in the widget
///
/// \param placements A dictionary of RoktEmbeddedViews with their names
///
/// \param config An object which defines RoktConfig
///
/// \param onEvent Function to execute when some events triggered, the first item is RoktEvent
///
/// \param onEmbeddedSizeChange Function to execute when size of embeddedView change, the first item is selected
/// Placement and second item is widget height
///
+ (void)executeWithEventsWithViewName:(NSString * _Nullable)viewName attributes:(NSDictionary<NSString *, NSString *> * _Nonnull)attributes placements:(NSDictionary<NSString *, RoktEmbeddedView *> * _Nullable)placements config:(RoktConfig * _Nullable)config onEvent:(void (^ _Nullable)(RoktEvent * _Nonnull))onEvent onEmbeddedSizeChange:(void (^ _Nullable)(NSString * _Nonnull, CGFloat))onEmbeddedSizeChange;
/// Rokt developer facing close for overlay, lightbox, bottomsheet
+ (void)close;
+ (void)setLoggingEnabledWithEnable:(BOOL)enable;
+ (void)setEnvironmentWithEnvironment:(enum RoktEnvironment)environment;
/// Rokt developer facing events subscription
/// \param viewName The name that should be displayed in the widget
///
/// \param onEvent Function to execute when some events triggered, the first item is RoktEvent
///
+ (void)eventsWithViewName:(NSString * _Nonnull)viewName onEvent:(void (^ _Nullable)(RoktEvent * _Nonnull))onEvent;
/// Rokt developer facing events subscription for global events.
/// Events that are not associated with a view(such as InitComplete) will be delivered
/// \param onEvent Function to execute when some events triggered, the first item is RoktEvent
///
+ (void)globalEventsOnEvent:(void (^ _Nonnull)(RoktEvent * _Nonnull))onEvent;
/// Allows user to update an attribute that will be included in the next execute call.
/// \param key key of element to be updated
///
/// \param value new value
///
+ (void)updateAttributeWithKey:(NSString * _Nonnull)key value:(NSString * _Nonnull)value;
/// Allows user to set attributes that will be included in the next execute call.
+ (void)setAttributes:(NSDictionary<NSString *, NSString *> * _Nonnull)attributes;
@end


SWIFT_CLASS("_TtC11Rokt_Widget10RoktConfig")
@interface RoktConfig : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end

typedef SWIFT_ENUM(NSInteger, ColorMode, open) {
  ColorModeLight = 0,
  ColorModeDark = 1,
  ColorModeSystem = 2,
};


/// Config for caching of layouts with an enforced maximum duration of 90 minutes
SWIFT_CLASS("_TtCC11Rokt_Widget10RoktConfig11CacheConfig")
@interface CacheConfig : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly) NSTimeInterval maxCacheDuration;)
+ (NSTimeInterval)maxCacheDuration SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)initWithCacheDuration:(NSTimeInterval)cacheDuration cacheAttributes:(NSDictionary<NSString *, NSString *> * _Nullable)cacheAttributes OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtCC11Rokt_Widget10RoktConfig7Builder")
@interface Builder : NSObject
- (Builder * _Nonnull)colorMode:(enum ColorMode)colorMode SWIFT_WARN_UNUSED_RESULT;
- (Builder * _Nonnull)cacheConfig:(CacheConfig * _Nonnull)cacheConfig SWIFT_WARN_UNUSED_RESULT;
- (RoktConfig * _Nonnull)build SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class NSCoder;
@class UIGestureRecognizer;
@class UITouch;
@class UITraitCollection;

SWIFT_CLASS("_TtC11Rokt_Widget18RoktEmbeddedUIView")
@interface RoktEmbeddedUIView : UIView <UIGestureRecognizerDelegate>
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (BOOL)gestureRecognizer:(UIGestureRecognizer * _Nonnull)gestureRecognizer shouldReceiveTouch:(UITouch * _Nonnull)touch SWIFT_WARN_UNUSED_RESULT;
- (void)layoutSubviews;
- (void)traitCollectionDidChange:(UITraitCollection * _Nullable)previousTraitCollection;
@end


@class SFSafariViewController;

@interface RoktEmbeddedUIView (SWIFT_EXTENSION(Rokt_Widget)) <SFSafariViewControllerDelegate>
- (void)safariViewController:(SFSafariViewController * _Nonnull)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully;
@end

@class UITextView;
@class NSURL;

@interface RoktEmbeddedUIView (SWIFT_EXTENSION(Rokt_Widget)) <UITextViewDelegate>
- (BOOL)textView:(UITextView * _Nonnull)textView shouldInteractWithURL:(NSURL * _Nonnull)URL inRange:(NSRange)characterRange SWIFT_WARN_UNUSED_RESULT;
@end




SWIFT_CLASS("_TtC11Rokt_Widget16RoktEmbeddedView")
@interface RoktEmbeddedView : UIView
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


/// Rokt public environment enum
typedef SWIFT_ENUM(NSInteger, RoktEnvironment, open) {
  RoktEnvironmentProd = 0,
  RoktEnvironmentProdDemo = 1,
  RoktEnvironmentStage = 2,
  RoktEnvironmentLocal = 3,
};


SWIFT_CLASS("_TtC11Rokt_Widget9RoktEvent")
@interface RoktEvent : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtCC11Rokt_Widget9RoktEvent12InitComplete")
@interface InitComplete : RoktEvent
@property (nonatomic, readonly) BOOL success;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtCC11Rokt_Widget9RoktEvent20ShowLoadingIndicator")
@interface ShowLoadingIndicator : RoktEvent
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtCC11Rokt_Widget9RoktEvent20HideLoadingIndicator")
@interface HideLoadingIndicator : RoktEvent
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtCC11Rokt_Widget9RoktEvent20PlacementInteractive")
@interface PlacementInteractive : RoktEvent
@property (nonatomic, readonly, copy) NSString * _Nullable placementId;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtCC11Rokt_Widget9RoktEvent14PlacementReady")
@interface PlacementReady : RoktEvent
@property (nonatomic, readonly, copy) NSString * _Nullable placementId;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtCC11Rokt_Widget9RoktEvent15OfferEngagement")
@interface OfferEngagement : RoktEvent
@property (nonatomic, readonly, copy) NSString * _Nullable placementId;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtCC11Rokt_Widget9RoktEvent18PositiveEngagement")
@interface PositiveEngagement : RoktEvent
@property (nonatomic, readonly, copy) NSString * _Nullable placementId;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtCC11Rokt_Widget9RoktEvent15PlacementClosed")
@interface PlacementClosed : RoktEvent
@property (nonatomic, readonly, copy) NSString * _Nullable placementId;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtCC11Rokt_Widget9RoktEvent18PlacementCompleted")
@interface PlacementCompleted : RoktEvent
@property (nonatomic, readonly, copy) NSString * _Nullable placementId;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtCC11Rokt_Widget9RoktEvent16PlacementFailure")
@interface PlacementFailure : RoktEvent
@property (nonatomic, readonly, copy) NSString * _Nullable placementId;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtCC11Rokt_Widget9RoktEvent23FirstPositiveEngagement")
@interface FirstPositiveEngagement : RoktEvent
@property (nonatomic, readonly, copy) NSString * _Nullable placementId;
- (void)setFulfillmentAttributesWithAttributes:(NSDictionary<NSString *, NSString *> * _Nonnull)attributes;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtC11Rokt_Widget16RoktEventHandler")
@interface RoktEventHandler : RoktEvent
- (void)setFulfillmentAttributesWithAttributes:(NSDictionary<NSString *, NSString *> * _Nonnull)attributes;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end

typedef SWIFT_ENUM(NSInteger, RoktEventType, open) {
  RoktEventTypeFirstPositiveEngagement = 0,
};

/// Rokt public framework type enum
typedef SWIFT_ENUM(NSInteger, RoktFrameworkType, open) {
  RoktFrameworkTypeIOS = 0,
  RoktFrameworkTypeCordova = 1,
  RoktFrameworkTypeReactNative = 2,
  RoktFrameworkTypeFlutter = 3,
  RoktFrameworkTypeMaui = 4,
};

@protocol UIViewControllerTransitionCoordinator;
@class NSBundle;

/// Main Rokt widget view controller
SWIFT_CLASS("_TtC11Rokt_Widget18RoktViewController")
@interface RoktViewController : UIViewController <UIGestureRecognizerDelegate>
- (void)viewDidLoad;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;
- (BOOL)gestureRecognizer:(UIGestureRecognizer * _Nonnull)gestureRecognizer shouldReceiveTouch:(UITouch * _Nonnull)touch SWIFT_WARN_UNUSED_RESULT;
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator> _Nonnull)coordinator;
- (IBAction)done:(id _Nonnull)sender;
- (void)traitCollectionDidChange:(UITraitCollection * _Nullable)previousTraitCollection;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end



@interface RoktViewController (SWIFT_EXTENSION(Rokt_Widget)) <SFSafariViewControllerDelegate>
- (void)safariViewController:(SFSafariViewController * _Nonnull)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully;
@end



@interface RoktViewController (SWIFT_EXTENSION(Rokt_Widget)) <UITextViewDelegate>
- (BOOL)textView:(UITextView * _Nonnull)textView shouldInteractWithURL:(NSURL * _Nonnull)URL inRange:(NSRange)characterRange SWIFT_WARN_UNUSED_RESULT;
@end


















#endif
#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#if defined(__cplusplus)
#endif
#pragma clang diagnostic pop
#endif
