//
//  LoginJson_MerpList_Obj.h
//  Trader
//
//  Created by cssoft on 14-7-14.
//  Copyright (c) 2014年 easyfly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginJson_MerpList_Obj : NSObject

@property(nonatomic,strong)NSArray*OCTlist;
@property double diff;
@property NSInteger index;
@property(nonatomic,copy)NSString * mpcode;
@property(nonatomic,copy)NSString * mpname;
@property NSInteger precision;
@property int unit;
@property int opt;
@property double dStep;
@property(nonatomic,copy)NSString *dd; //数据日期


@end
