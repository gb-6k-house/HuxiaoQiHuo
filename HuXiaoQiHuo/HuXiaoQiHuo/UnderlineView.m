//
//  UnderlineView.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/13.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "UnderlineView.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation UnderlineView{
    UIView*_underline;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    _underline = [UIView new];
    _underline.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [self addSubview:_underline];
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    _underline = [UIView new];
    _underline.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [self addSubview:_underline];
    return self;
    
}

-(void)layoutSubviews{
    _underline.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
}
-(void)setUnderlineColor:(UIColor *)underlineColor{
    _underline.backgroundColor = underlineColor;
    _underlineColor = underlineColor;
}
@end
