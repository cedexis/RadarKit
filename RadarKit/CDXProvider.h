//
//  Provider.h
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-27.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDXRadarProcess.h"

@interface CDXProvider : NSObject

@property (strong, nonatomic) NSDictionary * sample;
@property (strong, nonatomic) CDXRadarProcess * process;

-(instancetype)initWithSample:(NSDictionary *)sample
            process:(CDXRadarProcess *)process;

-(void)measureWithCompletionHandler:(void(^)(NSError *error))handler;

@end
