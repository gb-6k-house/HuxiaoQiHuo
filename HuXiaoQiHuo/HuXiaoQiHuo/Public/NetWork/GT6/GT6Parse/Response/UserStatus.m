//
//  UserStatus.m
//  XMClient
//
//  Created by wenbo.fan on 12-10-26.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "UserStatus.h"

@implementation UserStatus
@synthesize userID,username,bankAccount,status,delayTime;
-(NSString *) description
{
    
    return [NSString stringWithFormat:@"userID:%d, username:%@, bankAccount:%@, status:%d ,delayTime:%d", self.userID, self.username, self.bankAccount, self.status, self.delayTime];
}
@end