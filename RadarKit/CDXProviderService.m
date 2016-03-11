//
//  Providers.m
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-27.
//  Copyright (c) 2015 Cedexis. All rights reserved.

#import "CDXProviderService.h"
#import "CDXLogger.h"
#import "CDXGlobals.h"
#import "CDXErrors.h"

@interface CDXProviderService()

@property (nonatomic, strong) CDXProviderServiceCompletionBlock serviceCompletionHandler;
@property (nonatomic) int zoneId;
@property (nonatomic) int customerId;
@property (nonatomic) unsigned long timestamp;
@property (nonatomic, strong) NSString *protocol;
@property (nonatomic, strong) NSString *userAgentString;

@end

@implementation CDXProviderService

-(instancetype)initWithSettings:(NSDictionary *)settings completionHandler:(CDXProviderServiceCompletionBlock)handler {
    self = [super init];
    if (self) {
        _serviceCompletionHandler = handler;
        _zoneId = [[settings objectForKey:@"zoneId"] intValue];
        _customerId = [[settings objectForKey:@"customerId"] intValue];
        _timestamp = [[settings objectForKey:@"timestamp"] unsignedLongValue];
        _protocol = [settings objectForKey:@"protocol"];
        _userAgentString = [settings objectForKey:@"userAgentString"];
    }
    return self;
}

-(NSString *)makeProvidersRequestURL {
    return [NSString stringWithFormat:@"%@://radar.cedexis.com/%d/%d/radar/%lu/%@/providers.json?imagesok=1&t=1",
            self.protocol,
            self.zoneId,
            self.customerId,
            self.timestamp,
            randomStringWithLength(20)];
};

-(CDXRequestCompletionBlock)makeTaskCompletionHandler {
    return ^(NSData *data, NSURLResponse *response, NSError *error) {
        [[CDXLogger sharedInstance] log:@"Providers request completed"];
        NSMutableArray *samples;
        if (!error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (data && 200 == httpResponse.statusCode) {
                samples = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                [[CDXLogger sharedInstance] log:[NSString stringWithFormat:@"Providers found: %lu", (unsigned long)samples.count]];
            } else {
                [[CDXLogger sharedInstance] log:@"Radar communication error (ProbeServer)"];
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                [userInfo setObject:[NSNumber numberWithInteger:httpResponse.statusCode]
                             forKey:@"httpResponseStatusCode"];
                [userInfo setObject:NSLocalizedString(@"Providers request error", nil)
                             forKey:NSLocalizedDescriptionKey];
                if (data) {
                    [userInfo setObject:data forKey:@"data"];
                }
                error = [NSError errorWithDomain:@"RadarKit"
                                            code:CDXErrorTypeProbesRequestCommunicationError
                                        userInfo:userInfo];
            }
        }
        if (self.serviceCompletionHandler) {
            self.serviceCompletionHandler(samples, error);
        }
    };
}

-(NSURLSessionDataTask *)requestSamples {
    NSURL *url = [NSURL URLWithString:[self makeProvidersRequestURL]];
    [[CDXLogger sharedInstance] log:url.description];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20.0];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    clearNSURLSessionConfiguration(configuration);
    configuration.HTTPAdditionalHeaders = @{ @"User-Agent": self.userAgentString };
    CDXRequestCompletionBlock requestCompletionHandler = [self makeTaskCompletionHandler];
    NSURLSessionDataTask *task = [[NSURLSession sessionWithConfiguration:configuration]
                                  dataTaskWithRequest:request
                                  completionHandler:requestCompletionHandler];
    [task resume];
    return task;
}

@end
