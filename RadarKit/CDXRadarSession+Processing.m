//
//  CDXRadarSession+Processing.m
//  RadarKit
//
//  Created by Jacob Wan on 2016-03-08.
//  Copyright © 2016 Cedexis. All rights reserved.
//

#import "CDXRadarSession+Processing.h"
#import "CDXLogger.h"
#import "CDXInitService.h"
#import "CDXProviderService.h"
#import "CDXProvider.h"
#import "CDXProbe.h"
#import "CDXGlobals.h"

const int MILLISECONDS_IN_ONE_SECOND = 1000;
const int BITS_IN_ONE_BYTE = 8;

@implementation CDXRadarSession (Processing)

-(void)startAsynchronousProcessing {
    [[CDXLogger sharedInstance] log:@"startAsynchronousProcessing"];
    NSDictionary *initSettings = @{
                                   @"zoneId": [NSNumber numberWithInteger:self.zoneId],
                                   @"customerId": [NSNumber numberWithInteger:self.customerId],
                                   @"timestamp": [NSNumber numberWithUnsignedLong:self.timestamp],
                                   @"transactionId": [NSNumber numberWithUnsignedLong:self.transactionId],
                                   @"protocol": self.protocol,
                                   @"userAgentString": self.userAgentString
                                   };
    CDXInitServiceCompletionBlock initServiceCompletionHandler = [self makeInitServiceCompletionBlock];
    CDXInitService *initService = [[CDXInitService alloc] initWithSettings:initSettings
                                                         completionHandler:initServiceCompletionHandler];
    self.currentTask = [initService beginInitRequest];
}

-(CDXInitServiceCompletionBlock)makeInitServiceCompletionBlock {
    return ^(NSString *requestSignature, NSError *initRequestError) {
        if (requestSignature) {
            [[CDXLogger sharedInstance] log:[NSString stringWithFormat:@"Got request signature: %@", requestSignature]];
            self.requestSignature = requestSignature;
            [self beginProvidersRequest];
        } else {
            if (self.radarSessionCompletionHandler) {
                self.radarSessionCompletionHandler(initRequestError);
            }
        }
    };
}

-(void)beginProvidersRequest {
    NSDictionary *providersServiceSettings = @{
                                               @"zoneId": [NSNumber numberWithInt:self.zoneId],
                                               @"customerId": [NSNumber numberWithInt:self.customerId],
                                               @"timestamp": [NSNumber numberWithUnsignedLong:self.timestamp],
                                               @"protocol": self.protocol,
                                               @"userAgentString": self.userAgentString
                                               };
    CDXProviderServiceCompletionBlock serviceCompleteBlock = [self makeProviderServiceCompletionBlock];
    CDXProviderService *providerService = [[CDXProviderService alloc]
                                           initWithSettings:providersServiceSettings
                                           completionHandler:serviceCompleteBlock];
    self.currentTask = [providerService requestSamples];
}

-(CDXProviderServiceCompletionBlock)makeProviderServiceCompletionBlock {
    return ^(NSArray *samples, NSError *providerServiceError) {
        [[CDXLogger sharedInstance] log:@"Provider service complete"];
        if (providerServiceError) {
            if (self.radarSessionCompletionHandler) {
                self.radarSessionCompletionHandler(providerServiceError);
            }
        } else {
            // Produce an array of CDXProvider objects
            for (NSDictionary * providerData in samples) {
                [self.providers addObject:[[CDXProvider alloc] initWithRequestorZoneId:self.zoneId
                                                                   requestorCustomerId:self.customerId
                                                                         transactionId:self.transactionId
                                                                              protocol:self.protocol
                                                                      requestSignature:self.requestSignature
                                                                                sample:providerData]];
            }
            [self measureNextProvider];
        }
    };
}

-(void)measureNextProvider {
    if (0 < self.providers.count) {
        id provider = self.providers.firstObject;
        [self.providers removeObjectAtIndex:0];
        self.currentProvider = provider;
        [self measureNextProbe];
    } else {
        if (self.radarSessionCompletionHandler) {
            // The Radar session completed successfully
            self.radarSessionCompletionHandler(nil);
        }
    }
};

-(void)measureNextProbe {
    CDXProbe *probe = [self.currentProvider getNextProbe];
    if (probe) {
        self.currentProbe = probe;
        [self measureProbe:probe];
    } else {
        [self measureNextProvider];
    }
}

-(void)measureProbe:(CDXProbe *)probe {
    if (probe.probeTypeId == CDXProbeIdThroughput
        && !self.isThroughputMeasurementAlwaysOn
        && ![self.networkType isEqualToString:@"wifi"]) {
        [[CDXLogger sharedInstance] log:[NSString stringWithFormat:@"Probe skipped because device is not on WiFi"]];
        [self measureNextProbe];
        return;
    }
    NSString *probeURL = [probe makeProbeURL];
    [[CDXLogger sharedInstance] log:[NSString stringWithFormat:@"Probe URL: %@", probeURL]];
    NSURL *url = [NSURL URLWithString:probeURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:20.0];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    clearNSURLSessionConfiguration(configuration);
    configuration.HTTPAdditionalHeaders = @{ @"User-Agent": self.userAgentString };
    CDXRequestCompletionBlock handler = [self makeProbeRequestCompletionHandlerWithStartTimestamp:[NSDate date]];
    NSURLSessionDataTask *task = [[NSURLSession sessionWithConfiguration:configuration]
                                  dataTaskWithRequest:request
                                  completionHandler:handler];
    self.currentTask = task;
    [task resume];
}

-(CDXRequestCompletionBlock)makeProbeRequestCompletionHandlerWithStartTimestamp:(NSDate *)startTime {
    return ^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDate *endTime = [NSDate date];
        if (error) {
            [self reportWithResult:CDXProbeResultNotFound measurement:0];
            [self measureNextProvider];
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (data && 200 == httpResponse.statusCode) {
                int elapsed = MILLISECONDS_IN_ONE_SECOND * [endTime timeIntervalSinceDate:startTime];
                [[CDXLogger sharedInstance] log:[NSString stringWithFormat:@"Elapsed: %ld", (long)elapsed]];
                if (4000 <= elapsed) {
                    [self reportWithResult:CDXProbeResultTimeout measurement:0];
                    [self measureNextProvider];
                } else {
                    int measurement = elapsed;
                    if (CDXProbeIdThroughput == self.currentProbe.probeTypeId) {
                        measurement = [CDXRadarSession throughputForURL:self.currentProbe.url elapsed:elapsed];
                        [[CDXLogger sharedInstance] log:[NSString stringWithFormat:@"Throughput: %d", measurement]];
                    }
                    [self reportWithResult:CDXProbeResultOK measurement:measurement];
                    [self measureNextProbe];
                }
            } else {
                [[CDXLogger sharedInstance] log:[NSString stringWithFormat:@"Error downloading probe; HTTP Status %ld (%@); Data: %@",
                                                 (long)httpResponse.statusCode,
                                                 [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode],
                                                 data]];
                [self reportWithResult:CDXProbeResultNotFound measurement:0];
                [self measureNextProvider];
            }
        }
    };
};

-(void)reportWithResult:(CDXProbeResult)resultCode
            measurement:(int)measurement {
    NSString * reportUrl = [self makeReportURLForResult:resultCode measurement:measurement];
    [[CDXLogger sharedInstance] log:[NSString stringWithFormat:@"Report URL: %@", reportUrl]];
    NSURL *url = [NSURL URLWithString:reportUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:20.0];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    clearNSURLSessionConfiguration(configuration);
    configuration.HTTPAdditionalHeaders = @{
                                            @"User-Agent": self.userAgentString,
                                            @"Cedexis-iOS-Network-Type": self.networkType,
                                            @"Cedexis-iOS-Network-Subtype": self.networkSubtype
                                            };
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    CDXRequestCompletionBlock handler = [self makeReportCompletionBlock];
    [[session dataTaskWithRequest:request completionHandler:handler] resume];
}

-(CDXRequestCompletionBlock)makeReportCompletionBlock {
    return ^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (error) {
            [[CDXLogger sharedInstance] log:[NSString stringWithFormat:@"Error sending Radar report:\n%@", error]];
        } else {
            if (data && 200 == httpResponse.statusCode) {
//                [[CDXLogger sharedInstance] log:@"Radar report sent successfully"];
            } else {
                [[CDXLogger sharedInstance] log:[NSString stringWithFormat:@"Unexpected response sending Radar report; HTTP Status %ld (%@); Data: %@",
                                                 (long)httpResponse.statusCode,
                                                 [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode],
                                                 data]];
            }
        }
    };
}

-(NSString *)makeReportURLForResult:(int)resultCode measurement:(int)measurement {
    return [NSString
            stringWithFormat:@"%@://rpt.cedexis.com/f1/%@/%d/%d/%d/%d/%d/%d/1/0",
            self.protocol,
            self.requestSignature,
            self.currentProbe.providerOwnerZoneId,
            self.currentProbe.providerOwnerCustomerId,
            self.currentProbe.providerId,
            self.currentProbe.probeTypeId,
            resultCode,
            measurement];
}

+(int)throughputForURL:(NSString *)url elapsed:(int)elapsed {
    NSError *error;
    NSRegularExpression * expr = [NSRegularExpression regularExpressionWithPattern:@"(\\d+)kb\\." options:NSRegularExpressionCaseInsensitive error:&error];
    NSRange searchedRange = NSMakeRange(0, [url length]);
    NSArray *matches = [expr matchesInString:url options:0 range:searchedRange];
    NSTextCheckingResult * match = [matches objectAtIndex:0];
    NSRange group1 = [match rangeAtIndex:1];
    NSString * fileSize = [url substringWithRange:group1];
    int fileSizeHint = [fileSize intValue];
    return BITS_IN_ONE_BYTE * MILLISECONDS_IN_ONE_SECOND * fileSizeHint / elapsed;
}

@end
