//
//  GetCodeTool.h
//  WashCarShop
//
//  Created by zhangzhao on 7/17/14.
//  Copyright (c) 2014 NiuPark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HyperlinksButton.h"
@interface GetCodeTool : NSObject
@property (weak)UITextField * txtCode;
@property (copy)NSString * strPhone;
@property (copy)NSString * strUserName;
@property (copy)NSString * strClientType;
@property (strong)NSTimer * myTimer;
@property (weak)UIView * view;
@property (weak)UIButton * btn;

- (void)check;
@end
