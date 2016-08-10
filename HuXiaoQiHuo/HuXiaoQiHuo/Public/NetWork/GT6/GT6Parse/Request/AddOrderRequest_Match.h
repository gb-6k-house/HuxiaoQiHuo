//
//  AddOrderRequest.h
//  Test
//
//  Created by wenbo.fan on 12-10-12.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Request.h"

@interface AddOrderRequest_Match : GT6Request
-(AddOrderRequest_Match *)initWithUserID:(NSString *)userID
                            mpcode:(NSString *)mpcode
                             isBuy:(NSString *)isBuy
                            number:(NSString *)number
                             price:(NSString *)price
                         doadverse:(NSString *)doadverse
                           matchid:(NSString *)matchid

;
@end
