//
//  CSocketListenerManager.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/20.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  @author LiuK, 16-05-20 09:05:32
 *
 *  所有socke回调对象管理者。所有需要获取socke返回的对象，需要先registeListener
 * 然后实现对于的回调协议即可
 */
@interface CSocketListenerManager : NSObject
+ (instancetype)sharedInstance;
-(void)registerListener:(NSObject *)observer;
-(void)unregisterListener:(NSObject *)observer;
-(void)callBack:(SEL)sel withObjcet:(id)object;
@end
