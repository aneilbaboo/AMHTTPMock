//
//  AMMockRoute.m
//  AMHTTPMock
//
//  Created by Aneil Mallavarapu on 10/15/13.
//  Copyright (c) 2013 Aneil Mallavarapu. All rights reserved.
//

#import "AMMockRoute.h"

@interface AMMockRoute ()

@property (nonatomic,strong) NSMutableArray *mutableUseOrders;
@end

@implementation AMMockRoute
@dynamic useOrders;

-(id)initWithURI:(NSString *)uri httpMethod:(NSString *)method returningError:(NSError *)error timesAllowed:(NSInteger)timesAllowed {
    self = [super init];
    _uri = uri;
    _HTTPMethod = method;
    _error = error;
    _timesAllowed = timesAllowed;
    return self;
}

-(id)initWithURI:(NSString *)uri httpMethod:(NSString *)method returningStatusCode:(NSUInteger)statusCode headers:(NSDictionary *)headers body:(id)body timesAllowed:(NSInteger)timesAllowed{
    self = [super init];
    _uri = uri;
    _HTTPMethod = method;
    _statusCode = statusCode;
    _headers = headers;
    _mutableUseOrders = [NSMutableArray array];
    _timesAllowed = timesAllowed;
    if ([body isKindOfClass:[NSData class]]) {
        _body = body;
    }
    else if ([body isKindOfClass:[NSString class]]) {
        _body = [(NSString *)body dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if (!body) {
        _body = nil;
    }
    else {
        [NSException raise:@"Invalid Argument" format:@"In [AMMockRoute initWithURI:httpMethod:returningStatusCode:headers:body:], body argument must be NSData or NSString, but received: %@",body];
    }
    return self;
}
-(void)reset {
    [_mutableUseOrders removeAllObjects];
    _timesUsed = 0;
}

-(NSArray *)useOrders {
    return [NSArray arrayWithArray:_mutableUseOrders];
}

-(BOOL)wasUsedAtOrder:(NSUInteger)order {
    return [_mutableUseOrders containsObject:@(order)];
}


- (BOOL)matchesRequest:(NSURLRequest *)request {
    NSString *requestURI = [request.URL absoluteString];
    NSString *method = self.HTTPMethod.lowercaseString;
    // method==nil matches all HTTP methods (GET/PUT/etc)
    BOOL methodMatches = (!method || [[request.HTTPMethod lowercaseString] isEqualToString:method]);
    BOOL uriMatches = [requestURI isEqualToString:self.uri];
    return (uriMatches && methodMatches);
}

// private method accessed by AMHTTPMock
-(void)useAtOrder:(NSUInteger)order {
    [_mutableUseOrders addObject:@(order)];
    _timesUsed ++;
    if (_timesAllowed>=0 && _timesUsed>_timesAllowed) {
        [NSException raise:@"Mock Route Overused" format:@"%@",self];
    }
}

-(NSString *)description {
    if (self.error) {
        return [NSString stringWithFormat:@"[AMMockRoute uri:%@ method:%@ error:%@ timesAllowed:%ld timesUsed:%ld]",
                self.uri,self.HTTPMethod,self.error, self.timesAllowed,self.timesUsed];
    }
    else {
        return [NSString stringWithFormat:@"[AMMockRoute uri:%@ method:%@ statusCode:%ld headers:%@ body:%@ timesAllowed:%ld timesUsed:%ld]",
                self.uri,self.HTTPMethod,self.statusCode,self.headers,self.body, self.timesAllowed,self.timesUsed];
    }
}

@end
