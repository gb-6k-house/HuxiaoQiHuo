//
//  UILableStrikeThrough.m
//  WashCarShop
//
//  Created by zhangzhao on 5/14/14.
//  Copyright (c) 2014 NiuPark. All rights reserved.
//

#import "UILabelStrikeThrough.h"

@implementation UILabelStrikeThrough
- (void)drawRect:(CGRect)rect
{
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGFloat black[4] = {0.5f, 0.5f, 0.5f, 1.0f};//灰色
    CGContextSetStrokeColor(c, black);
    CGContextSetLineWidth(c, 1);
    CGContextBeginPath(c);
    //画直线
    NSDictionary *attributes = @{NSFontAttributeName: self.font};
    CGRect rc = [self.text boundingRectWithSize:CGSizeMake(256, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attributes
                                           context:nil];
    CGFloat halfWayUp = rect.size.height/2 + rect.origin.y;
    CGContextMoveToPoint(c, rect.size.width - rc.origin.x+10, halfWayUp );//开始点
    CGContextAddLineToPoint(c, rect.size.width - rc.origin.x - rc.size.width, halfWayUp);//结束点
    //画斜线
    CGContextStrokePath(c);
    [super drawRect:rect];
}
@end
