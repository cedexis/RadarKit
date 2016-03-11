//
//  Probe.m
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-27.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import "CDXProbe.h"
#import "CDXLogger.h"
#import "CDXRadarSession+Processing.h"
#import "CDXRadar.h"
@import CoreTelephony.CTTelephonyNetworkInfo;

@implementation CDXProbe

//const int MILLISECONDS_IN_ONE_SECOND = 1000;
//const int BITS_IN_ONE_BYTE = 8;

-(instancetype)initWithURL:(NSString *)url
           requestorZoneId:(int)requestorZoneId
       requestorCustomerId:(int)requestorCustomerId
       providerOwnerZoneId:(int)providerOwnerZoneId
   providerOwnerCustomerId:(int)providerOwnerCustomerId
                providerId:(int)providerId
               probeTypeId:(int)probeTypeId
              objectTypeId:(int)objectTypeId
             transactionId:(unsigned long)transactionId
          requestSignature:(NSString *)requestSignature {
    self = [super init];
    if (self) {
        _url = url;
        _probeTypeId = probeTypeId;
        _objectTypeId = objectTypeId;
        _requestorZoneId = requestorZoneId;
        _requestorCustomerId = requestorCustomerId;
        _providerOwnerZoneId = providerOwnerZoneId;
        _providerOwnerCustomerId = providerOwnerCustomerId;
        _providerId = providerId;
        _transactionId = transactionId;
        _requestSignature = requestSignature;
    }
    return self;
}

-(NSString *)makeProbeURL {
    return [NSString
            stringWithFormat:@"%@?rnd=%d-%d-%d-%d-%d-%d-%lu-%@",
            self.url,
            self.probeTypeId,
            self.requestorZoneId,
            self.requestorCustomerId,
            self.providerOwnerZoneId,
            self.providerOwnerCustomerId,
            self.providerId,
            self.transactionId,
            self.requestSignature
            ];
}

@end
