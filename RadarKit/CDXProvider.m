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

-(id)initWithSample:(NSDictionary *)sample protocol:(NSString *)protocol zone:(int)zoneId customerId:(int)customerId transactionId:(unsigned long)transactionId requestSignature:(NSString *)requestSignature {
    if (self = [super init]) {
        _sample = sample;
        _protocol = protocol;
        _zoneId = zoneId;
        _customerId = customerId;
        _transactionId = transactionId;
        _requestSignature = requestSignature;
    }
    return self;
}

-(NSMutableArray *)probesWithSample:(NSDictionary *)sample
                           protocol:(NSString *)protocol
{
    NSDictionary * providerData = [self.sample objectForKey:@"p"];
    int ownerZoneId = [[providerData objectForKey:@"z"] intValue];
    int ownerCustomerId = [[providerData objectForKey:@"c"] intValue];
    int providerId = [[providerData objectForKey:@"i"] intValue];
    NSDictionary * probesSection = [providerData objectForKey:@"p"];
    
    NSDictionary * protocolData;
    if ([self.protocol isEqualToString:@"https"]) {
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
        [probes addObject:[[CDXProbe alloc] initWithUrl:probeData[@"u"] ProbeId:1 ObjectType:[probeData[@"t"] intValue] zoneId:self.zoneId customerId:self.customerId ownerZoneId:ownerZoneId ownerCustomerId:ownerCustomerId providerId:providerId trasactionId:self.transactionId requestSignature:self.requestSignature]];
    }
    probeData = [protocolData objectForKey:@"b"];
    if (probeData) {
        [probes addObject:[[CDXProbe alloc] initWithUrl:[probeData objectForKey:@"u"] ProbeId:0 ObjectType:[[probeData objectForKey:@"t"] intValue] zoneId:self.zoneId customerId:self.customerId ownerZoneId:ownerZoneId ownerCustomerId:ownerCustomerId providerId:providerId trasactionId:self.transactionId requestSignature:self.requestSignature]];
    }
    probeData = [protocolData objectForKey:@"c"];
    if (probeData) {
        [probes addObject:[[CDXProbe alloc] initWithUrl:[probeData objectForKey:@"u"] ProbeId:14 ObjectType:[[probeData objectForKey:@"t"] intValue] zoneId:self.zoneId customerId:self.customerId ownerZoneId:ownerZoneId ownerCustomerId:ownerCustomerId providerId:providerId trasactionId:self.transactionId requestSignature:self.requestSignature]];
    }
    return probes;
}

-(void)measureWithCompletionHandler:(void (^)(NSError *))handler {
    NSMutableArray *probes = [self probesWithSample:self.sample protocol:self.protocol];
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
