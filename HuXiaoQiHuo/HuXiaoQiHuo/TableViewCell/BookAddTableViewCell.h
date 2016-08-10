//
//  BookAddTableViewCell.h
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/19.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookAddTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userLevel;

-(void)refreshUI:(NSDictionary*)dic;
@end
