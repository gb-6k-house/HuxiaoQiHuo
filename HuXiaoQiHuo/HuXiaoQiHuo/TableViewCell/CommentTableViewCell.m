//
//  CommentTableViewCell.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/18.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshUI:(NSDictionary*)dic{
    [self.imgHeader sd_setImageWithURL:dic[@"avatar"] placeholderImage:[UIImage imageNamed:@"userName"]];
    self.name.text = dic[@"UserName"];
    self.time.text = [ToolCore strFromTimeStr:dic[@"CreateDate"] format:@"yyyy-MM-dd"];
    self.comment.text = dic[@"Content"];
}

@end
