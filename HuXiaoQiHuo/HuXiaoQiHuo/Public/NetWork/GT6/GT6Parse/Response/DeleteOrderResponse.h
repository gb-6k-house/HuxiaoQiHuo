//
//  DeleteOrderResponse.h
//  Test
//
//  Created by wenbo.fan on 12-10-12.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Response.h"
@interface DeleteOrderResponseData : GT6ResponseData
@property int user;
@property int result;
@property unsigned int orderid;
@property  NSString * info;
@property  NSString * clidoid;
@end

@interface DeleteOrderResponse : GT6Response

@end
