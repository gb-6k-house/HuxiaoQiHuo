//
//  UIColor+YouChi.m
//  YouChi
//
//  Created by niupark on 16/1/18.
//  Copyright © 2016年 FKLK. All rights reserved.
//

#import "UIColor+YouChi.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation UIColor (YouChi)
+ (UIColor *)YColorGreen {
    return UIColorFromRGB(0x00D04B);
}
+ (UIColor *)YColorBlack {
    return [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];

}

+ (UIColor *)YColorGray {
    return [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    
}

+ (UIColor *)YColorMindGray {
    return [UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:1.0];
    
}
+ (UIColor *)YColorBackGroudGray{
    return [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    
}
+ (UIColor *)YColorLineGray {
    return [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    
}
+ (UIColor *)YColorRed{
    return UIColorFromRGB(0xFF5E60);
    
}
+ (UIColor *)YColorOrange{
    return [UIColor colorWithRed:255/255.0 green:71/255.0 blue:43/255.0 alpha:1.0];
}
+ (UIColor *)YColorBlue {
    return [UIColor colorWithRed:0.0/255.0 green:127/255.0 blue:255/255.0 alpha:1.0];
}
+ (UIColor *)YColorForPrice:(double)price{
    return price > 0?[UIColor YColorRed]:price <0?[UIColor YColorGreen]:[UIColor YColorBlack];
}

@end
