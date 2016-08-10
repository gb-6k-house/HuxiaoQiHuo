//
//  MainMasterTableViewCell.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/16.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "MainMasterTableViewCell.h"

@implementation MainMasterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshUI:(NSDictionary*)dic{
    _lblLevel.hidden = YES;
    _imgLevel.hidden = NO;
    _imgAlreadyBooked.hidden = YES;
    if ([dic[@"row_id"] intValue] == 1) {
        _imgLevel.image = [UIImage imageNamed:@"first"];
    }else if ([dic[@"row_id"] intValue] == 2){
        _imgLevel.image = [UIImage imageNamed:@"second"];
    }else if ([dic[@"row_id"] intValue] == 3){
        _imgLevel.image = [UIImage imageNamed:@"third"];
    }else{
        _lblLevel.hidden = NO;
        _imgLevel.hidden = YES;
        _lblLevel.text = [NSString stringWithFormat:@"%d", [dic[@"row_id"] intValue]];
    }
    
    if ([dic[@"booked"] boolValue]) {
        _imgAlreadyBooked.hidden = NO;
        _btnBook.hidden = YES;
    }else{
        _imgAlreadyBooked.hidden = YES;
        _btnBook.hidden = NO;
    }
    
//    "USER_NAME" = jianglan001;
//    avatar = "http://121.43.232.204:8098/upload/jianglan001.jpg";
//    balance = "3697131.78";
//    calcdate = "2016/5/19 6:00:02";
//    id = 1343;
//    maxretracement = "12.48";
//    muid = 631;
//    myrowid = "";
//    networth = "3.69713";
//    "nick_name" = "\U957f\U6c5f\U540e\U6d6a";
//    plevel = 1;
//    "pt_name" = "\U9ec4\U91d1";
//    "row_count" = 56;
//    "row_id" = 1;
//    speciality = 2;
//    subMoney = "0.0000";
//    "sub_be_count" = 12;
//    "sub_fee_id" = 1816;
//    sumnum = 414;
//    sumprofit = "2777364.34";
//    "user_type" = 2;
//    winrate = "64.73";
//USER_NAME:用户名 id:用户ID avatar:用户图像地址 speciality:擅长方向ID plevel 星级 sumprofit：收益 winrate：胜率 净值：networth sub_be_count：被订阅次数 submoney:订阅费用 rowid:排名

    [self.imgHeader sd_setImageWithURL:dic[@"avatar"] placeholderImage:[UIImage imageNamed:@"userName"]];
    if ([dic[@"nick_name"] isEqualToString:@""] || dic[@"nick_name"] == nil) {
        _name.text = dic[@"USER_NAME"];
    }else{
        _name.text = dic[@"nick_name"];
    }
    _goodatInfo.text = dic[@"pt_name"];
    _winRate.text = dic[@"winrate"];
    _vRate.markImage = [UIImage imageNamed:@"xingxing1"];
    _vRate.unMarkImage = [UIImage imageNamed:@"xingxing2"];
    _vRate.rate = [dic[@"plevel"] integerValue];
}

@end
