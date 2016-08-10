//
//  AddOrderRequest.h
//  Test
//
//  Created by wenbo.fan on 12-10-12.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Request.h"

@interface AddOrderRequest_Market : GT6Request
-(AddOrderRequest_Market *)initWithUserID:(NSString *)userID
                            mpcode:(NSString *)mpcode
                             isBuy:(NSString *)isBuy
                            number:(NSString *)number
                             price:(NSString *)price
                         doadverse:(NSString *)doadverse
                           matchid:(NSString *)matchid

                             posid:(NSString *)posid
                              loss:(NSString *)loss
                            profit:(NSString *)profit
                          modetype:(NSString *)modetype
                         makertype:(NSString *)makertype
                         udtype:(NSString *)udtype
                        errorPrice:(NSString *)errorPrice

;
-(AddOrderRequest_Market *)initWithUserID:(NSString *)userID
                                   mpcode:(NSString *)mpcode
                                    isBuy:(BOOL)isBuy
                                   number:(NSNumber *)number
                                    price:(NSString *)price
                                     type:(NSInteger)type
                                stopPrice:(NSString *)stopPrice
                                 stopType:(NSString *)stopType
                                      pid:(NSString *)pid;
@end
