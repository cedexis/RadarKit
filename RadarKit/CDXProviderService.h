//
//  Providers.h
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-27.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

typedef void(^CDXProviderServiceCompletionBlock)(NSArray *, NSError *);

@interface CDXProviderService : NSObject

-(instancetype)initWithSettings:(NSDictionary *)settings completionHandler:(CDXProviderServiceCompletionBlock)handler;

-(NSURLSessionDataTask *)requestSamples;

@end
