//
//  Probe.m
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-27.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import "Probe.h"

@implementation Probe

@synthesize _url;
@synthesize _probeId;
@synthesize _objectType;

-(id)initWithUrl:(NSString *)url ProbeId:(int)probeId ObjectType:(int)objectType {
    if (self = [super init]) {
        self._url = url;
        self._probeId = probeId;
        self._objectType = objectType;
    }
    return self;
}

-(BOOL)measureForZoneId:(int)zoneId
             CustomerId:(int)customerId
            OwnerZoneId:(int)ownerZoneId
        OwnerCustomerId:(int)ownerCustomerId
             ProviderId:(int)providerId
          TransactionId:(unsigned long)transactionId
    AndRequestSignature:(NSString *)requestSignature {
    //NSLog(@"Hello Probe measure");
    
    NSString * rawUrl = [NSString
        stringWithFormat:@"%@?rnd=%d-%d-%d-%d-%d-%d-%lu-%@",
        self._url,
        self._probeId,
        zoneId,
        customerId,
        ownerZoneId,
        ownerCustomerId,
        providerId,
        transactionId,
        requestSignature
    ];
    NSLog(@"Probe URL: %@", rawUrl);
    NSURL * url = [NSURL URLWithString:self._url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
        cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
    timeoutInterval:20.0 ];
    
    NSHTTPURLResponse *response;
    NSError *error;
    NSDate *start = [NSDate date];
    NSData *data = [NSURLConnection
        sendSynchronousRequest:request returningResponse:&response error:&error ];
    
    if (data && (200 == [response statusCode])) {
        NSDate *end = [NSDate date];
        int elapsed = 1000 * [end timeIntervalSinceDate:start];
        NSLog(@"Elapsed: %ld", (long)elapsed);
        if (4000 > elapsed) {
            int measurement = elapsed;
            if (14 == self._probeId) {
                NSRegularExpression * expr = [NSRegularExpression regularExpressionWithPattern:@"(\\d+)kb\\." options:NSRegularExpressionCaseInsensitive error:&error];
                NSRange searchedRange = NSMakeRange(0, [self._url length]);
                NSArray *matches = [expr matchesInString:self._url options:0 range:searchedRange];
                NSTextCheckingResult * match = [matches objectAtIndex:0];
                NSRange group1 = [match rangeAtIndex:1];
                NSString * fileSize = [self._url substringWithRange:group1];
                int fileSizeHint = [fileSize intValue];
                measurement = 8 * 1000 * fileSizeHint / elapsed;
                NSLog(@"Thoughput: %d", measurement);
            }
            [self reportResult:0 Measurement:measurement OwnerZoneId:ownerZoneId OwnerCustomerId:ownerCustomerId
                ProviderId:providerId RequestSignature:requestSignature];
            return YES;
        }
        [self reportResult:1 Measurement:0 OwnerZoneId:ownerZoneId OwnerCustomerId:ownerCustomerId
            ProviderId:providerId RequestSignature:requestSignature];
        return NO;
    }
    [self reportResult:4 Measurement:0 OwnerZoneId:ownerZoneId OwnerCustomerId:ownerCustomerId
        ProviderId:providerId RequestSignature:requestSignature];
    return NO;
}

-(void)reportResult:(int)result
        Measurement:(int)measurement
        OwnerZoneId:(int)ownerZoneId
        OwnerCustomerId:(int)ownerCustomerId
        ProviderId:(int)providerId
        RequestSignature:(NSString *)requestSignature {
    NSString * rawUrl = [NSString
        stringWithFormat:@"http://rpt.cedexis.com/f1/%@/%d/%d/%d/%d/%d/%d/1/0",
        requestSignature,
        ownerZoneId,
        ownerCustomerId,
        providerId,
        self._probeId,
        result,
        measurement
    ];
    NSLog(@"Report URL: %@", rawUrl);
    
    NSURL * url = [NSURL URLWithString:rawUrl];
    NSURLRequest * request = [NSURLRequest
        requestWithURL:url
           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
       timeoutInterval:6.0 ];
    
    NSHTTPURLResponse *response;
    NSError * error;
    NSData * data = [NSURLConnection
        sendSynchronousRequest:request
             returningResponse:&response
                         error:&error];
            
    if (!data || (200 != [response statusCode])) {
        NSLog(@"Radar communication error (report)");
    }
}

@end
