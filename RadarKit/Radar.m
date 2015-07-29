//
//  Radar.m
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-26.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import "Radar.h"
#import "Init.h"
#import "Providers.h"
#import "Provider.h"

@implementation Radar

-(instancetype)initWithZoneId:(int)zoneId customerId:(int)customerId {
    return [self initWithZoneId:zoneId customerId:customerId protocol:@"http"];
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

-(void)run {
    //NSLog(@"Hello run: %d %d", zoneId, customerId);
    NSUInteger initTimestamp = [[NSDate date] timeIntervalSince1970];
    Init * init = [[Init alloc] initWithZoneId:self.zoneId
                                CustomerId:self.customerId
                                 Timestamp:initTimestamp
                               AndProtocol:self.protocol ];
    NSLog(@"%@", init);
    NSString * requestSignature = [init makeRequest];
    NSLog(@"Request signature: %@", requestSignature);
    
    Providers * providers = [[Providers alloc]
        initWithZoneId:self.zoneId
            CustomerId:self.customerId
      RequestSignature:requestSignature
             Timestamp:initTimestamp
           AndProtocol:self.protocol];
           
    if ([providers requestProviders]) {
        //NSLog(@"%@", providers._sample);
        for (NSDictionary * providerData in providers._sample) {
            Provider * provider = [[Provider alloc] initWithSample:providerData ForProtocol:self.protocol];
            if (provider) {
                [provider measureForZone:self.zoneId
                                Customer:self.customerId
                           TransactionId:init._transactionId
                     AndRequestSignature:requestSignature];
            }
        }
    }
    NSLog(@"Radar session complete");
}

@end
