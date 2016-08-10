//
//  FYPositionsSubData_Obj.h
//  traderex
//
//  Created by cssoft on 15/10/26.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYPositionsSubData_Obj : NSObject

/*{"code":0,"msg":"","data":[{"cell":["1","18845","HHIV5","1","9910.00000","0.00","0.00000","0.00000","2015/10/5 16:42:52","1","0.00000","testzqtest"]}]}
 
 data里面的数据是持仓: cell按顺序: 持仓编号 子账户编号 商品码 买卖类型 持仓价 手数 止损 止盈 时间 成交类型（1即时 0委托） 利息（一般不显示）
*/

@property NSInteger nPositionsid;//持仓编号

@property NSInteger nPositionsUserid;//子账户编号

@property (nonatomic,retain) NSString * strPositionsmcode;//商品码

@property NSInteger nPositionsType;//买卖类型 1买 0卖

@property float fPositionsPrice;//持仓价

@property float fPositionsNumber;//成交手数

@property float fPositionsLossP;//止损

@property float fPositionsProfitP;//止盈

@property (nonatomic,retain) NSString *strPositionstime;//成交时间

@property NSInteger nPositionsTransactionType;// 成交类型 （1即时 0委托）

@property float fPositionsProfit;//利息

@property (nonatomic,retain) NSString * strPositionsUserName;//用户名

@property float fTestzqtest;//获利
@end
