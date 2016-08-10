//
//  GT6Response.h
//  MarketClient
//
//  Created by XXJ on 15/9/8.
//  Copyright (c) 2015年 easyfly. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface GT6ResponseData : NSObject
{
    NSMutableDictionary * stuff;
}
- (id)valueForUndefinedKey:(NSString *)key;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end

@interface GT6Response : NSObject
{
    GT6ResponseData * responseData;
    NSDictionary * responseDataDic;
}
@property GT6ResponseData * responseData;
-(GT6Response *) init:(GT6ResponseData *) data;
-(GT6Response *) initWithString:(NSString *)response;
-(void) parseResponse:(NSString *) response;
-(GT6ResponseData *) createResponseData;
@end
