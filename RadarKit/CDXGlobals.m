//
//  CDXGlobals.m
//  RadarKit
//
//  Created by Jacob Wan on 2016-03-09.
//  Copyright © 2016 Cedexis. All rights reserved.
//

#import "CDXGlobals.h"

NSString * randomStringWithLength(int length) {
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: length];
    for (int i = 0; i < length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}

void clearNSURLSessionConfiguration(NSURLSessionConfiguration *config) {
    config.URLCredentialStorage = nil;
    config.HTTPCookieStorage = nil;
    config.URLCache = nil;
    config.HTTPShouldSetCookies = NO;
}
