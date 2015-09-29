//
//  CDXImpactMeasurement.h
//  RadarKit
//
//  Created by Javier Rosas on 9/23/15.
//  Copyright © 2015 Cedexis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDXImpactMeasurement : NSObject

@property (strong, nonatomic, readonly) NSDate *startingTime;
@property (strong, nonatomic, readonly) NSDate *endingTime;

-(void)end;
-(NSUInteger)duration;

@end
