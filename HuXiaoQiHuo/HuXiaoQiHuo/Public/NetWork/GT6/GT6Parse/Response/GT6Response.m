//
//  GT6Response.m
//  MarketClient
//
//  Created by XXJ on 15/9/8.
//  Copyright (c) 2015年 easyfly. All rights reserved.
//

#import "GT6Response.h"
#import "JSONKit.h"
@implementation GT6ResponseData
-(id)valueForUndefinedKey:(NSString *)key
{
    id value = [stuff valueForKey:key];
    
    return (value);
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if(stuff==nil){
        stuff=[[NSMutableDictionary alloc] init];
    }
    
    [stuff setObject:value forKey:key];
}

@end

@implementation GT6Response
@synthesize responseData;
-(GT6Response *) init:(GT6ResponseData *)data
{
    if (self = [super init]) {
        self.responseData = data;
    }
    return self;
}

-(GT6Response *) initWithString:(NSString *)response
{
    if (self = [super init]) {
        self.responseData = [self createResponseData];
        [self  parseResponse:response];
    }
    return self;
}

-(void) parseResponse:(NSString *)response
{
    //NSLog(@"respons = @%@", response);
    responseDataDic = [response objectFromJSONString];
    [self.responseData setValuesForKeysWithDictionary:responseDataDic];

}

-(GT6ResponseData *) createResponseData
{
    return [[GT6ResponseData alloc] init];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", self.responseData];
}
@end