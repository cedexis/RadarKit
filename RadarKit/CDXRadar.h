//
//  Radar.h
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-26.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

@class CDXRadarSession;

NS_ASSUME_NONNULL_BEGIN
@interface CDXRadar : NSObject

/**
 *  Set to YES if you want the library to log the status to the console.
 */
@property (nonatomic) BOOL isVerbose;

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
-(CDXRadarSession *)runInBackgroundWithCompletionHandler:(nonnull void(^)(NSError * _Nullable error))handler;

@end
NS_ASSUME_NONNULL_END
