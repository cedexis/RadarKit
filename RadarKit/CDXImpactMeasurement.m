//
//  CDXImpactMeasurement.m
//  RadarKit
//
//  Created by Javier Rosas on 9/23/15.
//  Copyright © 2015 Cedexis. All rights reserved.
//

#import "CDXImpactMeasurement.h"

@implementation CDXImpactMeasurement

const unsigned int MILLISECONDS_IN_A_SECOND = 1000;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _startingTime = [NSDate date];
    }
    return self;
}

- (void)end {
    if (!_endingTime) {
        _endingTime = [NSDate date];
    }
}

-(NSUInteger)duration {
    if (_startingTime && _endingTime) {
        double intervalInSeconds = [_endingTime timeIntervalSinceDate:_startingTime];
        NSUInteger intervalInMilliseconds = intervalInSeconds * MILLISECONDS_IN_A_SECOND;
        return intervalInMilliseconds;
    } else {
        return 0;
    }
}

@end
