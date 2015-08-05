//
//  CDXRadarProcess.h
//  RadarKit
//
//  Created by Javier Rosas on 8/3/15.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDXRadar.h"

@class CDXRadar;

@interface CDXRadarSession : NSObject

@property (strong, nonatomic) CDXRadar *radar;
@property (assign, nonatomic) unsigned long timestamp;
@property (assign, nonatomic) unsigned long transactionId;
@property (strong, nonatomic) NSString * requestSignature;

- (instancetype)initWithRadar:(CDXRadar *)radar;

- (void)cancel;

@end
