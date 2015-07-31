//
//  Radar.h
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-26.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDXRadar : NSObject

@property (assign, nonatomic) int zoneId;
@property (assign, nonatomic) int customerId;
@property (strong, nonatomic) NSString *protocol;

-(instancetype)initWithZoneId:(int)zoneId customerId:(int)customerId;

-(void)runInBackground;
-(void)runInBackgroundWithCompletionHandler:(void(^)(NSError *error))handler;

@end
