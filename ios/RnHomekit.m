#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RnHomekit, NSObject)

RCT_EXTERN_METHOD(multiply:
                 (float)a
                 withB:(float)b
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)


RCT_EXTERN_METHOD(getHomeAccessories:
                  (RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getAccessory:
                  (NSString *)accessoryId
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getAccessoryServices:
                (NSString *)accessoryId
                withResolver:(RCTPromiseResolveBlock)resolve
                withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(setAccessoryValue:
                (NSString *)accessoryId
                withServiceId:(NSString *)serviceId
                withCharacteristicId:(NSString *)characteristicId
                withValue:(NSNumber *_Nonnull)value
                withResolver:(RCTPromiseResolveBlock)resolve
                withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(authorizationStatus:
                  (RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)
@end
