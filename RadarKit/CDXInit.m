//
//  Init.m
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-26.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import "CDXInit.h"
#import "CDXLogger.h"

@interface CDXInit()
@property NSString * _currentValue;
@end

@implementation CDXInit

-(id)initWithZoneId:(int)zoneId CustomerId:(int)customerId Timestamp:(unsigned long)timestamp AndProtocol:(NSString *)protocol {
    if (self = [super init]) {
        self._zoneId = zoneId;
        self._customerId = customerId;
        self._majorVersion = 0;
        self._minorVersion = 2;
        self._initTimestamp = timestamp;
        self._transactionId = arc4random();
        self._protocol = protocol;
        self._requestSignature = nil;
    }
    return self;
}

-(NSString *) url {
    NSString * flag = @"i";
    if ([self._protocol isEqualToString:@"https"]) {
        flag = @"s";
    }
    return [NSString stringWithFormat:@"%@://i1-io-%d-%d-%d-%d-%lu-%@.%@/i1/%lu/%lu/xml?seed=i1-io-%d-%d-%d-%d-%lu-%@",
            self._protocol,
            self._majorVersion,
            self._minorVersion,
            self._zoneId,
            self._customerId,
            self._transactionId,
            flag,
            @"init.cedexis-radar.net",
            self._initTimestamp,
            self._transactionId,
            self._majorVersion,
            self._minorVersion,
            self._zoneId,
            self._customerId,
            self._transactionId,
            flag
    ];
}

-(void)makeRequestWithCompletionHandler:(void(^)(NSString *, NSError *))handler {
    NSURL * url = [NSURL URLWithString:[self url]];
    [[CDXLogger sharedInstance] log:url.description];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url
        cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:20.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
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
            handler(self._requestSignature, error);
        }
    }];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"requestSignature"]) {
        self._requestSignature = self._currentValue;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    self._currentValue = string;
}

@end
