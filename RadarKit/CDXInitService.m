//
//  Init.m
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-26.
//  Copyright (c) 2015 Cedexis. All rights reserved.

#import "CDXInitService.h"
#import "CDXLogger.h"
#import "CDXErrors.h"
#import "CDXGlobals.h"

@interface CDXInitService()

@property (nonatomic, strong) CDXInitServiceCompletionBlock serviceCompletionHandler;
@property (nonatomic, strong) NSString *protocol;
@property (nonatomic) int zoneId;
@property (nonatomic) int customerId;
@property (nonatomic) unsigned long timestamp;
@property (nonatomic) unsigned long transactionId;
@property (nonatomic, strong) NSString *userAgentString;

@end

@implementation CDXInitService

const int majorVersion = 0;
const int minorVersion = 4;
const NSString *baseUrl = @"init.cedexis-radar.net";

-(instancetype)initWithSettings:(NSDictionary *)settings
              completionHandler:(CDXInitServiceCompletionBlock)handler {
    self = [super init];
    if (self) {
        _serviceCompletionHandler = handler;
        _zoneId = [[settings objectForKey:@"zoneId"] intValue];
        _customerId = [[settings objectForKey:@"customerId"] intValue];
        _timestamp = [[settings objectForKey:@"timestamp"] unsignedLongValue];
        _transactionId = [[settings objectForKey:@"transactionId"] unsignedLongValue];
        _protocol = [settings objectForKey:@"protocol"];
        _userAgentString = [settings objectForKey:@"userAgentString"];
    }
    return self;
}

-(NSString *)makeInitURL {
    NSString * flag = @"i";
    if ([self.protocol isEqualToString:@"https"]) {
        flag = @"s";
    }
    return [NSString stringWithFormat:@"%@://i1-io-%d-%d-%d-%d-%lu-%@.%@/i1/%lu/%lu/json?seed=i1-io-%d-%d-%d-%d-%lu-%@",
            self.protocol,
            majorVersion,
            minorVersion,
            self.zoneId,
            self.customerId,
            self.transactionId,
            flag,
            baseUrl,
            self.timestamp,
            self.transactionId,
            majorVersion,
            minorVersion,
            self.zoneId,
            self.customerId,
            self.transactionId,
            flag];
}

-(NSURLSessionDataTask *)beginInitRequest {
    NSURL *url = [NSURL URLWithString:[self makeInitURL]];
    [[CDXLogger sharedInstance] log:url.description];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:20.0];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    clearNSURLSessionConfiguration(configuration);
    configuration.HTTPAdditionalHeaders = @{ @"User-Agent": self.userAgentString };
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [urlSession dataTaskWithRequest:request completionHandler:[self makeInitTaskCompletionHandler]];
    [task resume];
    return task;
}

-(CDXRequestCompletionBlock)makeInitTaskCompletionHandler {
    return ^(NSData *data,
             NSURLResponse *response,
             NSError *error) {
        [[CDXLogger sharedInstance] log:@"Init request complete"];
        NSString *requestSignature;
        if (!error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (data && (200 == httpResponse.statusCode)) {
                NSError *jsonError;
                NSMutableDictionary *temp = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (temp) {
                    requestSignature = [temp objectForKey:@"a"];
                }
            } else {
                [[CDXLogger sharedInstance] log:@"Radar communication error (init)"];
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                [userInfo setObject:[NSNumber numberWithInteger:httpResponse.statusCode]
                             forKey:@"httpResponseStatusCode"];
                [userInfo setObject:NSLocalizedString(@"Radar init error", nil) forKey:NSLocalizedDescriptionKey];
                if (data) {
                    [userInfo setObject:data forKey:@"data"];
                }
                error = [NSError errorWithDomain:@"RadarKit"
                                            code:CDXErrorTypeInitCommunicationError
                                        userInfo:userInfo];
            }
        }
        if (self.serviceCompletionHandler) {
            self.serviceCompletionHandler(requestSignature, error);
        }
    };
};

@end
