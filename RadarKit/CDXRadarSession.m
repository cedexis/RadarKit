//
//  CDXRadarProcess.m
//  RadarKit
//
//  Created by Javier Rosas on 8/3/15.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import "CDXRadarSession.h"
#import <UIKit/UIKit.h>
@import CoreTelephony.CTTelephonyNetworkInfo;

@implementation CDXRadarSession

const NSString *libraryVersion = @"0.4.0";

-(instancetype)initWithZoneId:(int)zoneId
                   customerId:(int)customerId
                     protocol:(NSString *)protocol
            completionHandler:(CDXRadarSessionCompletionBlock)completionHandler {
    self = [super init];
    if (self) {
        _radarSessionCompletionHandler = completionHandler;
        _zoneId = zoneId;
        _customerId = customerId;
        _protocol = protocol;
        _isThroughputMeasurementAlwaysOn = NO;
        _timestamp = [[NSDate date] timeIntervalSince1970];
        _transactionId = arc4random();
        UIDevice *device = [UIDevice currentDevice];
        _userAgentString = [NSString stringWithFormat:@"RadarKit/%@ (%@; iOS %@; http://www.cedexis.com)", libraryVersion, device.model, device.systemVersion];
        _wasCancelled = NO;
        _networkSubtype = [self currentNetworkSubtype];
        _networkType = @"cellular";
        if ([_networkSubtype isEqualToString:@"wifi"]) {
            _networkType = @"wifi";
        }
        _providers = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)cancel {
    _wasCancelled = YES;
    [self.currentTask cancel];
}

-(NSString *)currentNetworkSubtype {
    CTTelephonyNetworkInfo *networkInfo = [CTTelephonyNetworkInfo new];
    NSString *subtype = networkInfo.currentRadioAccessTechnology;
    if (subtype) {
        return subtype;
    } else {
        return @"wifi";
    }
}

@end
