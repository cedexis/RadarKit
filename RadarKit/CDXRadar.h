//
//  Radar.h
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-26.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDXRadar : NSObject

NS_ASSUME_NONNULL_BEGIN

@property (assign, nonatomic) int zoneId;
@property (assign, nonatomic) int customerId;
@property (strong, nonatomic) NSString *protocol;
@property (assign, nonatomic) BOOL isVerbose;

-(instancetype)initWithZoneId:(int)zoneId customerId:(int)customerId;
-(instancetype)initWithZoneId:(int)zoneId customerId:(int)customerId protocol:(NSString *)protocol;

-(void)runInBackground;
-(void)runInBackgroundWithCompletionHandler:(nullable void(^)(NSError *error))handler;

NS_ASSUME_NONNULL_END
@end
