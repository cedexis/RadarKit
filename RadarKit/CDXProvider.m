//
//  Provider.m
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-27.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import "CDXProvider.h"
#import "CDXProbe.h"

@implementation CDXProvider

-(id)initWithSample:(NSDictionary *)sample process:(CDXRadarProcess *)process {
    if (self = [super init]) {
        _sample = sample;
        _process = process;
    }
    return self;
}

-(NSMutableArray *)probesWithSample:(NSDictionary *)sample
{
    NSDictionary * providerData = [self.sample objectForKey:@"p"];
    int ownerZoneId = [[providerData objectForKey:@"z"] intValue];
    int ownerCustomerId = [[providerData objectForKey:@"c"] intValue];
    int providerId = [[providerData objectForKey:@"i"] intValue];
    NSDictionary * probesSection = [providerData objectForKey:@"p"];
    
    NSDictionary * protocolData;
    if ([self.process.radar.protocol isEqualToString:@"https"]) {
        protocolData = [probesSection objectForKey:@"b"];
        if (!protocolData) {
            protocolData = [probesSection objectForKey:@"a"];
        }
    } else {
        protocolData = [probesSection objectForKey:@"a"];
    }
    
    NSMutableArray * probes = [NSMutableArray array];
    
    // Cold probe
    NSDictionary * probeData;
    probeData = [protocolData objectForKey:@"a"];
    if (probeData) {
        [probes addObject:[[CDXProbe alloc] initWithUrl:probeData[@"u"] process:self.process probeId:1 objectType:[probeData[@"t"] intValue] ownerZoneId:ownerZoneId ownerCustomerId:ownerCustomerId providerId:providerId]];
    }
    probeData = [protocolData objectForKey:@"b"];
    if (probeData) {
        [probes addObject:[[CDXProbe alloc] initWithUrl:probeData[@"u"] process:self.process probeId:0 objectType:[probeData[@"t"] intValue] ownerZoneId:ownerZoneId ownerCustomerId:ownerCustomerId providerId:providerId]];
    }
    probeData = [protocolData objectForKey:@"c"];
    if (probeData) {
        [probes addObject:[[CDXProbe alloc] initWithUrl:probeData[@"u"] process:self.process probeId:14 objectType:[[probeData objectForKey:@"t"] intValue] ownerZoneId:ownerZoneId ownerCustomerId:ownerCustomerId providerId:providerId]];
    }
    return probes;
}

-(void)measureWithCompletionHandler:(void (^)(NSError *))handler {
    NSMutableArray *probes = [self probesWithSample:self.sample];
    [self measureWithProbes:probes completionHandler:handler];
}

- (void)measureWithProbes:(NSMutableArray *)probes completionHandler:(void(^)(NSError *))handler {
    if (probes.count > 0) {
        CDXProbe *probe = probes.firstObject;
        [probes removeObjectAtIndex:0];
        [probe measureWithCompletionHandler:^(NSError *error) {
            if (error) {
                handler(error);
            } else {
                [self measureWithProbes:probes completionHandler:handler];
            }
        }];
    } else {
        handler(nil);
    }
}

@end
