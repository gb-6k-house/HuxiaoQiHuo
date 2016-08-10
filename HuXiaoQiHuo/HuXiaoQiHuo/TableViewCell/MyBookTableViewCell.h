//
//  MyBookTableViewCell.h
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/21.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@interface MyBookTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userHeader;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet RateView *rateView;
@property (weak, nonatomic) IBOutlet UILabel *goodAt;
@property (weak, nonatomic) IBOutlet UILabel *percent;
@property (weak, nonatomic) IBOutlet UIImageView *voiceImage;
@property (weak, nonatomic) IBOutlet UILabel *incomeAssessment;
@property (weak, nonatomic) IBOutlet UILabel *accountRight;
@property (weak, nonatomic) IBOutlet UILabel *income;
@property (weak, nonatomic) IBOutlet UILabel *incomeRate;
@property (weak, nonatomic) IBOutlet UILabel *maxBack;
@property (weak, nonatomic) IBOutlet UILabel *winRate;
@property (weak, nonatomic) IBOutlet UILabel *bookDate;
@property (weak, nonatomic) IBOutlet UILabel *bookFee;
@property (weak, nonatomic) IBOutlet UILabel *dueDate;

-(void)refreshUI:(NSDictionary*)dic;

@end
