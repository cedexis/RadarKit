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

-(NSString *) urlWithProcess:(CDXRadarSession *)process {
    NSString * flag = @"i";
    if ([process.radar.protocol isEqualToString:@"https"]) {
        flag = @"s";
    }
    return [NSString stringWithFormat:@"%@://i1-io-%d-%d-%d-%d-%lu-%@.%@/i1/%lu/%lu/xml?seed=i1-io-%d-%d-%d-%d-%lu-%@",
            process.radar.protocol,
            majorVersion,
            minorVersion,
            process.radar.zoneId,
            process.radar.customerId,
            process.transactionId,
            flag,
            baseUrl,
            process.timestamp,
            process.transactionId,
            majorVersion,
            minorVersion,
            process.radar.zoneId,
            process.radar.customerId,
            process.transactionId,
            flag
    ];
}

-(void)getSignatureForSession:(CDXRadarSession *)process completionHandler:(void(^)(NSString *, NSError *))handler {
    NSURL * url = [NSURL URLWithString:[self urlWithProcess:process]];
    [[CDXLogger sharedInstance] log:url.description];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url
        cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20.0];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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
    [task resume];
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
