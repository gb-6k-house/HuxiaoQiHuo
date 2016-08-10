//
//  GT6LoginResponse.m
//  MarketClient
//
//  Created by XXJ on 15/9/9.
//  Copyright (c) 2015年 easyfly. All rights reserved.
//

#import "GT6LoginResponse.h"


@implementation GT6LoginResponseData
@synthesize rst,uid,reason;

@end

@implementation GT6LoginResponse
@synthesize userStatus,loginResponseData;
-(GT6ResponseData *)createResponseData
{
    return [[GT6LoginResponseData alloc] init];
}

-(void) parseResponse:(NSString *)response
{
    [super parseResponse:response];
    if ([self isLoginSucess])
    {
        [self parseUserStatus];
        self.userStatus.userID = ((GT6LoginResponseData *)responseData).uid;
        
    }
}

-(BOOL) isLoginSucess
{
    if ([((GT6LoginResponseData *)responseData).rst isEqualToString:@"T"]) {
        return YES;
    }else{
        return NO;
    }
}

-(void) parseUserStatus
{
    NSArray * tmparray = [((GT6LoginResponseData *)responseData).reason componentsSeparatedByString:@","];
    self.userStatus = [[UserStatus alloc] init];
    
    switch ([tmparray count]) {
            
        default:
            
        case 6:
            self.userStatus.UserType = [[tmparray objectAtIndex:5] intValue];
            
        case 5:
            self.userStatus.SUGradeId = [[tmparray objectAtIndex:4] intValue];
            
        case 4:
            self.userStatus.delayTime = [[tmparray objectAtIndex:3] intValue];
            
        case 3:
            self.userStatus.status = [[tmparray objectAtIndex:2] intValue];
        case 2:
            self.userStatus.bankAccount = [[NSString alloc] initWithString:[tmparray objectAtIndex:1]];
        case 1:
            self.userStatus.username = [[NSString alloc] initWithString:[tmparray objectAtIndex:0]];
            break;
            
        case 0:
            break;
    }
    //NSLog(@"%d %d %@ %@", [[tmparray objectAtIndex:3] intValue], [[tmparray objectAtIndex:2] intValue], [[NSString alloc] initWithString:[tmparray objectAtIndex:1]],[[NSString alloc] initWithString:[tmparray objectAtIndex:0]]);
}

@end