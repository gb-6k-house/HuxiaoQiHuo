//
//  PointTableViewCell.h
//  HuXiaoQiHuo
//
//  Created by fukeng on 1/6/16.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
//@property (weak, nonatomic) IBOutlet UIImageView *attchImg;

-(void)refreshUI:(NSDictionary*)dic;

@end
