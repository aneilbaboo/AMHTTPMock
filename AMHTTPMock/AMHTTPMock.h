//
//  AMHTTPMock.h
//  AMHTTPMock
//
//  Created by Aneil Mallavarapu on 10/15/13.
//  Copyright (c) 2013 Aneil Mallavarapu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>

@interface AMHTTPMock : NSURLProtocol
+ (void)clearRoutes;
+ (void)addMockRoute:(NSString *)url method:(NSString *)method body:(NSData *)data statusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers;
+ (void)addMockRoute:(NSString *)url method:(NSString *)method stringBody:(NSString *)data statusCode:(NSUInteger)statusCode  headers:(NSDictionary *)headers;
+ (void)setup;
+ (void)teardown;
@end
