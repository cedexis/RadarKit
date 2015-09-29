//
//  Radar.h
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-26.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDXRadarSession.h"
#import "CDXImpact.h"

@class CDXRadarSession;

@interface CDXRadar : NSObject

NS_ASSUME_NONNULL_BEGIN

/**
 *  Your Cedexis zone.
 */
@property (assign, nonatomic) int zoneId;
/**
 *  Your Cedexis Customer ID. You can find it on https://portal.cedexis.com/ui/radar/tag
 */
@property (assign, nonatomic) int customerId;
/**
 *  Specify the protocol to use for the requests. Example: @@"http". Default is @@"https".
 */
@property (strong, nonatomic) NSString *protocol;
/**
 *  Set to YES if you want the library to log the status to the console.
 */
@property (assign, nonatomic) BOOL isVerbose;

/**
 *  Set to YES to always perform throughput measurements, regardless of the network type
 */
@property (assign, nonatomic) BOOL isThroughputMeasurementAlwaysOn;

/**
 *  Initialize the CDXRadar object with your zone and customer ID. If you don't know these, they can be obtained from the Cedexis portal: https://portal.cedexis.com/ui/radar/tag This page lists the standard Cedexis Radar JavaScript tag. Your zone ID and customer ID are embedded in the URL found in the tag. For example, if the tag shows the URL //radar.cedexis.com/1/12345/radar.js, then your zone ID is 1 and your customer ID is 12345.
 *
 *  @param zoneId     You Cedexis zone
 *  @param customerId Your Cedexis Customer ID
 *
 *  @return A CDXRadar object
 */
-(instancetype)initWithZoneId:(int)zoneId customerId:(int)customerId;

/**
 *  Initialize the CDXRadar object with your zone, customer ID and the protocol to be used. If you don't know these, they can be obtained from the Cedexis portal: https://portal.cedexis.com/ui/radar/tag This page lists the standard Cedexis Radar JavaScript tag. Your zone ID and customer ID are embedded in the URL found in the tag. For example, if the tag shows the URL //radar.cedexis.com/1/12345/radar.js, then your zone ID is 1 and your customer ID is 12345.
 *
 *  @param zoneId     You Cedexis zone
 *  @param customerId Your Cedexis Customer ID
 *
 *  @return A CDXRadar object
 */
-(instancetype)initWithZoneId:(int)zoneId customerId:(int)customerId protocol:(NSString *)protocol;

/**
 *  Starts a Radar session by making asynchronous requests without blocking the main thread.
 */
-(CDXRadarSession *)runInBackground;
/**
 *  Starts a Radar session by making asynchronous requests without blocking the main thread and executes a block when finished.
 *
 *  @param handler Block of code to execute when the Radar session has finished.
 */
-(CDXRadarSession *)runInBackgroundWithCompletionHandler:(nullable void(^)(NSError *error))handler;

NS_ASSUME_NONNULL_END
@end
