//
//  MainMasterTableViewCell.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/16.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@interface MainMasterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgLevel;
@property (weak, nonatomic) IBOutlet UILabel *lblLevel;
@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *goodatInfo;
@property (weak, nonatomic) IBOutlet UILabel *winRate;
@property (weak, nonatomic) IBOutlet UIButton *btnBook;
@property (weak, nonatomic) IBOutlet UIImageView *imgAlreadyBooked;
@property (weak, nonatomic) IBOutlet RateView *vRate;

-(void)refreshUI:(NSDictionary*)dic;

@end
