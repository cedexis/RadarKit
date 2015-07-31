//
//  CDXLogger.h
//  RadarKit
//
//  Created by Javier Rosas on 7/31/15.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDXLogger : NSObject

@property (assign, nonatomic) BOOL isVerbose;

+(instancetype)sharedInstance;

-(void)log:(NSString *)message;

@end
