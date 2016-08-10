//
//  Response.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/19.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "Response.h"

@implementation Response
-(NSString*)reason{
    NSString * msg = nil;
    switch (self.rst) {
            
        case 0:
            
            break;
            
        case 1:
            
            msg = @"错误命令代码！";
            break;
            
        case 2:
            
            msg = @"用户不存在！";
            break;
            
        case 3:
            msg = @"密码错误！";
            break;
            
        case 4:
            
            msg = @"参数不正确！";
            break;
            
        case 5:
            
            msg = @"余额不足！";
            break;
            
        case 6:
            
            msg = @"市场代码错误！";
            break;
            
        case 7:
            
            msg = @"没有查找到手机号！";
            break;
            
        case 8:
            
            msg = @"验证码过期！";
            break;
            
        case 9:
            
            msg = @"验证码不匹配！";
            break;
            
        case 10:
            
            msg= @"验证码不正确！";
            break;
        case 11:
            msg = @"手机号码不正确！";
            break;
            
        case 12:
            
            msg= @"手机号已注册！";
            break;
            
        case 13:
            
            msg = @"不能发广播消息！";
            break;
            
        case 14:
            
            msg = @"申请正在审核中！";
            break;
            
        case 15:
            msg = @"手机号码不正确！";
            break;
            
        case 16:
            
            msg = @"消息服务器ID不正确！";
            break;
            
        case 17:
            
            msg = @"用户名已注册！";
            break;
            
        case 18:
            
            msg = @"邀请码不正确！";
            break;
            
            //        case 19:
            //
            //            msg = @"URL超时！";
            //            break;
            //        case 20:
            //
            //            msg = @"手机验证码错误！";
            //            break;
            //        case 21:
            //
            //            msg = @"修改密码失败！";
            //            break;
            //        case 22:
            //
            //            msg = @"用户名或者手机号码错误！";
            //            break;
            //        case 23:
            //
            //            msg = @"邀请码不正确！";
            //            break;
            //        case 24:
            //
            //            msg = @"邀请码不正确！";
            //            break;
            //        case 25:
            //
            //            msg = @"邀请码不正确！";
            //            break;
            //        case 26:
            //
            //            msg = @"邀请码不正确！";
            //            break;
            //
            //        case 27:
            //
            //            msg = @"邀请码不正确！";
            //            break;
            //        case 28:
            //
            //            msg = @"邀请码不正确！";
            //            break;
            //        case 29:
            //
            //            msg = @"邀请码不正确！";
            //            break;
            //        case 30:
            //
            //            msg = @"邀请码不正确！";
            //            break;
            //        case 31:
            //
            //            msg = @"邀请码不正确！";
            //            break;
            //        case 32:
            //
            //            msg = @"邀请码不正确！";
            //            break;
            //        case 33:
            //
            //            msg = @"邀请码不正确！";
            //            break;
            //        case 34:
            //
            //            msg = @"邀请码不正确！";
            //            break;
            //        case 35:
            //            
            //            msg = @"邀请码不正确！";
            //            break;
            //        case 36:
            //            
            //            msg = @"邀请码不正确！";
            //            break;
            //        case 37:
            //            
            //            msg = @"邀请码不正确！";
            //            break;
            //        case 38:
            //            
            //            msg = @"邀请码不正确！";
            //            break;
            //        case 39:
            //            
            //            msg = @"邀请码不正确！";
            //            break;
            //        case 40:
            //            
            //            msg = @"邀请码不正确！";
            //            break;
            //        case 41:
            //            
            //            msg = @"邀请码不正确！";
            //            break;
            
        default:
            msg = @"服务器访问失败！";
            break;
    }
    return msg;
}
@end
