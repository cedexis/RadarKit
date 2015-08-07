//
//  Probe.h
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-27.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDXRadarSession.h"

@interface CDXProbe : NSObject

typedef NS_ENUM(int, CDXProbeId) {
    CDXProbeIdRTT = 0,
    CDXProbeIdCold = 1,
    CDXProbeIdThroughput = 14
};

typedef NS_ENUM(int, CDXProbeResult) {
    CDXProbeResultOK = 0,
    CDXProbeResultNotFound = 4,
    CDXProbeResultServerError = 1
};

@property (strong, nonatomic) NSString * url;
@property (strong, nonatomic) CDXRadarSession *session;
@property (assign, nonatomic) CDXProbeId probeId;
@property (assign, nonatomic) int objectType;
@property (assign, nonatomic) int ownerZoneId;
@property (assign, nonatomic) int ownerCustomerId;
@property (assign, nonatomic) int providerId;

-(id)initWithSession:(CDXRadarSession *)session
                 url:(NSString *)url
         probeId:(CDXProbeId)probeId
      objectType:(int)objectType
     ownerZoneId:(int)ownerZoneId
 ownerCustomerId:(int)ownerCustomerId
      providerId:(int)providerId;

/**
 *  Performs the measurement and reports the results
 *
 *  @param handler Callback block
 */
-(void)measureWithCompletionHandler:(void(^)(NSError *error))handler;

/**
 *  Send report for measurement result
 *
 *  @param result      Result of the request
 *  @param measurement Data measured
 *  @param handler     Callback block
 */
-(void)reportWithResult:(CDXProbeResult)result
            measurement:(int)measurement
      completionHandler:(void(^)(NSError *error))handler;

/**
 *  Builds a URL that can be used for reporting a measurement
 *
 *  @param result      Measurement result code
 *  @param measurement Throughput measured
 *
 *  @return The URL as NSString
 */
-(NSString *)reportUrlForResult:(int)result
                    measurement:(int)measurement;

/**
 *  Builds a URL for measuring
 *
 *  @return The URL as NSString
 */
-(NSString *)probeUrl;

/**
 *  Gets the throughput in bits per second from an elapsed time in milliseconds
 *
 *  @param elapsed Elapsed time in milliseconds
 *
 *  @return Throuput measurement
 */
+(int)throughputForUrl:(NSString *)url
               elapsed:(int)elapsed;

@end
