//
//  GetCodeTool.m
//  WashCarShop
//
//  Created by zhangzhao on 7/17/14.
//  Copyright (c) 2014 NiuPark. All rights reserved.
//

#import "GetCodeTool.h"
#import "CRegisterClientSocket.h"
@interface GetCodeTool(){
    NSInteger _time;
}
@end
@implementation GetCodeTool
- (void)getCode:(id)sender {
    [self getCodeByDic];
}

- (void)flashBtn:(NSTimer *)t {
    UIButton * btn = (UIButton *)[t userInfo];
    [btn setTitle:[NSString stringWithFormat:@"%lds",(long)_time] forState:UIControlStateDisabled];
    if (_time == 0) {
        _time = 59;
        [btn setEnabled:YES];
        [t invalidate];
    }else {
        _time--;
    }
}

- (void)check {
    [self getCodeByDic];
    _time = 59;
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(flashBtn:) userInfo:self.btn repeats:YES];
    [self.btn setEnabled:NO];
}

- (void)getCodeByDic {
    if([self.strClientType isEqualToString:@"modifyPassword"]){
        [[CRegisterClientSocket sharedInstance] getRegisterCode:self.strPhone userName:self.strUserName];
 
    }else{
        [[CRegisterClientSocket sharedInstance] getRegisterCode:self.strPhone];
 
    }
}
@end
