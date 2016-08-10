//
//  CGraphClientSocket.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/27.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "CClientSocket.h"

@interface CGraphClientSocket : CClientSocket
/**
 *  @author LiuK, 16-05-30 15:05:53
 *
 *  获取商品的1分钟K线图数据
 */
-(void)download1mGraphByMpIndex:(NSNumber*)mpIndex startTime:(NSString*)startTime endTime:(NSString*)endTime;
/**
 *  @author LiuK, 16-05-30 16:05:10
 *
 *  获取商品的1天K线图数据
 *
 *  @param mpIndex <#mpIndex description#>
 */
-(void)download1DGraphByMpIndex:(NSNumber*)mpIndex startTime:(NSString*)startTime endTime:(NSString*)endTime;
/**
 *  @author LiuK, 16-05-30 16:05:42
 *
 *  分时图
 *
 *  @param mpIndex   <#mpIndex description#>
 *  @param startTime <#startTime description#>
 *  @param endTime   <#endTime description#>
 */
-(void)downloadTimeGraphByMpIndex:(NSNumber*)mpIndex startTime:(NSString*)startTime endTime:(NSString*)endTime;

@end
