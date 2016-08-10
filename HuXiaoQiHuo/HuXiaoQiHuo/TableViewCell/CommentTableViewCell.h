//
//  CommentTableViewCell.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/18.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *comment;


-(void)refreshUI:(NSDictionary*)dic;

@end
