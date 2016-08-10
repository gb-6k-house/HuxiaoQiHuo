//
//  MerpDeliverRequest2.h
//  MarketClient
//
//  Created by easyfly on 3/3/14.
//  Copyright (c) 2014 easyfly. All rights reserved.
//

#import "GT6Request.h"

@interface MerpDeliverRequest2 : GT6Request
-(MerpDeliverRequest2 *)initWithUserID:(NSString *)userid
                               mmcode:(NSString *)mmcode
                                Isbuy:(NSString *)Isbuy
                            AndNumber:(NSString *)number
                                 posid:(NSString *)posid;

@end
