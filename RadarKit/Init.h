//
//  Init.h
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-26.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Init : NSObject<NSXMLParserDelegate>

- (id)initWithZoneId:(int)zoneId
          CustomerId:(int)customerId
           Timestamp:(unsigned long)timestamp
         AndProtocol:(NSString *)protocol;

-(void)makeRequestWithCompletionHandler:(void(^)(NSString *requestSignature, NSError *error))handler;

@property int _zoneId;
@property int _customerId;
@property int _majorVersion;
@property int _minorVersion;
@property unsigned long _initTimestamp;
@property unsigned long _transactionId;
@property NSString * _protocol;
@property NSString * _requestSignature;

@end
