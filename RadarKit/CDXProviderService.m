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

+(NSString *) urlForSession:(CDXRadarSession *)session {
    return [NSString stringWithFormat:@"%@://radar.cedexis.com/%d/%d/radar/%lu/%@/providers.json?imagesok=1&t=1",
        session.radar.protocol,
        session.radar.zoneId,
        session.radar.customerId,
        session.timestamp,
        [self randomStringWithLength:20]
    ];
}

-(void)requestSamplesForSession:(CDXRadarSession *)session completionHandler:(void(^)(NSArray *, NSError *))handler {
    NSURL * url = [NSURL URLWithString:[CDXProviderService urlForSession:session]];
    [[CDXLogger sharedInstance] log:url.description];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
        cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20.0];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPAdditionalHeaders = @{ @"User-Agent": session.userAgent };
    session.currentTask = [[NSURLSession sessionWithConfiguration:configuration] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSMutableArray *samples;
        if (error == nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if ((nil != data) && (200 == httpResponse.statusCode)) {
                samples = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                [[CDXLogger sharedInstance] log:[NSString stringWithFormat:@"Providers found: %lu", (unsigned long)samples.count]];
            } else {
                [[CDXLogger sharedInstance] log:@"Radar communication error (ProbeServer)"];
                NSDictionary *userInfo = nil;
                if (data) {
                    userInfo = @{ @"data": data };
                }
                error = [NSError errorWithDomain:@"RadarKit"
                                            code:httpResponse.statusCode
                                        userInfo:userInfo];
            }
        }
        if (handler) {
            handler(samples, error);
        }
    }];
    [session.currentTask resume];
}

// Generates alpha-numeric-random string
+ (NSString *)randomStringWithLength:(int)length {
    static NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: length];
    for (int i = 0; i < length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}

@end
