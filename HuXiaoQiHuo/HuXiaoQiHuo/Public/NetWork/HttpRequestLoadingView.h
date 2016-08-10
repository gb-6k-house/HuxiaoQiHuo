//
//  HttpRequestLoadingView.h
//  WashCar
//
//  Created by zhangzhao on 4/22/15.
//  Copyright (c) 2015 NiuPark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HttpRequestLoadingView : UIView
@property (weak,nonatomic)UILabel * lblTitle;
- (id)initWithFrame:(CGRect)frame kind:(HttpRequstKind)kind tips:(NSString *)tips;
@end
