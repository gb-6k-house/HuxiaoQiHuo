//
//  MerpDTO.h
//  XMClient
//
//  Created by wenbo.fan on 12-10-26.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Response.h"

@interface MerpDTO : GT6ResponseData
@property int mpid;                //交易品种ID
@property NSString * mpcode;     //交易编码
@property NSString * mpname;     //商品名称
@property int mpamount;            //每手的量
@property double mpstrp;    //开盘价格
@property double mpycp;          //昨日收盘价格
@property int mpmart;              //商品市场
@property int mpstopcount;         //停盘次数*
@property int mpprecision;         //小数点后精度
@property int mpulcale;            //涨跌停控制方式
@property double mpupdecLine;      //涨跌停控制详情
@property double mppicstep;        //最小报价差*
@property int ucglmcale;           //保证金比例收取方式   0:定值 100:百分比 1000:千分比
@property double ucglmargin;       //保证金收取详情
@property int ucgldccalebuy;      //服务费收取方式 [买单]0:定值 100:百分比 1000:千分比
@property double ucgldealcostbuy; //服务费收取详情 [买单]
@property int ucgldccalesell;     //服务费收取方式  [卖单]0:定值 100:百分比 1000:千分比
@property double ucgldealcostsell;//服务费收取详情  [卖单]
@property double mpdiff;          //点差
@property double mpxchange;        //汇率
@property double span;         //跨度
@end
