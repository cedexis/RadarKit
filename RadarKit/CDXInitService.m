//
//  Init.m
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-26.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import "CDXInitService.h"
#import "CDXLogger.h"

@interface CDXInitService()

@property NSString *currentValue;
@property NSString *requestSignature;

@end

@implementation CDXInitService

const int majorVersion = 0;
const int minorVersion = 2;
const NSString *baseUrl = @"init.cedexis-radar.net";

+(NSString *) urlWithSession:(CDXRadarSession *)session {
    NSString * flag = @"i";
    if ([session.radar.protocol isEqualToString:@"https"]) {
        flag = @"s";
    }
    return [NSString stringWithFormat:@"%@://i1-io-%d-%d-%d-%d-%lu-%@.%@/i1/%lu/%lu/xml?seed=i1-io-%d-%d-%d-%d-%lu-%@",
            session.radar.protocol,
            majorVersion,
            minorVersion,
            session.radar.zoneId,
            session.radar.customerId,
            session.transactionId,
            flag,
            baseUrl,
            session.timestamp,
            session.transactionId,
            majorVersion,
            minorVersion,
            session.radar.zoneId,
            session.radar.customerId,
            session.transactionId,
            flag
    ];
}

-(void)getSignatureForSession:(CDXRadarSession *)session completionHandler:(void(^)(NSString *, NSError *))handler {
    NSURL * url = [NSURL URLWithString:[CDXInitService urlWithSession:session]];
    [[CDXLogger sharedInstance] log:url.description];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url
        cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20.0];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPAdditionalHeaders = @{ @"User-Agent": session.userAgent };
    session.currentTask = [[NSURLSession sessionWithConfiguration:configuration] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if ((nil != data) && (200 == httpResponse.statusCode)) {
                NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
                [parser setDelegate:self];
                [parser parse];
            }
            else {
                [[CDXLogger sharedInstance] log:@"Radar communication error (init)"];
                error = [NSError errorWithDomain:@"RadarKit" code:httpResponse.statusCode userInfo:@{ data: data }];
            }
        }
        if (handler) {
            handler(self.requestSignature, error);
        }
    }];
    [session.currentTask resume];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"requestSignature"]) {
        self.requestSignature = self.currentValue;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    self.currentValue = string;
}

@end
