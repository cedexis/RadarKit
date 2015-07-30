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
      ObjectType:(int)objectType
          zoneId:(int)zoneId
      customerId:(int)customerId
     ownerZoneId:(int)ownerZoneId
 ownerCustomerId:(int)ownerCustomerId
      providerId:(int)providerId
    trasactionId:(unsigned long)transactionId
requestSignature:(NSString *)requestSignature;

-(void)measureWithCompletionHandler:(void(^)(NSError *error))handler;

@property NSString * url;
@property int probeId;
@property int objectType;
@property int zoneId;
@property int customerId;
@property int ownerZoneId;
@property int ownerCustomerId;
@property int providerId;
@property unsigned long transactionId;
@property NSString *requestSignature;

@end
