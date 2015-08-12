//
//  CDXRadarProcess.m
//  RadarKit
//
//  Created by Javier Rosas on 8/3/15.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import "CDXRadarSession.h"
#import <UIKit/UIKit.h>

@implementation CDXRadarSession

const NSString *libraryVersion = @"0.2.0";

- (instancetype)initWithRadar:(CDXRadar *)radar
{
    self = [super init];
    if (self) {
        _radar = radar;
        _timestamp = [[NSDate date] timeIntervalSince1970];
        _transactionId = arc4random();
        _requestSignature = nil;
        _userAgent = [self userAgentGenerate];
        _wasCancelled = NO;
    }
    return self;
}
    
-(NSString *)userAgentGenerate {
    UIDevice *device = [UIDevice currentDevice];
    return [NSString stringWithFormat:@"RadarKit/%@ (%@; iOS %@; http://www.cedexis.com)",
        libraryVersion,
        device.model,
        device.systemVersion];
}

-(void)cancel {
    _wasCancelled = YES;
    [self.currentTask cancel];
}

@end
