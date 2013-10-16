//
//  AMHTTPMock.h
//  AMHTTPMock
//
//  Created by Aneil Mallavarapu on 10/15/13.
//  Copyright (c) 2013 Aneil Mallavarapu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMMockRoute.h"

/** @class AMHTTPMock
 Provides a way to mock HTTP requests
 */

@interface AMHTTPMock : NSURLProtocol

/** Adds and returns a mock route which is used when URI and HTTP method match 
    and results in a client error
    @param uri The request URI
    @param httpMethod The request HTTP method
    @param error The error received by the client
    @param timesAllowed Number of times allowed: 0 (not allowed), >1 (allowed N times), -1 (no limit)
 */
+ (AMMockRoute *)addMockRouteWithURI:(NSString *)uri
                          httpMethod:(NSString *)httpMethod
                      returningError:(NSError *)error
                        timesAllowed:(NSInteger)timesAllowed;

/** Adds and returns a mock route which is used when URI and HTTP method match
 and results in a client error an unlimited number of times
 @param uri The request URI
 @param httpMethod The request HTTP method
 @param error The error received by the client
 */
+ (AMMockRoute *)addMockRouteWithURI:(NSString *)uri
                          httpMethod:(NSString *)httpMethod
                      returningError:(NSError *)error;


/** Adds and returns a mock route which is used when URI and HTTP method match
    which results in a response with status code, headers and body as specified
    @param uri The request URI
    @param httpMethod The request HTTP method
    @param statusCode The response status code
    @param headers The response headers
    @param body The response body (which may be NSString or NSData)
    @param timesAllowed Number of times allowed: 0 (not allowed), >1 (allowed N times), -1 (no limit)
 */
+ (AMMockRoute *)addMockRouteWithURI:(NSString *)uri
                          httpMethod:(NSString *)httpMethod
                 returningStatusCode:(NSUInteger)statusCode
                             headers:(NSDictionary *)headers
                                body:(id)body
                        timesAllowed:(NSInteger)timesAllowed;

/** Adds and returns a mock route which is used when URI and HTTP method match
    which results in a response with status code, headers and body as specified,
    and can be called an unlimited number of times
    @param uri The request URI
    @param httpMethod The request HTTP method
    @param statusCode The response status code
    @param headers The response headers
    @param body The response body (which may be NSString or NSData)
 */
+ (AMMockRoute *)addMockRouteWithURI:(NSString *)uri
                          httpMethod:(NSString *)method
                 returningStatusCode:(NSUInteger)statusCode
                             headers:(NSDictionary *)headers
                                body:(id)body;


/** List of routes added to AMHTTPMock */
+ (NSArray *)routes;

/** Must be called before running tests */
+ (void)setup;

/** Must be called after running tests */
+ (void)teardown;
@end
