//
//  CDXRadarProcess.m
//  RadarKit
//
//  Created by Javier Rosas on 8/3/15.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import "CDXRadarProcess.h"

@implementation CDXRadarProcess

- (instancetype)initWithRadar:(CDXRadar *)radar
{
    self = [super init];
    if (self) {
        _radar = radar;
        _timestamp = [[NSDate date] timeIntervalSince1970];
        self.transactionId = arc4random();
        self.requestSignature = nil;
    }
    return self;
}

-(void)cancel {
    @throw @"Not implemented";
}

@end
