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

-(id)initWithUrl:(NSString *)url
         session:(CDXRadarSession *)session
         probeId:(int)probeId
      objectType:(int)objectType
     ownerZoneId:(int)ownerZoneId
 ownerCustomerId:(int)ownerCustomerId
      providerId:(int)providerId;

-(void)measureWithCompletionHandler:(void(^)(NSError *error))handler;
-(NSString *)reportUrlForResult:(int)result measurement:(int)measurement;
-(NSString *)probeUrl;

@property (strong, nonatomic) NSString * url;
@property (strong, nonatomic) CDXRadarSession *session;
@property (assign, nonatomic) int probeId;
@property (assign, nonatomic) int objectType;
@property (assign, nonatomic) int ownerZoneId;
@property (assign, nonatomic) int ownerCustomerId;
@property (assign, nonatomic) int providerId;

@end
