//
//  Init.h
//  RadarKit
//
//  Created by Jacob Wan on 2015-03-26.
//  Copyright (c) 2015 Cedexis. All rights reserved.
//

typedef void(^CDXInitServiceCompletionBlock)(NSString *, NSError *);

@interface CDXInitService : NSObject

-(instancetype)initWithSettings:(NSDictionary *)settings completionHandler:(CDXInitServiceCompletionBlock)handler;

-(NSURLSessionDataTask *)beginInitRequest;

@end
