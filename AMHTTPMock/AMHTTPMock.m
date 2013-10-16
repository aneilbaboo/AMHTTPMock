//
//  AMHTTPMock.m
//  AMHTTPMock
//
//  Created by Aneil Mallavarapu on 10/15/13.
//  Copyright (c) 2013 Aneil Mallavarapu. All rights reserved.
//

#import "AMHTTPMock.h"

NSMutableArray *gAMHTTPMockRoutes;
BOOL gAMHTTPMockDisallowOtherRequests;

@interface AMMockRoute (AMHTTPMockPrivate)
-(void)useAtOrder:(NSUInteger)order; // access private method
@end

@implementation AMHTTPMock

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return [self disallowOtherRequests] || !![self routeForRequest:request];
}

+ (BOOL)disallowOtherRequests {
    return gAMHTTPMockDisallowOtherRequests;
}

+ (void)setup {
    [NSURLProtocol registerClass:self];
}

+ (void)teardown {
    [NSURLProtocol unregisterClass:self];
    [self clearRoutes];
}

+(void)setDisallowOtherRequests:(BOOL)disallow {
    gAMHTTPMockDisallowOtherRequests = disallow;
}

+ (AMMockRoute *)addMockRouteWithURI:(NSString *)uri httpMethod:(NSString *)method returningError:(NSError *)error timesAllowed:(NSInteger)timesAllowed {
    AMMockRoute *route = [[AMMockRoute alloc] initWithURI:uri httpMethod:method returningError:error timesAllowed:timesAllowed];
    [[self mutableRoutes] addObject:route];
    return route;
}

+ (AMMockRoute *)addMockRouteWithURI:(NSString *)uri httpMethod:(NSString *)method returningError:(NSError *)error {
    return [self addMockRouteWithURI:uri httpMethod:method returningError:error timesAllowed:-1];
}

+ (AMMockRoute *)addMockRouteWithURI:(NSString *)uri httpMethod:(NSString *)method returningStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers body:(id)body timesAllowed:(NSInteger)timesAllowed {

    AMMockRoute *route = [[AMMockRoute alloc] initWithURI:uri httpMethod:method returningStatusCode:statusCode headers:headers body:body timesAllowed:timesAllowed];
    [[self mutableRoutes] addObject:route];
    return route;
}

+ (AMMockRoute *)addMockRouteWithURI:(NSString *)uri httpMethod:(NSString *)method returningStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers body:(id)body {
    return [self addMockRouteWithURI:uri httpMethod:method returningStatusCode:statusCode headers:headers body:body timesAllowed:-1];
}

+ (NSInteger)totalUses {
    NSInteger totalUses =0;
    for (AMMockRoute *route in [self mutableRoutes]) {
        totalUses += route.timesUsed;
    }
    return totalUses;
}

#pragma mark - Helper Class Methods

+ (void)clearRoutes {
    gAMHTTPMockRoutes = nil;
}

+ (AMMockRoute *)routeForRequest:(NSURLRequest *)request {

    // search unordered routes:
    NSMutableArray *routes = [self mutableRoutes];
    for (AMMockRoute *route in routes) {
        if ([route matchesRequest:request]) {
            return route;
        }
    }
    
    return nil;
}

+(NSArray *)routes {
    return gAMHTTPMockRoutes;
}

+(NSMutableArray *)mutableRoutes {
    if (!gAMHTTPMockRoutes) {
        gAMHTTPMockRoutes = [NSMutableArray array];
    }
    return gAMHTTPMockRoutes;
}

#pragma mark - Instance Methods
- (void)startLoading {
    NSURLRequest *request = [self request];
    id client = [self client];
    AMMockRoute *route = [[self class] routeForRequest:request];
    if (route) {
        [route useAtOrder:[[self class] totalUses]];
        if (route.error) {
            [client URLProtocol:self didFailWithError:route.error];
        }
        else {
            // Send the Mock data
            NSHTTPURLResponse *response =
            [[NSHTTPURLResponse alloc] initWithURL:[request URL]
                                        statusCode:route.statusCode
                                       HTTPVersion:@"HTTP/1.1"
                                      headerFields:route.headers];
            
            [client URLProtocol:self didReceiveResponse:response
             cacheStoragePolicy:NSURLCacheStorageNotAllowed];
            [client URLProtocol:self didLoadData:route.body];
            [client URLProtocolDidFinishLoading:self];
        }
    }
    else if ([self.class disallowOtherRequests]) {
        [NSException raise:@"Unexpected request" format:@"%@ received unmocked request: %@",NSStringFromClass([self class]), request];
    }
}

@end
