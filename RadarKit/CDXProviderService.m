//
//  Providers.m
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-27.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import "CDXProviderService.h"
#import "CDXLogger.h"

@implementation CDXProviderService

-(NSString *) urlForProcess:(CDXRadarSession *)process {
    return [NSString stringWithFormat:@"%@://radar.cedexis.com/%d/%d/radar/%lu/%@/providers.json?imagesok=1",
        process.radar.protocol,
        process.radar.zoneId,
        process.radar.customerId,
        process.timestamp,
        [self genRandStringLength:20]
    ];
}

-(void)requestSamplesForSession:(CDXRadarSession *)process completionHandler:(void(^)(NSArray *, NSError *))handler {
    NSURL * url = [NSURL URLWithString:[self urlForProcess:process]];
    [[CDXLogger sharedInstance] log:url.description];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
        cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20.0];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSMutableArray *samples;
        if (error == nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if ((nil != data) && (200 == httpResponse.statusCode)) {
                samples = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                [[CDXLogger sharedInstance] log:[NSString stringWithFormat:@"Providers found: %lu", (unsigned long)samples.count]];
            } else {
                [[CDXLogger sharedInstance] log:@"Radar communication error (ProbeServer)"];
                error = [NSError errorWithDomain:@"RadarKit" code:httpResponse.statusCode userInfo:@{ data: data }];
            }
        }
        if (handler) {
            handler(samples, error);
        }
    }];
    [task resume];
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
