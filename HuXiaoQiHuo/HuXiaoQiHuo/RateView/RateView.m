//
//  RateView.m
//  WashCarMechanic
//
//  Created by niupark on 15/10/26.
//  Copyright © 2015年 niupark. All rights reserved.
//

#import "RateView.h"
#define START_COUNT 5
@interface RateView();
@property(nonatomic, strong)NSMutableArray *starImgV;
@end
@implementation RateView

//合并两张图片
- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    //UIGraphicsBeginImageContext(image1.size);
    UIGraphicsBeginImageContextWithOptions(image1.size, NO, image1.scale);
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    // Draw image2
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

-(void)setRate:(CGFloat)rate{
    _rate = rate;
    CGSize viewSize = self.bounds.size;
    CGSize imgeSize = self.unMarkImage.size;
    //初始化界面
    if (self.starImgV == nil){
        //放置5个imvageView
        self.starImgV = [NSMutableArray array];
        //根据view和image的大小计算image直接的间距
        CGFloat spaceX = (viewSize.width- 5*imgeSize.width)/4;
        //添加5张ImageView ,
        for (int i= 0; i< 5; i++) {
            UIImageView * imgv  = [[UIImageView alloc] initWithImage:self.unMarkImage];
            imgv.frame = CGRectMake(0, 0, imgeSize.width, imgeSize.height);
            imgv.center = CGPointMake(i*imgeSize.width + spaceX * i + imgeSize.width/2, viewSize.height/2);
            imgv.userInteractionEnabled = YES;
            [self addSubview:imgv];
            //imgv.backgroundColor = [UIColor blackColor];
            [self.starImgV addObject:imgv];
        }
    }else {
        for (UIImageView *imgV in self.starImgV){
            [imgV setImage:self.unMarkImage];
        }
    }
    int n = (int)self.rate; //强制转换获取整数位
    CGFloat fPer = (self.rate-n);  //小数部分所占图像的百分比
    for (int i =0; i < n; i++) {
        [ (UIImageView *)[self.starImgV objectAtIndex:i] setImage:self.markImage];
    }
    if (fPer > 0) {
        //按比例截取图像
        CGImageRef rateImageRef = CGImageCreateWithImageInRect(self.markImage.CGImage, CGRectMake(0, 0,CGImageGetWidth(self.markImage.CGImage)*fPer, CGImageGetHeight(self.markImage.CGImage)));
        UIImage* rateImage = [UIImage imageWithCGImage:rateImageRef scale:self.markImage.scale orientation:UIImageOrientationUp];
        [(UIImageView *)[self.starImgV objectAtIndex:n] setImage:[self addImage:self.unMarkImage toImage:rateImage]];
        CGImageRelease(rateImageRef);

    }
    //[self setNeedsDisplay];
}
@end
