//
//  Provider.h
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-27.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDXProvider : NSObject

-(id)initWithSample:(NSDictionary *)sample
           protocol:(NSString *)protocol
               zone:(int)zoneId customerId:(int)customerId
      transactionId:(unsigned long)transactionId
   requestSignature:(NSString *)requestSignature;

-(void)measureWithCompletionHandler:(void(^)(NSError *error))handler;

@property (strong, nonatomic) NSDictionary * sample;
@property (strong, nonatomic) NSString * protocol;
@property (assign, nonatomic) int zoneId;
@property (assign, nonatomic) int customerId;
@property (assign, nonatomic) unsigned long transactionId;
@property (strong, nonatomic) NSString *requestSignature;


@end
