//
//  ChangeLoweHighPriceResponse.h
//  XMClient
//
//  Created by wenbo.fan on 12-11-8.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Response.h"
@interface ChangeLoweHighPriceResponseData : GT6ResponseData
@property int user;
@property int result;
@property NSString * info;
@property NSString * clidoid;
@end

@interface ChangeLoweHighPriceResponse : GT6Response

@end
