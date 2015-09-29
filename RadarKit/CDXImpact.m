//
//  CDXImpact.m
//  RadarKit
//
//  Created by Javier Rosas on 9/23/15.
//  Copyright © 2015 Cedexis. All rights reserved.
//

#import "CDXImpact.h"
#import "CDXImpactMeasurement.h"
#import "CDXImpactCategory.h"

@interface CDXImpact()

/**
 *  Dictionary of type @(NSString:NSMutableDictionary)
 *  The value of the dictionary is a mutable dictionary that represents the metrics
 */
@property NSMutableDictionary *categories;

@end

@implementation CDXImpact

#pragma mark - Singleton initialization

+ (instancetype)sharedInstance {
    static CDXImpact *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CDXImpact alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.categories = [NSMutableDictionary dictionary];
        _sessionId = [[NSUUID UUID] UUIDString];
    }
    return self;
}

+(NSString *)version {
    return @"0.3.0";
}

- (void)setupWithApiKey:(NSString *)apiKey {
    self.apiKey = apiKey;
}

#pragma mark - Public methods

/**
 *  Marks a starting point for a performance measurement
 *
 *  @param key          Name of the metric
 *  @param categoryName Category name
 *
 *  @return Returns NO when another measurement has been started with the same category and key, and has not ended yet, in which case does nothing.
 */
-(BOOL)startMeasureWithKey:(NSString *)key category:(NSString *)categoryName {
    CDXImpactCategory *category = [self findOrCreateCategoryWithName:categoryName];
    if (category.metrics[key]) {
        return NO;
    } else {
        CDXImpactMeasurement *measurement = [[CDXImpactMeasurement alloc] init];
        category.metrics[key] = measurement;
        return YES;
    }
}

/**
 *  Marks an end point for a performance measurement
 *
 *  @param key          Name of the metric
 *  @param categoryName Category name
 *
 *  @return Returns NO when a measurement with thar category-key pair has not been started, in which case does nothing.
 */
-(BOOL)endMeasureWithKey:(NSString *)key category:(NSString *)categoryName {
    CDXImpactCategory *category = self.categories[categoryName];
    if (!category) {
        return NO;
    }
    if (category.metrics[key]) {
        CDXImpactMeasurement *measurement = (CDXImpactMeasurement *)category.metrics[key];
        [measurement end];
        return YES;
    } else {
        return NO;
    }
}

/**
 *  Adds a KPI
 *
 *  @param key          Name of the KPI
 *  @param value        Value of the KPI
 *  @param categoryName Category name
 */
-(void)addKpiWithKey:(NSString *)key value:(NSObject *)value category:(NSString *)categoryName {
    CDXImpactCategory *category = [self findOrCreateCategoryWithName:categoryName];
    category.kpi[key] = value;
}

-(void)sendReportWithCategory:(NSString *)categoryName {
    NSLog(@"### Send report with category %@", categoryName);
    CDXImpactCategory *category = self.categories[categoryName];
    NSLog(@"### UNO");
    [category reportWithCategoryName:categoryName completion:nil];
}

#pragma mark - Private methods

-(CDXImpactCategory *)findOrCreateCategoryWithName:(NSString *)categoryName {
    CDXImpactCategory *category = self.categories[categoryName];
    if (!category) {
        category = [[CDXImpactCategory alloc] init];
        self.categories[categoryName] = category;
    }
    return category;
}

@end
