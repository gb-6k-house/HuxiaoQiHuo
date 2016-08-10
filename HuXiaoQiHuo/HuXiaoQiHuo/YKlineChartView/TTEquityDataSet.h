//
//  TTEquityDataSet.h
//  Test
//
//  Created by niupark on 16/5/17.
//  Copyright © 2016年 niupark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TTEquityDataSet : NSObject
@property (nonatomic,strong)NSMutableArray * data;
@property(nonatomic,assign)NSInteger level;//等级 缺省6个等级
@property (nonatomic,assign)UIColor  *borderColor;//边框颜色
@property (nonatomic,assign)CGFloat  borderWidth; //边框宽度
@property (nonatomic,assign)UIColor  *backgroundColor;//边框颜色
@property (nonatomic,assign)UIColor  *textColor;//文字颜色
@property (nonatomic,assign)UIFont   *textFont;//文字字体
@property (nonatomic,assign)UIColor  *lineColor;//文字颜色
@property (nonatomic,copy)NSString  *startDate; //开始日期
@property (nonatomic,copy)NSString  *endDate; //结束日期

@end
