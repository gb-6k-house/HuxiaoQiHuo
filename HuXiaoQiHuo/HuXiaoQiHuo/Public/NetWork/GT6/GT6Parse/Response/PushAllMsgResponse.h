//
//  PushAllMsgResponse.h
//  Test
//
//  Created by wenbo.fan on 12-10-12.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Response.h"
#import "CMerpOrderDTO.h"
#import "CStatOrderDTO.h"

@interface PushAllMsgResponseData : GT6ResponseData
@property NSArray * merplist;
@property NSArray * statlist;
@end

@interface PushAllMsgResponse : GT6Response
{
    NSMutableDictionary * dicMerpDTO;
}
@property NSMutableDictionary * dicMerpOrderDTO;
@property NSMutableDictionary * dicStatOrderDTO;

-(GT6Response *) initWithString:(NSString *)response dicMerpDTO:(NSMutableDictionary *)dic;
@end
