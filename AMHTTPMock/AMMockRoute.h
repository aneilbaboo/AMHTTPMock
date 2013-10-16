//
//  AMMockRoute.h
//  AMHTTPMock
//
//  Created by Aneil Mallavarapu on 10/15/13.
//  Copyright (c) 2013 Aneil Mallavarapu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMMockRoute : NSObject
@property (nonatomic,readonly) NSString *uri;
@property (nonatomic,readonly) NSString *HTTPMethod;
@property (nonatomic,readonly) NSUInteger statusCode;
@property (nonatomic,readonly) NSDictionary *headers;
@property (nonatomic,readonly) NSData *body;
@property (nonatomic,readonly) NSInteger timesAllowed;

// count of times this route was used
@property (nonatomic,readonly) NSInteger timesUsed;

// list of NSNumbers indicating when route was used
@property (nonatomic,readonly) NSArray *useOrders;

@property (nonatomic,readonly) NSError *error;

-(id)initWithURI:(NSString *)uri httpMethod:(NSString *)method returningStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers body:(id)body timesAllowed:(NSInteger)timesAllowed;
-(id)initWithURI:(NSString *)uri httpMethod:(NSString *)method returningError:(NSError *)error timesAllowed:(NSInteger)timesAllowed;

// returns TRUE if this route was used in the specified order
- (BOOL)wasUsedAtOrder:(NSUInteger)order;

// returns TRUE if the uri & method match the request
- (BOOL)matchesRequest:(NSURLRequest *)request;

@end
