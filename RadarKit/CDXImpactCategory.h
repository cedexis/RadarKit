//
//  CDXImpactCategory.h
//  RadarKit
//
//  Created by Javier Rosas on 9/25/15.
//  Copyright © 2015 Cedexis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDXImpactCategory : NSObject

@property (strong, nonatomic) NSMutableDictionary *metrics;
@property (strong, nonatomic) NSMutableDictionary *kpi;

-(void)reportWithCategoryName:(NSString*)categoryName completion:(void (^)(NSError *))completion;

@end
