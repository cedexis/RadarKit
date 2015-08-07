//
//  Radar.m
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-26.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import "CDXRadar.h"
#import "CDXInitService.h"
#import "CDXProviderService.h"
#import "CDXProvider.h"
#import "CDXLogger.h"

@implementation CDXRadar

-(instancetype)initWithZoneId:(int)zoneId customerId:(int)customerId {
    return [self initWithZoneId:zoneId customerId:customerId protocol:@"https"];
}

-(instancetype)initWithZoneId:(int)zoneId customerId:(int)customerId protocol:(NSString *)protocol {
    self = [super init];
    if (self) {
        _zoneId = zoneId;
        _customerId = customerId;
        _protocol = protocol;
        _isThroughputMeasurementAlwaysOn = NO;
        _isVerbose = NO;
    }
    return self;
}

# pragma mark - Public methods

-(CDXRadarSession *)runInBackground {
    return [self runInBackgroundWithCompletionHandler:nil];
}

-(CDXRadarSession *)runInBackgroundWithCompletionHandler:(void(^)(NSError *))handler {
    CDXRadarSession *session = [[CDXRadarSession alloc] initWithRadar:self];
    CDXInitService *initService = [CDXInitService new];
//    [[CDXLogger sharedInstance] log:cdxInit.description];
    [initService getSignatureForSession:session completionHandler:^(NSString *requestSignature, NSError *error) {
        [[CDXLogger sharedInstance] log:[NSString stringWithFormat:@"Request signature: %@", requestSignature]];
        if (error) {
            if (handler) {
                handler(error);
            }
            return;
        }
        session.requestSignature = requestSignature;
        CDXProviderService * providerService = [CDXProviderService new];
        [providerService requestSamplesForSession:session completionHandler:^(NSArray *samples, NSError *error) {
            if (error) {
                if (handler) {
                    handler(error);
                }
            }
            NSMutableArray *providers = [NSMutableArray array];
            for (NSDictionary * providerData in samples) {
                CDXProvider * provider = [[CDXProvider alloc] initWithSample:providerData session:session];
                [providers addObject:provider];
            }
            [self measureWithProviders:providers completionHandler:^(NSError *error) {
                [[CDXLogger sharedInstance] log:@"Radar session complete"];
                if (handler) {
                    handler(error);
                }
            }];
        }];
        
    }];
    return session;
}

# pragma mark - Custom setters

-(void)setIsVerbose:(BOOL)isVerbose {
    _isVerbose = isVerbose;
    [CDXLogger sharedInstance].isVerbose = isVerbose;
}

# pragma mark - Private methods

-(void)measureWithProviders:(NSMutableArray *)providers completionHandler:(void(^)(NSError *error))handler {
    if (providers.count > 0) {
        CDXProvider *provider = providers.firstObject;
        [providers removeObjectAtIndex:0];
        [provider measureWithCompletionHandler:^(NSError *error) {
            if (error) {
                handler(error);
            } else {
                [self measureWithProviders:providers completionHandler:handler];
            }
        }];
    } else {
        handler(nil);
    }
}

@end
