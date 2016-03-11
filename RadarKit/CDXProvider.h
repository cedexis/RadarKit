//
//  Provider.h
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-27.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

@class CDXProbe;

@interface CDXProvider : NSObject

-(instancetype)initWithRequestorZoneId:(int)requestorZoneId
                   requestorCustomerId:(int)requestorCustomerId
                         transactionId:(unsigned long)transactionId
                              protocol:(NSString *)protocol
                      requestSignature:(NSString *)requestSignature
                                sample:(NSDictionary *)sample;

-(CDXProbe *)getNextProbe;

@end
