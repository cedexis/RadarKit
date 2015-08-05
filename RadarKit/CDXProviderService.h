//
//  Providers.h
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-27.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDXInitService.h"
#import "CDXRadarSession.h"

@interface CDXProviderService : NSObject

-(void)requestSamplesForSession:(CDXRadarSession *)process completionHandler:(void(^)(NSArray *samples, NSError *error))handler;

@end
