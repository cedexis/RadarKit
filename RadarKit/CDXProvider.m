//
//  Provider.m
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-27.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import "CDXProvider.h"
#import "CDXProbe.h"
#import "CDXGlobals.h"

@interface CDXProvider()

@property (nonatomic, strong) NSMutableArray *probes;

@end

@implementation CDXProvider

-(instancetype)initWithRequestorZoneId:(int)requestorZoneId
                   requestorCustomerId:(int)requestorCustomerId
                         transactionId:(unsigned long)transactionId
                              protocol:(NSString *)protocol
                      requestSignature:(NSString *)requestSignature
                                sample:(NSDictionary *)sample {
    self = [super init];
    if (self) {
        _probes = [self makeProbesForSample:sample
                                   protocol:protocol
                            requestorZoneId:requestorZoneId
                        requestorCustomerId:requestorCustomerId
                              transactionId:transactionId
                           requestSignature:requestSignature];
    }
    return self;
}

-(NSMutableArray *)makeProbesForSample:(NSDictionary *)sample
                              protocol:(NSString *)protocol
                       requestorZoneId:(int)requestorZoneId
                   requestorCustomerId:(int)requestorCustomerId
                         transactionId:(unsigned long)transactionId
                      requestSignature:(NSString *)requestSignature {
    NSDictionary *providerData = [sample objectForKey:@"p"];
    id ownerZoneId = [providerData objectForKey:@"z"];
    id ownerCustomerId = [providerData objectForKey:@"c"];
    id providerId = [providerData objectForKey:@"i"];
    NSDictionary *probesSection = [providerData objectForKey:@"p"];
    
    NSDictionary *protocolData;
    if ([protocol isEqualToString:@"https"]) {
        protocolData = [probesSection objectForKey:@"b"];
        if (!protocolData) {
            protocolData = [probesSection objectForKey:@"a"];
        }
    } else {
        protocolData = [probesSection objectForKey:@"a"];
    }
    
    NSMutableArray * probes = [NSMutableArray array];
    
    // Cold probe
    NSDictionary *probeData;
    probeData = [protocolData objectForKey:@"a"];
    if (probeData) {
        [probes addObject:[[CDXProbe alloc] initWithURL:[probeData objectForKey:@"u"]
                                        requestorZoneId:requestorZoneId
                                    requestorCustomerId:requestorCustomerId
                                    providerOwnerZoneId:[ownerZoneId intValue]
                                providerOwnerCustomerId:[ownerCustomerId intValue]
                                             providerId:[providerId intValue]
                                            probeTypeId:CDXProbeIdCold
                                           objectTypeId:[[probeData objectForKey:@"t"] intValue]
                                          transactionId:transactionId
                                       requestSignature:requestSignature]];
    }
    probeData = [protocolData objectForKey:@"b"];
    if (probeData) {
        [probes addObject:[[CDXProbe alloc] initWithURL:[probeData objectForKey:@"u"]
                                        requestorZoneId:requestorZoneId
                                    requestorCustomerId:requestorCustomerId
                                    providerOwnerZoneId:[ownerZoneId intValue]
                                providerOwnerCustomerId:[ownerCustomerId intValue]
                                             providerId:[providerId intValue]
                                            probeTypeId:CDXProbeIdRTT
                                           objectTypeId:[[probeData objectForKey:@"t"] intValue]
                                          transactionId:transactionId
                                       requestSignature:requestSignature]];
    }
    probeData = [protocolData objectForKey:@"c"];
    if (probeData) {
        [probes addObject:[[CDXProbe alloc] initWithURL:[probeData objectForKey:@"u"]
                                        requestorZoneId:requestorZoneId
                                    requestorCustomerId:requestorCustomerId
                                    providerOwnerZoneId:[ownerZoneId intValue]
                                providerOwnerCustomerId:[ownerCustomerId intValue]
                                             providerId:[providerId intValue]
                                            probeTypeId:CDXProbeIdThroughput
                                           objectTypeId:[[probeData objectForKey:@"t"] intValue]
                                          transactionId:transactionId
                                       requestSignature:requestSignature]];
    }
    return probes;
}

-(CDXProbe *)getNextProbe {
    if (0 < self.probes.count) {
        id probe = self.probes.firstObject;
        [self.probes removeObjectAtIndex:0];
        return probe;
    }
    return nil;
}

@end
