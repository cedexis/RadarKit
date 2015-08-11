//
//  CDXProviderServiceTests.m
//  RadarKit
//
//  Created by Javier Rosas on 8/10/15.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CDXProviderService.h"
#import "CDXRadarSession.h"

@interface CDXProviderServiceTests : XCTestCase

@end

@implementation CDXProviderServiceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUrlForSession {
    CDXRadar *radar = [[CDXRadar alloc] init];
    radar.protocol = @"https";
    radar.zoneId = 1;
    radar.customerId = 12345;
    CDXRadarSession *session = [[CDXRadarSession alloc] init];
    session.radar = radar;
    session.timestamp = 987654;
    NSString *resultUrl = [CDXProviderService urlForSession:session];
    NSLog(@"%@", resultUrl);
    XCTAssertTrue([resultUrl hasPrefix:@"https://radar.cedexis.com/1/12345/radar/987654/"]);
    XCTAssertTrue([resultUrl hasSuffix:@"/providers.json?imagesok=1&t=1"]);
}

- (void)testGenRandomStringWithLength {
    NSString *randomStringOne = [CDXProviderService randomStringWithLength:20];
    NSString *randomStringTwo = [CDXProviderService randomStringWithLength:15];
    XCTAssertNotEqual(randomStringOne, randomStringTwo);
    XCTAssertEqual(randomStringOne.length, 20);
    XCTAssertEqual(randomStringTwo.length, 15);
}

@end
