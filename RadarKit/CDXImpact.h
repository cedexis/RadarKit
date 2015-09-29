//
//  CDXImpact.h
//  RadarKit
//
//  Created by Javier Rosas on 9/23/15.
//  Copyright © 2015 Cedexis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDXImpact : NSObject

@property (strong, nonatomic, readonly) NSString *sessionId;
@property (strong, nonatomic) NSString *source;
@property (strong, nonatomic) NSString *apiKey;

+ (NSString *)version;
+ (instancetype)sharedInstance;
- (BOOL)startMeasureWithKey:(NSString *)key category:(NSString *)categoryName;
- (BOOL)endMeasureWithKey:(NSString *)key category:(NSString *)categoryName;
- (void)addKpiWithKey:(NSString *)key value:(NSObject *)value category:(NSString *)categoryName;
- (void)setupWithApiKey:(NSString *)apiKey;
- (void)sendReportWithCategory:(NSString *)categoryName;

@end
