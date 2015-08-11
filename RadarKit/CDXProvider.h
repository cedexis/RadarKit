//
//  Provider.h
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-27.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDXRadarSession.h"

@interface CDXProvider : NSObject

@property (strong, nonatomic) NSDictionary * sample;
@property (strong, nonatomic) CDXRadarSession * session;

-(instancetype)initWithSample:(NSDictionary *)sample
            session:(CDXRadarSession *)process;

-(NSMutableArray *)probes;

-(void)measureWithCompletionHandler:(void(^)(NSError *error))handler;

@end
