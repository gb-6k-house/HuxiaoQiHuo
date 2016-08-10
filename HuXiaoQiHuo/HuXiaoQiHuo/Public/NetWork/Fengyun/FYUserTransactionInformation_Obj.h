//
//  FYUserTransactionInformation_Obj.h
//  traderex
//
//  Created by cssoft on 15/10/26.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYUserTransactionInformation_Obj : NSObject

/*返回结果:{"uid":18845,"Balance":63708.00,"Profit":-936292.00,"Yield":-0.94,"WinRange":0.06}*/

@property NSInteger nUid;//被订阅的子账户

@property  float fBalance;//余额

@property  float fProfit;//收益

@property  float fYield;//收益率

@property  float fWinRange;//胜率

@end
