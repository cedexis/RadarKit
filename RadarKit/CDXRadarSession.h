//
//  CDXRadarProcess.h
//  RadarKit
//
//  Created by Javier Rosas on 8/3/15.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

typedef void(^CDXRadarSessionCompletionBlock)(NSError * _Nullable);

@class CDXProvider;
@class CDXProbe;

@interface CDXRadarSession : NSObject

//@property (nonatomic) NSMutableDictionary *properties;
@property (nonatomic) NSString *protocol;
@property (nonatomic) int zoneId;
@property (nonatomic) int customerId;
@property (nonatomic) BOOL isThroughputMeasurementAlwaysOn;

@property (nonatomic) unsigned long timestamp;
@property (nonatomic) unsigned long transactionId;
@property (nonatomic) NSString * requestSignature;
@property (nonatomic, readonly) NSString *userAgentString;
@property (nonatomic) NSURLSessionDataTask *currentTask;
@property (nonatomic, readonly) BOOL wasCancelled;
@property (nonatomic) NSString *networkType;
@property (nonatomic) NSString *networkSubtype;
@property (nonatomic, copy) CDXRadarSessionCompletionBlock radarSessionCompletionHandler;

@property (nonatomic) NSMutableArray *providers;
@property (nonatomic) CDXProvider *currentProvider;
@property (nonatomic) CDXProbe *currentProbe;

-(instancetype)initWithZoneId:(int)zoneId
                   customerId:(int)customerId
                     protocol:(nonnull NSString *)protocol
            completionHandler:(CDXRadarSessionCompletionBlock)completionHandler;

-(void)cancel;

@end

NS_ASSUME_NONNULL_END
