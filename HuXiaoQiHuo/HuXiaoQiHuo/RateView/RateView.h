//
//  RateView.h
//  WashCarMechanic
//
//  Created by niupark on 15/10/26.
//  Copyright © 2015年 niupark. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface RateView : UIView
@property(nonatomic, assign)IBInspectable CGFloat rate ; //[0,5]
@property(nonatomic, strong)IBInspectable UIImage *markImage;
@property(nonatomic, strong)IBInspectable UIImage *unMarkImage;
@end
