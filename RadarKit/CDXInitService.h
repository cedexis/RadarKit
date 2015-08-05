//
//  Init.h
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-26.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDXRadarSession.h"

@interface CDXInitService : NSObject<NSXMLParserDelegate>

-(void)getSignatureForSession:(CDXRadarSession *)radarProcess completionHandler:(void(^)(NSString *requestSignature, NSError *error))handler;

@end
