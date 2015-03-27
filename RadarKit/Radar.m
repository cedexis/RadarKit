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

-(void)runForZoneId:(int)zoneId CustomerId:(int)customerId {
    [self runForZoneId:zoneId CustomerId:customerId AndProtocol:@"http"];
}

-(void)runForZoneId:(int)zoneId CustomerId:(int)customerId AndProtocol:(NSString *)protocol {
    //NSLog(@"Hello run: %d %d", zoneId, customerId);
    NSUInteger initTimestamp = [[NSDate date] timeIntervalSince1970];
    Init * init = [[Init alloc] initWithZoneId:zoneId
                                CustomerId:customerId
                                 Timestamp:initTimestamp
                               AndProtocol:protocol ];
    NSLog(@"%@", init);
    NSString * requestSignature = [init makeRequest];
    NSLog(@"Request signature: %@", requestSignature);
    
    Providers * providers = [[Providers alloc]
        initWithZoneId:zoneId
            CustomerId:customerId
      RequestSignature:requestSignature
             Timestamp:initTimestamp
           AndProtocol:protocol];
           
    if ([providers requestProviders]) {
        //NSLog(@"%@", providers._sample);
        for (NSDictionary * providerData in providers._sample) {
            Provider * provider = [[Provider alloc] initWithSample:providerData ForProtocol:protocol];
            if (provider) {
                [provider measureForZone:zoneId
                                Customer:customerId
                           TransactionId:init._transactionId
                     AndRequestSignature:requestSignature];
            }
        }
    }
    NSLog(@"Radar session complete");
}

@end
