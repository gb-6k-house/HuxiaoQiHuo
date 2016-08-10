//
//  CPriceClientSocket.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/26.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "CClientSocket.h"
/**
 *  @author LiuK, 16-05-26 15:05:33
 *
 *  行情推送服务， 行情的数据保存在CTradeClientSocket#dicPriceData
 */
@interface CPriceClientSocket : CClientSocket
//获取商品的市场信息
-(void)updateMarketInfoWithMpIndexs:(NSSet*)mpIndexs;
@end
