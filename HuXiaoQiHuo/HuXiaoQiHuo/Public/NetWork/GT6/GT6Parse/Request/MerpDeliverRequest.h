//
//  MerpDeliverRequest.h
//  XMClient
//
//  Created by wenbo.fan on 12-11-7.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Request.h"

@interface MerpDeliverRequest : GT6Request
-(MerpDeliverRequest *)initWithUserID:(NSString *)userid
                               mmcode:(NSString *)mmcode
                                Isbuy:(NSString *)Isbuy
                            AndNumber:(NSString *)number;
@end
