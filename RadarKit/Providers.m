//
//  Providers.m
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-27.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import "Providers.h"

@implementation Providers

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
    return [NSString stringWithFormat:@"%@://radar.cedexis.com/%d/%d/radar/%lu/%@/providers.json?imagesok=1",
        self._protocol,
        self._zoneId,
        self._customerId,
        self._timestamp,
        [self genRandStringLength:20]
    ];
}

-(void)requestProvidersWithCompletionHandler:(void(^)(NSArray *, NSError *))handler {
    NSURL * url = [NSURL URLWithString:[self url]];
    NSLog(@"%@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:url
        cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSMutableArray *samples;
        if (error == nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if ((nil != data) && (200 == httpResponse.statusCode)) {
                //NSLog(@"%@", data);
                
                samples = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            } else {
                NSLog(@"Radar communication error (ProbeServer)");
                error = [NSError errorWithDomain:@"RadarKit" code:httpResponse.statusCode userInfo:@{ data: data }];
            }
        }
        if (handler) {
            handler(samples, error);
        }
    }];
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
