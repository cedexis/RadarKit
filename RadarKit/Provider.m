//
//  Provider.m
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-27.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import "Provider.h"
#import "Probe.h"

@implementation Provider

@synthesize _sample;
@synthesize _protocol;

-(id)initWithSample:(NSDictionary *)sample ForProtocol:(NSString *)protocol {
    if (self = [super init]) {
        self._sample = sample;
        self._protocol = protocol;
        //NSLog(@"%@", self._sample);
    }
    return self;
}

-(void)measureForZone:(int)requestorZoneId Customer:(int)requestorCustomerId TransactionId:(unsigned long)transactionId AndRequestSignature:(NSString *)requestSignature {
    //NSLog(@"Hello measure");
    NSDictionary * providerData = [self._sample objectForKey:@"p"];
    int ownerZoneId = [[providerData objectForKey:@"z"] intValue];
    int ownerCustomerId = [[providerData objectForKey:@"c"] intValue];
    int providerId = [[providerData objectForKey:@"i"] intValue];
    NSDictionary * probesSection = [providerData objectForKey:@"p"];
    //NSLog(@"%@ %@ %@", ownerZoneId, ownerCustomerId, probesSection);
    
    BOOL isHttps = NO;
    NSDictionary * protocolData;
    if ([self._protocol isEqualToString:@"https"]) {
        isHttps = YES;
        protocolData = [probesSection objectForKey:@"b"];
        if (!protocolData) {
            protocolData = [probesSection objectForKey:@"a"];
        }
    } else {
        protocolData = [probesSection objectForKey:@"a"];
    }
    //NSLog(@"%@", protocolData);
    
    NSMutableArray * probes = [NSMutableArray array];
    
    // Cold probe
    NSDictionary * probeData;
    probeData = [protocolData objectForKey:@"a"];
    if (probeData) {
        [probes addObject:[[Probe alloc] initWithUrl:[probeData objectForKey:@"u"] ProbeId:1 ObjectType:[[probeData objectForKey:@"t"] intValue]]];
    }
    probeData = [protocolData objectForKey:@"b"];
    if (probeData) {
        [probes addObject:[[Probe alloc] initWithUrl:[probeData objectForKey:@"u"] ProbeId:0 ObjectType:[[probeData objectForKey:@"t"] intValue]]];
    }
    probeData = [protocolData objectForKey:@"c"];
    if (probeData) {
        [probes addObject:[[Probe alloc] initWithUrl:[probeData objectForKey:@"u"] ProbeId:14 ObjectType:[[probeData objectForKey:@"t"] intValue]]];
    }
    
    for (Probe * probe in probes) {
        [probe measureForZoneId:requestorZoneId
                     CustomerId:requestorCustomerId
                    OwnerZoneId:ownerZoneId
                OwnerCustomerId:ownerCustomerId
                     ProviderId:providerId
                  TransactionId:transactionId
            AndRequestSignature:requestSignature ];
    }
}

@end
