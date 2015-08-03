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

-(NSString *) urlForProcess:(CDXRadarProcess *)process {
    return [NSString stringWithFormat:@"%@://radar.cedexis.com/%d/%d/radar/%lu/%@/providers.json?imagesok=1",
        process.radar.protocol,
        process.radar.zoneId,
        process.radar.customerId,
        process.timestamp,
        [self genRandStringLength:20]
    ];
}

-(void)requestSamplesForProcess:(CDXRadarProcess *)process completionHandler:(void(^)(NSArray *, NSError *))handler {
    NSURL * url = [NSURL URLWithString:[self urlForProcess:process]];
    [[CDXLogger sharedInstance] log:url.description];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
        cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSMutableArray *samples;
        if (error == nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if ((nil != data) && (200 == httpResponse.statusCode)) {
                
                samples = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            } else {
                [[CDXLogger sharedInstance] log:@"Radar communication error (ProbeServer)"];
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
