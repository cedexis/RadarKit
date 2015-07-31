//
//  CDXLogger.m
//  RadarKit
//
//  Created by Javier Rosas on 7/31/15.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import "CDXLogger.h"

@implementation CDXLogger

+(instancetype)sharedInstance {
    static CDXLogger *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CDXLogger alloc] init];
        sharedInstance.isVerbose = NO;
    });
    return sharedInstance;
}

-(void)log:(nonnull NSString *)message {
    if (self.isVerbose) {
        NSLog(@"%@", message);
    }
}

@end
