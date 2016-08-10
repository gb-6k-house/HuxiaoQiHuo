//
//  MyBookTableViewCell.m
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/21.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "MyBookTableViewCell.h"

@implementation MyBookTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)refreshUI:(NSDictionary*)dic{
//    "row_number":"1","id":自增ID,"subscriberId":订阅人用户ID,"handCount":跟单手数,"subName":订阅人用户名,"avatar":订阅人图像地址,"speciality":擅长领域,"user_type":用户类型,"beSubscriberId":被订阅人用户ID,"avatarx":被订阅人图像地址,"bookfeeNum":订阅费用,"beSubName":被订阅人用户名,"startDate":订阅开始日期,"endDate":订阅结束日期,"remark":订阅流水号备注,"ModifyTime":修改日期,"muid":模拟账号ID,"moniId":市场子ID,"bookfee":订阅费,"account":被订阅人子账号,"describe":描述,"investtype":市场类型,"isValid":是否有效，"DiffDate":离过期的天数,"balance":账户权益,"profitmargin":收益率,"winrate":胜率,"networth":净值,"maxretracement":最大回撤 
    
//    //Printing description of dic:
//    {
//        DiffDate = 30;
//        ModifyTime = "2016/5/31 10:36:44";
//        account = jianglan00101HX;
//        avatar = "http://121.43.232.204:8098/upload/6K.jpg";
//        avatarx = "http://121.43.232.204:8098/upload/jianglan001.jpg";
//        balance = "3693565.89148";
//        beSubName = "\U957f\U6c5f\U540e\U6d6a";
//        beSubscriberId = 1343;
//        bookfee = "\U514d\U8d39\U8ba2\U9605";
//        bookfeeNum = "0.00";
//        describe = "\U56fd\U9645\U671f\U8d27\U6a21\U62df";
//        endDate = "2016/6/30 10:36:44";
//        handCount = "0.0";
//        id = 1914;
//        investtype = 2;
//        isValid = "\U6709\U6548";
//        maxretracement = "0.12476";
//        moniId = 1816;
//        muid = 631;
//        networth = "3.69357";
//        profitmargin = "2.77419";
//        "row_number" = 1;
//        speciality = "\U9ec4\U91d1";
//        startDate = "2016/5/31 10:36:44";
//        subName = 6K;
//        subscriberId = 1450;
//        "user_type" = 2;
//        winrate = "0.64423";
//    }
//    balance":账户权益,"profitmargin":收益率,"winrate":胜率,"networth":净值,"maxretracement":最大回撤 
    [self.userHeader sd_setImageWithURL:[NSURL URLWithString:dic[@"avatarx"]] placeholderImage:[UIImage imageNamed:@"userName"]];
    self.name.text = dic[@"beSubName"];
    if ([dic[@"user_type"] integerValue] == 1) {
        self.type.text = @"(普通用户)";
    }else if ([dic[@"user_type"] integerValue] == 2){
        self.type.text = @"(分析师)";
    }else{
        self.type.text = @"(程序化用户)";
    }
    [self.rateView setMarkImage:[UIImage imageNamed:@"xingxing1"]];
    [self.rateView setUnMarkImage:[UIImage imageNamed:@"xingxing2"]];
    [self.rateView setRate:[dic[@"levelNum"] doubleValue]];
    if ([dic[@"speciality"] isEqualToString:@""]) {
        self.goodAt.text = @"擅长:无";
    }else{
        self.goodAt.text = [NSString stringWithFormat:@"擅长:%@", dic[@"speciality"]];
    }
    self.voiceImage.hidden = YES;//TODO: 这个逻辑还没写
    self.percent.hidden = YES;
    self.income.text = [NSString stringWithFormat:@"净值:%.2f", [dic[@"networth"] doubleValue]];
    self.accountRight.text = [NSString stringWithFormat:@"账户权益:%.2f", [dic[@"balance"] doubleValue]];
    self.incomeRate.text = [NSString stringWithFormat:@"收益率:%.2f", [dic[@"profitmargin"] doubleValue]];
    self.maxBack.text = [NSString stringWithFormat:@"最大回撤:%.2f", [dic[@"maxretracement"] doubleValue]];
    self.winRate.text = [NSString stringWithFormat:@"胜率:%.2f%%", [dic[@"winrate"] doubleValue]*100];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy/MM/dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dic[@"startDate"]];
    NSDateFormatter *dateFormatterChange = [[NSDateFormatter alloc] init];
    [dateFormatterChange setDateFormat:@"yyyy-MM-dd"];
    
    self.bookDate.text = [dateFormatterChange stringFromDate:date];
    self.bookFee.text = [NSString stringWithFormat:@"%.2f", [dic[@"bookfee"] doubleValue]];
    self.dueDate.text = [NSString stringWithFormat:@"%ld", (long)[dic[@"DiffDate"] integerValue]];
    
}

@end
