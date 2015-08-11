//
//  CDXRadarTests.m
//  RadarKit
//
//  Created by Javier Rosas on 8/11/15.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CDXRadar.h"

@interface CDXRadarTests : XCTestCase

@end

@implementation CDXRadarTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDefaultProtocolIsHTTPS {
    CDXRadar *radar = [[CDXRadar alloc]initWithZoneId:1 customerId:18980];
    XCTAssertTrue([radar.protocol isEqualToString:@"https"]);
}

- (void)testEndToEndResultsInSuccess {
    XCTestExpectation *expectation = [self expectationWithDescription:@"End to end test"];
    CDXRadar *radar = [[CDXRadar alloc]initWithZoneId:1 customerId:18980];
    [radar runInBackgroundWithCompletionHandler:^void(NSError *error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:15 handler:nil];
}

@end
