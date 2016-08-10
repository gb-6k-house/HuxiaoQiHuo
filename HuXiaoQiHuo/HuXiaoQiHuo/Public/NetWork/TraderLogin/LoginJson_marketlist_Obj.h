//
//  LoginJson_marketlist_Obj.h
//  Trader
//
//  Created by cssoft on 14-7-14.
//  Copyright (c) 2014年 easyfly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginJson_marketlist_Obj : NSObject

@property NSInteger marketID;
@property(nonatomic,copy)NSString *name;
@property int  type;
@property(nonatomic,strong)NSArray*merplist;
@property int index;
@property int unit;

@end
