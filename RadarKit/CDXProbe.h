//
//  Probe.h
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-27.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

@interface CDXProbe : NSObject

typedef NS_ENUM(int, CDXProbeId) {
    CDXProbeIdRTT = 0,
    CDXProbeIdCold = 1,
    CDXProbeIdThroughput = 14
};

typedef NS_ENUM(int, CDXProbeResult) {
    CDXProbeResultOK = 0,
    CDXProbeResultNotFound = 4,
    CDXProbeResultServerError = 1,
    CDXProbeResultTimeout = 1
};

@property (nonatomic, readonly) int probeTypeId;
@property (nonatomic, readonly) int providerOwnerZoneId;
@property (nonatomic, readonly) int providerOwnerCustomerId;
@property (nonatomic, readonly) int providerId;
@property (nonatomic) NSString *url;
@property (nonatomic, readonly) int objectTypeId;
@property (nonatomic, readonly) int requestorZoneId;
@property (nonatomic, readonly) int requestorCustomerId;
@property (nonatomic, readonly) unsigned long transactionId;
@property (nonatomic) NSString *requestSignature;

-(instancetype)initWithURL:(NSString *)url
           requestorZoneId:(int)requestorZoneId
       requestorCustomerId:(int)requestorCustomerId
       providerOwnerZoneId:(int)providerOwnerZoneId
   providerOwnerCustomerId:(int)providerOwnerCustomerId
                providerId:(int)providerId
               probeTypeId:(int)probeTypeId
              objectTypeId:(int)objectTypeId
             transactionId:(unsigned long)transactionId
          requestSignature:(NSString *)requestSignature;

-(NSString *)makeProbeURL;

@end
