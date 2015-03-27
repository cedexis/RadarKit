//
//  Providers.m
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-27.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import "Providers.h"

@implementation Providers

@synthesize _zoneId;
@synthesize _customerId;
@synthesize _requestSignature;
@synthesize _timestamp;
@synthesize _protocol;
@synthesize _sample;

-(id)initWithZoneId:(int)zoneId CustomerId:(int)customerId RequestSignature:(NSString *)requestSignature Timestamp:(unsigned long)timestamp AndProtocol:(NSString *)protocol {
    if (self = [super init]) {
        self._zoneId = zoneId;
        self._customerId = customerId;
        self._requestSignature = requestSignature;
        self._timestamp = timestamp;
        self._protocol = protocol;
    }
    return self;
}

-(NSString *) url {
    return [NSString stringWithFormat:@"%@://radar.cedexis.com/%d/%d/radar/%lu/%@/providers.json",
        self._protocol,
        self._zoneId,
        self._customerId,
        self._timestamp,
        [self genRandStringLength:20]
    ];
}

-(BOOL)requestProviders {
    NSURL * url = [NSURL URLWithString:[self url]];
    NSLog(@"%@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url
        cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20.0];
    
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
        returningResponse:&response error:&error];
    
    if ((nil != data) && (200 == [response statusCode])) {
        //NSLog(@"%@", data);
        self._sample = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        return YES;
    }
    NSLog(@"Radar communication error (ProbeServer)");
    return NO;
}

// Generates alpha-numeric-random string
- (NSString *)genRandStringLength:(int)len {
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}

@end
