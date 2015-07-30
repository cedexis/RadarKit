//
//  Radar.m
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-26.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import "CDXRadar.h"
#import "CDXInit.h"
#import "CDXProviders.h"
#import "CDXProvider.h"

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
    }
    return self;
}

# pragma mark - Public methods

-(void)runInBackground {
    [self runInBackgroundWithCompletionHandler:nil];
}

-(void)runInBackgroundWithCompletionHandler:(void(^)(NSError *))handler {
    NSUInteger initTimestamp = [[NSDate date] timeIntervalSince1970];
    CDXInit * init = [[CDXInit alloc] initWithZoneId:self.zoneId
                                CustomerId:self.customerId
                                 Timestamp:initTimestamp
                               AndProtocol:self.protocol ];
    NSLog(@"%@", init);
    [init makeRequestWithCompletionHandler:^(NSString *requestSignature, NSError *error) {
        NSLog(@"Request signature: %@", requestSignature);
        
        CDXProviders * providers = [[CDXProviders alloc]
                                 initWithZoneId:self.zoneId
                                 CustomerId:self.customerId
                                 RequestSignature:requestSignature
                                 Timestamp:initTimestamp
                                 AndProtocol:self.protocol];
        
        [providers requestProvidersWithCompletionHandler:^(NSArray *samples, NSError *error) {
            if (error) {
                if (handler) {
                    handler(error);
                }
            }
            NSMutableArray *providers = [NSMutableArray array];
            for (NSDictionary * providerData in samples) {
                CDXProvider * provider = [[CDXProvider alloc] initWithSample:providerData protocol:self.protocol zone:self.zoneId customerId:self.customerId transactionId:init._transactionId requestSignature:requestSignature];
                [providers addObject:provider];
            }
            [self measureWithProviders:providers completionHandler:^(NSError *error) {
                NSLog(@"Radar session complete");
                if (handler) {
                    handler(error);
                }
            }];
        }];
        
    }];
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
