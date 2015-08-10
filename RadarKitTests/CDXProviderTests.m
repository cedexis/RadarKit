//
//  CDXProviderTests.m
//  RadarKit
//
//  Created by Javier Rosas on 8/10/15.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CDXProvider.h"
#import "CDXProbe.h"

@interface CDXProviderTests : XCTestCase

@end

@implementation CDXProviderTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testProbeFromSample {
    NSDictionary *sample = @{
            @"a": @1,
            @"b": @1,
            @"p": @{
                @"c": @123,
                @"i": @17,
                @"p": @{
                    @"a" :@{
                        @"a": @{
                            @"t": @2,
                            @"u": @"http://chinacache.cedexis.com/img/17/r20.gif"
                        },
                        @"b": @{
                            @"t": @2,
                            @"u": @"http://chinacache.cedexis.com/img/17/r30.gif"
                        },
                        @"c": @{
                            @"t": @2,
                            @"u": @"http://chinacache.cedexis.com/img/17/r20-100KB.png"
                        },
                    },
                    @"d": @{
                        @"t": @7,
                        @"u": @"http://chinacache.cedexis.com/node2/17min.html"
                    }
                },
                @"z": @12
            }
        };
    CDXRadar *radar = [[CDXRadar alloc] init];
    radar.protocol = @"https";
    CDXRadarSession *session = [[CDXRadarSession alloc] initWithRadar:radar];
    CDXProvider *provider = [[CDXProvider alloc] initWithSample:sample session:session];
    NSArray *probes = provider.probes;
    
    XCTAssertEqual(probes.count, 3);
    
    CDXProbe *coldProbe = (CDXProbe *)probes[0];
    XCTAssertEqual(coldProbe.probeId, CDXProbeIdCold);
    XCTAssertTrue([coldProbe.probeUrl hasPrefix:@"http://chinacache.cedexis.com/img/17/r20.gif"]);
    XCTAssertEqual(coldProbe.objectType, 2);
    XCTAssertEqual(coldProbe.providerId, 17);
    XCTAssertEqual(coldProbe.ownerZoneId, 12);
    XCTAssertEqual(coldProbe.ownerCustomerId, 123);
    
    CDXProbe *rttProbe = (CDXProbe *)probes[1];
    XCTAssertEqual(rttProbe.probeId, CDXProbeIdRTT);
    XCTAssertTrue([rttProbe.probeUrl hasPrefix:@"http://chinacache.cedexis.com/img/17/r30.gif"]);
    XCTAssertEqual(rttProbe.objectType, 2);
    XCTAssertEqual(rttProbe.providerId, 17);
    XCTAssertEqual(rttProbe.ownerZoneId, 12);
    XCTAssertEqual(rttProbe.ownerCustomerId, 123);
    
    CDXProbe *throughputProbe = (CDXProbe *)probes[2];
    XCTAssertEqual(throughputProbe.probeId, CDXProbeIdThroughput);
    XCTAssertTrue([throughputProbe.probeUrl hasPrefix:@"http://chinacache.cedexis.com/img/17/r20-100KB.png"]);
    XCTAssertEqual(throughputProbe.objectType, 2);
    XCTAssertEqual(throughputProbe.providerId, 17);
    XCTAssertEqual(throughputProbe.ownerZoneId, 12);
    XCTAssertEqual(throughputProbe.ownerCustomerId, 123);
}
@end
