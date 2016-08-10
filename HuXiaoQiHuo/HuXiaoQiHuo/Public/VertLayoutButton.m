//
//  VertLayoutButton.m
//  YouChi
//
//  Created by niupark on 16/1/28.
//  Copyright © 2016年 FKLK. All rights reserved.
//

#import "VertLayoutButton.h"

@implementation VertLayoutButton

-(void)layoutSubviews {
     [super layoutSubviews];
    CGRect imageFrame = [self imageView].frame;

    CGRect lblFrame = [self titleLabel].frame;
    //lable和image间距设置5
    CGFloat h = imageFrame.size.height+lblFrame.size.height +2;
    CGFloat s = (self.frame.size.height-h)/2;
    
     // Center image
     CGPoint center = self.imageView.center;
     center.x = self.frame.size.width/2;
     center.y = self.imageView.frame.size.height/2+s;
     self.imageView.center = center;
    
    
    center.x = self.frame.size.width/2;
    center.y = h+s-lblFrame.size.height;

     //Center text
     CGRect newFrame = [self titleLabel].frame;
     newFrame.origin.x = 0;
     newFrame.origin.y = h+s-lblFrame.size.height;
     newFrame.size.width = self.frame.size.width;
     
     self.titleLabel.frame = newFrame;
     self.titleLabel.textAlignment = NSTextAlignmentCenter;
 }

@end
