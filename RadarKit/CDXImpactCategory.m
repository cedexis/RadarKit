//
//  CDXImpactCategory.m
//  RadarKit
//
//  Created by Javier Rosas on 9/25/15.
//  Copyright © 2015 Cedexis. All rights reserved.
//

#import "CDXImpact.h"
#import "CDXImpactCategory.h"
#import "CDXImpactMeasurement.h"
#import "CDXGlobals.h"

@implementation CDXImpactCategory

- (instancetype)init
{
    self = [super init];
    if (self) {
        _kpi = [NSMutableDictionary dictionary];
        _metrics = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)reportWithCategoryName:(NSString *)categoryName completion:(void (^)(NSError *error))completion {
    CDXImpact *impact = [CDXImpact sharedInstance];
    NSLog(@"### DOS");
    // Only include metrics which have been completed
    NSMutableDictionary *completedMetrics = [NSMutableDictionary dictionary];
    for (NSString *key in self.metrics) {
        CDXImpactMeasurement *metric = (CDXImpactMeasurement *)self.metrics[key];
        if (metric.duration) {
            completedMetrics[key] = @(metric.duration);
        }
    }
    
    NSLog(@"### TRES");
    
    NSDictionary *data = @{
                           @"client": @{
                                   @"type": @"RadarKit",
                                   @"version": CDXImpact.version
                                   },
                           @"dims": @{
                                   @"impactSessionId": impact.sessionId,
                                   @"category": categoryName
                                   },
                           @"metrics": completedMetrics,
                           @"kpi": self.kpi
                           };
    NSLog(@"### CUATRO");
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://rpt.cedexis.com/impact"]];
    
    // Uncomment to test with local server
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1:5000/impact"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPBody:jsonData];
    [request setHTTPMethod:@"POST"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    clearNSURLSessionConfiguration(configuration);
    configuration.HTTPAdditionalHeaders = @{
                                            @"Authorization": impact.apiKey,
                                            @"Content-Type": @"application/json"
                                            };
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Impact report sent");
        if (completion) {
            completion(error);
        }
    }];
    [task resume];
}

@end
