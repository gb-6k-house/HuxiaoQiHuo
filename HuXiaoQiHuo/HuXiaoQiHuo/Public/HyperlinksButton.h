//
//  HyperlinksButton.h
//  YouChi
//
//  Created by niupark on 16/1/19.
//  Copyright © 2016年 FKLK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HyperlinksButton : UIButton
{
    UIColor *lineColor;
    float lineHeight;
    NSInteger lineDistance;
}
-(void)setColor:(UIColor*)color;
-(void)setHeight:(float)height;
-(void)setDistance:(NSInteger)distance;

-(void)setAttributeWithColor:(UIColor*)color withHeight:(float)height withDistance:(NSInteger)distance;

@end
