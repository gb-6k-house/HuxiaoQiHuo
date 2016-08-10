//
//  HangTradeItemCell.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/23.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "HangTradeItemCell.h"

#define ORDSTAT_SENDING     0			// 发送中
#define ORDSTAT_WORKING     1		// 工作中
#define ORDSTAT_INACTIVE    2			// 无效/
#define ORDSTAT_PENDING     3			// 待定
#define ORDSTAT_ADDING      4			// 增加中
#define ORDSTAT_CHANGING    5		// 修改中
#define ORDSTAT_DELETING    6			// 删除中
#define ORDSTAT_INACTING    7			// 无效中
#define ORDSTAT_PARTTRD_WRK 8		// 部分已成交并且还在工作中
#define ORDSTAT_TRADED      9			// 已成交
#define ORDSTAT_DELETED     10		// 已删除埃

@implementation HangTradeItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshUI:(NSDictionary*)dic{
    NSLog(@"here");
    
//    orderlist		//订单列表,JSON的array,成员结构如下
    //    {
    //        user			//用户ID
    //        id			//订单ID
    //        mmcode		//商品编码
    //        mpname		//商品名称
    //        time			//下单时间
    //        isbuy		//1:买,0:卖
    //        number		//数量
    //        oddnumber	//未成交数量
    //        adverse		//平仓标志 1:平仓 0:建仓
    //        price			//订单价格
    //        modetype		//订单状态(见备注1)
    //        loss			//止损价格
    //        margin		//占用的保证金
    //    }
    
//    NSInteger uid = [dic[@"uid"] integerValue];			//用户ID
    NSInteger nid = [dic[@"nid"] integerValue];			//订单ID
    NSString* mmcode = dic[@"mmcode"];		//商品编码
    NSString* mpname =  dic[@"mmcode"][@"mpname"];		//商品名称
    NSString* time = dic[@"time"];		//下单时间
    BOOL isbuy = [dic[@"isbuy"] boolValue];		//1:买,0:卖
    NSInteger number = [dic[@"number"] integerValue];		//数量
//    NSInteger oddnumber = [dic[@"oddnumber"] integerValue];	//未成交数量
    BOOL adverse = [dic[@"adverse"] boolValue];	//平仓标志 1:平仓 0:建仓
//    double price = [dic[@"price"] doubleValue];  //订单价格
    NSInteger modetype = [dic[@"modetype"] integerValue];		//订单状态(见备注1)
    double loss = [dic[@"loss"] doubleValue];		//止损价格
//    double margin = [dic[@"margin"] doubleValue];		//占用的保证金

    self.lblTradeType.text = adverse ? @"平仓交易":@"建仓交易";
    self.lblDate.text = time;
    NSString *strState = @"";
    switch (modetype) {
        case ORDSTAT_SENDING:
            strState = @"状态:发送中";
            break;
        case ORDSTAT_WORKING:
            strState = @"状态:工作中";
            break;
        case ORDSTAT_INACTIVE:
            strState = @"状态:无效";
            break;
        case ORDSTAT_PENDING:
            strState = @"状态:待定中";
            break;
        case ORDSTAT_ADDING:
            strState = @"状态:增加中";
            break;
        case ORDSTAT_CHANGING:
            strState = @"状态:修改中";
            break;
        case ORDSTAT_DELETING:
            strState = @"状态:删除中";
            break;
        case ORDSTAT_INACTING:
            strState = @"状态:无效中";
            break;
        case ORDSTAT_PARTTRD_WRK:
            strState = @"状态:部分已成交并且还在工作中";
            break;
        case ORDSTAT_TRADED:
            strState = @"已成交";
            break;
        case ORDSTAT_DELETED:
            strState = @"状态:占用的保证金";
            break;
        default:
            break;
    }
    self.lblStatus.text = strState;
    self.lblStockTitle.text = mpname;
    self.lblStockSubTitle.text = mmcode;
    self.lblPositionID.text = [NSString stringWithFormat:@"持仓号:%ld", (long)nid];; //TODO: 这个数据没有，持仓号
    self.lblPositionAmount.text = [NSString stringWithFormat:@"持仓数量:%ld", (long)number];
    self.lblPositionType.text = isbuy ? @"买":@"卖";
    self.lblExecutePrice.text = @"无"; //TODO: 执行价格
    self.lblStopPrice.text = [NSString stringWithFormat:@"%.2f", loss];
    self.lblRealPrice.text = @"无"; //TODO: 真实价格
    
}

@end
