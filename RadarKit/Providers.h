//
//  Providers.h
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-27.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Providers : NSObject

-(id)initWithZoneId:(int)zoneId
         CustomerId:(int)customerId
   RequestSignature:(NSString *)requestSignature
          Timestamp:(unsigned long)timestamp
        AndProtocol:(NSString *)protocol;

-(void)requestProvidersWithCompletionHandler:(void(^)(NSArray *samples, NSError *error))handler;

@property int _zoneId;
@property int _customerId;
@property NSString * _requestSignature;
@property unsigned long _timestamp;
@property NSString * _protocol;

@end
