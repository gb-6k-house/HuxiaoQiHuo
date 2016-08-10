//
//  NotifyTableViewCell.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/13.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotifyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *actionInfo;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *messageState;

-(void)refreshUI:(NSDictionary *)dicData;

@end
