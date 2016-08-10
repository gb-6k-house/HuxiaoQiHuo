//
//  Subscription_Search_Request_Obj.m
//  traderex
//
//  Created by cssoft on 15/12/1.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import "Subscription_Search_Request_Obj.h"

@implementation Subscription_Search_Request_Obj

- (NSMutableArray *)arraySearchRequestData
{
    if (!_arraySearchRequestData) {
        
        _arraySearchRequestData = [NSMutableArray array];
    }
    return _arraySearchRequestData;
}
@end
