//
//  BookAddTableViewCell.m
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/19.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "BookAddTableViewCell.h"

@implementation BookAddTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshUI:(NSDictionary*)dic{
//    Printing description of dic:
//    {
//        PLevel = "\U4e00\U7ea7\U4f1a\U5458";
//        account = hxcjfxs00301HX;
//        avatar = "http://121.43.232.204:8098/upload/default_head.png";
//        beBookNum = 1;
//        bookfee = "\U514d\U8d39\U8ba2\U9605";
//        bookfeeNum = "0.00";
//        describe = "\U56fd\U9645\U671f\U8d27\U6a21\U62df";
//        id = 1414;
//        investtype = 2;
//        levelId = 4;
//        levelNum = 1;
//        moniId = 1883;
//        muid = 891;
//        "nick_name" = "";
//        "reg_time" = "2016/5/9 11:46:01";
//        "row_number" = 1;
//        speciality = "";
//        "user_name" = hxcjfxs003;
//        "user_name_x" = hxcjfxs003;
//        "user_type" = 2;
//    }
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar"]] placeholderImage:[UIImage imageNamed:@"userName"]];
    self.userName.text = dic[@"user_name"];
    
    if ([dic[@"user_type"] integerValue] == 1) {
        self.userLevel.text = @"(普通用户)";
    }else if ([dic[@"user_type"] integerValue] == 2){
        self.userLevel.text = @"(分析师)";
    }else{
        self.userLevel.text = @"(程序化用户)";
    }
}

@end
