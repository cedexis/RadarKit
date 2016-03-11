//
//  Radar.m
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-26.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import "CDXRadar.h"
#import "CDXRadarSession.h"
#import "CDXRadarSession+Processing.h"
#import "CDXLogger.h"

@interface CDXRadar()

/**
 *  Your Cedexis zone.
 */
@property (nonatomic, readonly) int zoneId;
/**
 *  Your Cedexis Customer ID. You can find it on https://portal.cedexis.com/ui/radar/tag
 */
@property (nonatomic, readonly) int customerId;
/**
 *  Specify the protocol to use for the requests. Example: @@"http". Default is @@"https".
 */
@property (nonatomic, readonly) NSString *protocol;

/**
 *  Set to YES to always perform throughput measurements, regardless of the network type
 */
@property (nonatomic, readonly) BOOL isThroughputMeasurementAlwaysOn;

@end

@implementation CDXRadar

-(instancetype)initWithZoneId:(int)zoneId customerId:(int)customerId {
    return [self initWithZoneId:zoneId customerId:customerId protocol:@"https"];
}

-(instancetype)initWithZoneId:(int)zoneId customerId:(int)customerId protocol:(NSString *)protocol {
    self = [super init];
    if (self) {
        _zoneId = zoneId;
        _customerId = customerId;
        _protocol = protocol;
        _isThroughputMeasurementAlwaysOn = NO;
        _isVerbose = NO;
    }
    return self;
}

# pragma mark - Public methods

-(CDXRadarSession *)runInBackground {
    return [self runInBackgroundWithCompletionHandler:^(NSError *error) {
        // Do nothing
    }];
}

-(CDXRadarSession *)runInBackgroundWithCompletionHandler:(CDXRadarSessionCompletionBlock)handler {
    CDXRadarSession *session = [[CDXRadarSession alloc] initWithZoneId:self.zoneId
                                                            customerId:self.customerId
                                                              protocol:self.protocol
                                                     completionHandler:handler];
    [session startAsynchronousProcessing];
    return session;
}

# pragma mark - Custom setters

-(void)setIsVerbose:(BOOL)isVerbose {
    _isVerbose = isVerbose;
    [CDXLogger sharedInstance].isVerbose = isVerbose;
}

# pragma mark - Private methods

@end
