//
//  PushAllMsgResponse.m
//  Test
//
//  Created by wenbo.fan on 12-10-12.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "PushAllMsgResponse.h"
@implementation PushAllMsgResponseData
@synthesize merplist,statlist;
-(NSString *)description
{
    return [NSString stringWithFormat:@"merplist:%@ statlist:%@", merplist, statlist];
}
@end

@implementation PushAllMsgResponse
@synthesize dicMerpOrderDTO, dicStatOrderDTO;
-(GT6Response *) initWithString:(NSString *)response dicMerpDTO:(NSMutableDictionary *)dic
{
    dicMerpDTO = dic;
    self = [super initWithString:response];
    return self;
}

-(GT6ResponseData *)createResponseData
{
    return [[PushAllMsgResponseData alloc] init];
}

-(void) parseResponse:(NSString *)response
{
    [super parseResponse:response];
    
    self.dicMerpOrderDTO = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary * tmpDic;
    for (tmpDic in ((PushAllMsgResponseData *)self.responseData).merplist) {
        CMerpOrderDTO * merpOrderDTO = [[CMerpOrderDTO alloc] init];
        [merpOrderDTO setValuesForKeysWithDictionary:tmpDic];
        if ([dicMerpDTO valueForKey: merpOrderDTO.mpcode] != nil) {
            [self.dicMerpOrderDTO setValue:merpOrderDTO forKey:merpOrderDTO.mpcode];
        }
    }
    
    self.dicStatOrderDTO = [[NSMutableDictionary alloc] init];
    for (tmpDic in ((PushAllMsgResponseData *)self.responseData).statlist) {
        CStatOrderDTO * statOrderDTO = [[CStatOrderDTO alloc] init];
        [statOrderDTO setValuesForKeysWithDictionary:tmpDic];
        
        NSMutableArray * tmpArray = [self.dicStatOrderDTO valueForKey:statOrderDTO.mcode];
        if (tmpArray == nil) {
            tmpArray = [[NSMutableArray alloc] initWithObjects:statOrderDTO, nil];
        }else{
            [tmpArray addObject:statOrderDTO];
        }
        [self.dicStatOrderDTO setValue:tmpArray forKey:statOrderDTO.mcode];
    }
}
@end
