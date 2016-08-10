//
//  CGraphManager.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/31.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGraphManager : NSObject
//+ (instancetype)sharedInstance;
/**
 *  @author LiuK, 16-05-31 10:05:43
 *
 *  获取商品的K线图数据
 *
 *  @param mpIndex       <#mpcode description#>
 *  @param strGraphType <#strGraphType description#>
 */
-(void)getKLineDataByMpCode:(NSNumber*)mpIndex graphType:(NSString *)strGraphType;
@end
