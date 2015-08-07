//
//  Probe.m
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-27.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import "CDXProbe.h"
#import "CDXLogger.h"

@implementation CDXProbe

const int MILLISECONDS_IN_ONE_SECOND = 1000;
const int BITS_IN_ONE_BYTE = 8;

-(id)initWithSession:(CDXRadarSession *)session
                 url:(NSString *)url
             probeId:(CDXProbeId)probeId
          objectType:(int)objectType
         ownerZoneId:(int)ownerZoneId
     ownerCustomerId:(int)ownerCustomerId
          providerId:(int)providerId
{
    if (self = [super init]) {
        _url = url;
        _session = session;
        _probeId = probeId;
        _objectType = objectType;
        _ownerZoneId = ownerZoneId;
        _ownerCustomerId = ownerCustomerId;
        _providerId = providerId;
    }
    return self;
}

-(NSString *)probeUrl {
    return [NSString
        stringWithFormat:@"%@?rnd=%d-%d-%d-%d-%d-%d-%lu-%@",
        self.url,
        self.probeId,
        self.session.radar.zoneId,
        self.session.radar.customerId,
        self.ownerZoneId,
        self.ownerCustomerId,
        self.providerId,
        self.session.transactionId,
        self.session.requestSignature
    ];
}

-(void)measureWithCompletionHandler:(void(^)(NSError *))handler {
    NSString * probeUrl = self.probeUrl;
    [[CDXLogger sharedInstance] log:[NSString stringWithFormat:@"Probe URL: %@", probeUrl]];
    NSURL * url = [NSURL URLWithString:probeUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
        cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
    timeoutInterval:20.0 ];
    
    NSDate *start = [NSDate date];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            [self reportWithResult:CDXProbeResultNotFound measurement:0 completionHandler:^(NSError *errorAtReport) {
                        handler(error);
                    }];
            return;
        }
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        const int HTTP_OK = 200;
        if (!data || HTTP_OK != httpResponse.statusCode) {
            error = [NSError errorWithDomain:@"RadarKit" code:httpResponse.statusCode userInfo:@{ data: data }];
            [self reportWithResult:CDXProbeResultNotFound measurement:0 completionHandler:^(NSError *errorAtReport) {
                        handler(error);
                    }];
            return;
        }
        NSDate *end = [NSDate date];
        int elapsed = MILLISECONDS_IN_ONE_SECOND * [end timeIntervalSinceDate:start];
        [[CDXLogger sharedInstance] log:[NSString stringWithFormat:@"Elapsed: %ld", (long)elapsed]];
        if (elapsed >= 4000) {
            [self reportWithResult:CDXProbeResultServerError measurement:0 completionHandler:handler];
        }
        int measurement = elapsed;
        if (CDXProbeIdThroughput == self.probeId) {
            measurement = [CDXProbe throughputForUrl:self.url elapsed:elapsed];
            [[CDXLogger sharedInstance] log:[NSString stringWithFormat:@"Throughput: %d", measurement]];
        }
        [self reportWithResult:CDXProbeResultOK measurement:measurement completionHandler:handler];
    }];
    [task resume];
}

+(int)throughputForUrl:(NSString *)url elapsed:(int)elapsed {
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

-(NSString *)reportUrlForResult:(int)result measurement:(int)measurement {
    return [NSString
        stringWithFormat:@"http://rpt.cedexis.com/f1/%@/%d/%d/%d/%d/%d/%d/1/0",
        self.session.requestSignature,
        self.ownerZoneId,
        self.ownerCustomerId,
        self.providerId,
        self.probeId,
        result,
        measurement
    ];
}

-(void)reportWithResult:(CDXProbeResult)result
            measurement:(int)measurement
      completionHandler:(void(^)(NSError *error))handler {
    
    NSString * reportUrl = [self reportUrlForResult:result measurement:measurement];
    [[CDXLogger sharedInstance] log:[NSString stringWithFormat:@"Report URL: %@", reportUrl]];
    
    NSURL * url = [NSURL URLWithString:reportUrl];
    NSURLRequest * request = [NSURLRequest
        requestWithURL:url
           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
       timeoutInterval:6.0 ];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (!data || (200 != httpResponse.statusCode)) {
                error = [NSError errorWithDomain:@"RadarKit" code:httpResponse.statusCode userInfo:@{ data: data }];
            }
        }
        if (handler) {
            handler(error);
        }
    }];
    [task resume];
}

@end
