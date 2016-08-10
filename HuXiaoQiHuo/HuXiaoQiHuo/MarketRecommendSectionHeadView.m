//
//  MarketRecommendSectionHeadView.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/16.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "MarketRecommendSectionHeadView.h"

@implementation MarketRecommendSectionHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)configeWithData:(NSDictionary*)data{
    self.btnMain.tag = [data[@"expand"] boolValue]?1:0;
    if (self.btnMain.tag == 0) {
        [self.btnMain setImage:[UIImage imageNamed:@"xiangyou"] forState:UIControlStateNormal];
    }else{
        [self.btnMain setImage:[UIImage imageNamed:@"xiangxia"] forState:UIControlStateNormal];
    }
    [self.btnMain setTitle:data[@"title"] forState:UIControlStateNormal];
}

- (IBAction)expandAction:(UIButton *)sender {
    if (self.btnMain.tag == 0) {
        [self.btnMain setImage:[UIImage imageNamed:@"xiangxia"] forState:UIControlStateNormal];
        self.btnMain.tag = 1;
        
    }else{
        self.btnMain.tag = 0;
        [self.btnMain setImage:[UIImage imageNamed:@"xiangyou"] forState:UIControlStateNormal];
    }
    if (self.block) {
        self.block(self.btnMain.tag == 1, self);
    }
}
@end
