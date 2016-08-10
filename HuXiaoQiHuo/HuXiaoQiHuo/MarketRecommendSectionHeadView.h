//
//  MarketRecommendSectionHeadView.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/16.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MarketRecommendSectionHeadView;
typedef void (^ExpandBlock)(BOOL expanded, MarketRecommendSectionHeadView *view);
@interface MarketRecommendSectionHeadView : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnMain;
@property(nonatomic, copy)ExpandBlock block;
-(void)configeWithData:(NSDictionary*)data;
@end
