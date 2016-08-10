//
//  Subscription_Search_Request_Obj.h
//  traderex
//
//  Created by cssoft on 15/12/1.
//  Copyright © 2015年 EasyFly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Subscription_Search_Request_Obj : NSObject

@property int nSID;
@property NSInteger ntotalpage;
@property NSInteger ncurrentpage;

@property (nonatomic,retain) NSMutableArray *arraySearchRequestData;

@end
