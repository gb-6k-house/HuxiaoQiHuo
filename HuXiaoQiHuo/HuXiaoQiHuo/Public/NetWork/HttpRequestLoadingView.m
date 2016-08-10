//
//  HttpRequestLoadingView.m
//  WashCar
//
//  Created by zhangzhao on 4/22/15.
//  Copyright (c) 2015 NiuPark. All rights reserved.
//

#import "HttpRequestLoadingView.h"

@implementation HttpRequestLoadingView
- (id)initWithFrame:(CGRect)frame kind:(HttpRequstKind)kind tips:(NSString *)tips {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0, frame.size.width, 20)];
        [self addSubview:lbl];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:16];
        lbl.text = tips;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        
        UIActivityIndicatorView * v = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        v.center = CGPointMake(CGRectGetWidth(frame) *0.5, CGRectGetHeight(frame) *0.45);
        v.color = [UIColor whiteColor];
        [v startAnimating];
        [self addSubview:v];
        
        lbl.textColor = [UIColor whiteColor];
        lbl.center = CGPointMake(CGRectGetWidth(frame) *0.5, CGRectGetMaxY(v.frame) + 24);
    
        self.lblTitle = lbl;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//破坏事件响应
}
@end
