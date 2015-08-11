//
//  CDXInitServiceTests.m
//  RadarKit
//
//  Created by Javier Rosas on 8/11/15.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CDXInitService.h"

@interface CDXInitServiceTests : XCTestCase

@end

@implementation CDXInitServiceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUrlWithSession {
    // This is an example of a functional test case.
    NSString *expectedUrl = @"https://i1-io-0-2-1-12345-0-s.init.cedexis-radar.net/i1/987654/0/xml?seed=i1-io-0-2-1-12345-0-s";
    CDXRadar *radar = [[CDXRadar alloc] init];
    radar.protocol = @"https";
    radar.zoneId = 1;
    radar.customerId = 12345;
    CDXRadarSession *session = [[CDXRadarSession alloc] init];
    session.radar = radar;
    session.timestamp = 987654;
    NSString *resultUrl = [CDXInitService urlWithSession:session];
    XCTAssertTrue([resultUrl isEqualToString:expectedUrl]);
}

@end
