//
//  Init.h
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-26.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDXRadarProcess.h"

@interface CDXInitService : NSObject<NSXMLParserDelegate>

-(void)getSignatureForProcess:(CDXRadarProcess *)radarProcess completionHandler:(void(^)(NSString *requestSignature, NSError *error))handler;

@end
