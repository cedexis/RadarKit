//
//  Radar.h
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-26.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Radar : NSObject

-(void)runForZoneId:(int)zoneId
         CustomerId:(int)customerId;

-(void)runForZoneId:(int)zoneId
         CustomerId:(int)customerId
        AndProtocol:(NSString *)protocol;

@end
