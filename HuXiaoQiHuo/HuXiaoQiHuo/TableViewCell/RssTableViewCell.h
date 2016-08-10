//
//  RssTableViewCell.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/13.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RssTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rssTime;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userLevel;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UILabel *accountMoney;
@property (weak, nonatomic) IBOutlet UILabel *todayMoney;
@property (weak, nonatomic) IBOutlet UILabel *winRate;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *typeName;
@property (weak, nonatomic) IBOutlet UILabel *typeDate;
@property (weak, nonatomic) IBOutlet UILabel *dealPrice;
@property (weak, nonatomic) IBOutlet UILabel *dealNumber;
@property (weak, nonatomic) IBOutlet UILabel *dealMoney;
@property (weak, nonatomic) IBOutlet UIImageView *messageState;


-(void)refreshUI:(NSDictionary *)dicData;

@end
