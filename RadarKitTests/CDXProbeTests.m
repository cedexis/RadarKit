//
//  CDXProbeTests.m
//  RadarKit
//
//  Created by Javier Rosas on 8/5/15.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "CDXProbe.h"

@interface CDXProbeTests : XCTestCase

@end

@implementation CDXProbeTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testReportUrl {
    NSString *expectedUrl = @"http://rpt.cedexis.com/f1/BeCkaMLVeaayaIigcaeqPjqbkmF5XA0lmiEKJQ4foiEKJQ4fqmR6TBKpsHqiardFarJbDIckGidabcIfGicGbfc9JEShwHaiarcuarIVBsaakn2lGkaeyabQe2j1DhrVBJeUBwLHlMH2lNbYB2qa/0/0/32/14/0/3041/1/0";
    CDXRadarSession *session = [CDXRadarSession new];
    session.requestSignature = @"BeCkaMLVeaayaIigcaeqPjqbkmF5XA0lmiEKJQ4foiEKJQ4fqmR6TBKpsHqiardFarJbDIckGidabcIfGicGbfc9JEShwHaiarcuarIVBsaakn2lGkaeyabQe2j1DhrVBJeUBwLHlMH2lNbYB2qa";
    CDXProbe *probe = [CDXProbe new];
    probe.session = session;
    probe.ownerZoneId = 0;
    probe.ownerCustomerId = 0;
    probe.providerId = 32;
    probe.probeId = 14;
    NSString *url = [probe reportUrlForResult:0 measurement:3041];
    XCTAssertTrue([url isEqualToString:expectedUrl]);
}

- (void)testProbeUrl {
    NSString *expectedUrl = @"http://fastlybench.cedexis.com/img/90/r20.gif?rnd=1-1-18980-0-0-90-833515866-BeGkaMLVeaayaIigcaeqPjqbknRIUy0dmpdQJQ4fopdQJQ4fqmR6TzKpsHqiardFarJbDIckGidabcIfGicGbfc9JEShwHaiarcuarIVBsaakn2lGkaeyabQe2j1DhrVBJiUC2vHlMH2lNbYB2qa";
    CDXRadarSession *session = [CDXRadarSession new];
    session.radar = [CDXRadar new];
    session.radar.zoneId = 1;
    session.radar.customerId = 18980;
    session.requestSignature = @"BeGkaMLVeaayaIigcaeqPjqbknRIUy0dmpdQJQ4fopdQJQ4fqmR6TzKpsHqiardFarJbDIckGidabcIfGicGbfc9JEShwHaiarcuarIVBsaakn2lGkaeyabQe2j1DhrVBJiUC2vHlMH2lNbYB2qa";
    session.transactionId = 833515866;
    CDXProbe *probe = [CDXProbe new];
    probe.session = session;
    probe.url = @"http://fastlybench.cedexis.com/img/90/r20.gif";
    probe.probeId = 1;
    probe.ownerZoneId = 0;
    probe.ownerCustomerId = 0;
    probe.providerId = 90;
    XCTAssertTrue([probe.probeUrl isEqualToString:expectedUrl]);
}

@end
