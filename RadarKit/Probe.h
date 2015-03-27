//
//  Probe.h
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-27.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Probe : NSObject

-(id)initWithUrl:(NSString *)url
    ProbeId:(int)probeId
    ObjectType:(int)objectType;

-(BOOL)measureForZoneId:(int)zoneId
    CustomerId:(int)customerId
    OwnerZoneId:(int)ownerZoneId
    OwnerCustomerId:(int)ownerCustomerId
    ProviderId:(int)providerId
    TransactionId:(unsigned long)transactionId
    AndRequestSignature:(NSString *)requestSignature;

@property NSString * _url;
@property int _probeId;
@property int _objectType;

@end
