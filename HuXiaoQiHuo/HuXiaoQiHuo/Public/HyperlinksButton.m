//
//  HyperlinksButton.m
//  YouChi
//
//  Created by niupark on 16/1/19.
//  Copyright © 2016年 FKLK. All rights reserved.
//

#import "HyperlinksButton.h"

@implementation HyperlinksButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        lineHeight = 1.0;
    }
    return self;
}

-(void)setColor:(UIColor *)color{
    lineColor = [color copy];
    [self setNeedsDisplay];
}

-(void)setHeight:(float)height{
    lineHeight = height;
    [self setNeedsDisplay];
}

-(void)setDistance:(NSInteger)distance{
    lineDistance = distance;
    [self setNeedsDisplay];
}

-(void)setAttributeWithColor:(UIColor*)color withHeight:(float)height withDistance:(NSInteger)distance{
    lineColor = color;
    lineHeight = height;
    lineDistance = distance;
    [self setNeedsDisplay];
}


- (void) drawRect:(CGRect)rect {
    CGRect textRect = self.titleLabel.frame;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGFloat descender = self.titleLabel.font.descender;
    if([lineColor isKindOfClass:[UIColor class]]){
        CGContextSetStrokeColorWithColor(contextRef, lineColor.CGColor);
    }
    
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender + lineDistance);
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender + lineDistance);
    CGContextSetLineWidth(contextRef, lineHeight);//设置线的宽度, 默认是1像纛
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathStroke);
}
@end
