//
//  Provider.h
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-27.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Provider : NSObject

-(id)initWithSample:(NSDictionary *)sample
        ForProtocol:(NSString *)protocol;

-(void)measureForZone:(int)requestorZoneId
             Customer:(int)requestorCustomerId
        TransactionId:(unsigned long)transactionId
  AndRequestSignature:(NSString *)requestSignature;

@property NSDictionary * _sample;
@property NSString * _protocol;

@end
