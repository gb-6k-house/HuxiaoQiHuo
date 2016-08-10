//
//  TTEquityLineView.m
//  Test
//
//  Created by niupark on 16/5/17.
//  Copyright © 2016年 niupark. All rights reserved.
//

#import "TTEquityLineView.h"
@interface TTEquityLineView()
@property (nonatomic,strong)TTEquityDataSet * dataSet;
@property(nonatomic, assign)CGFloat maxEquity;
@property(nonatomic, assign)CGFloat minEquity;
@property(nonatomic, strong)NSMutableArray *leveEqutiy;
@end
@implementation TTEquityLineView

-(void)calcuMaxAndMinEquity{
    if (self.dataSet.data.count>0) {
        TTEquityEntity *entity = self.dataSet.data[0];
        self.maxEquity = entity.equity;
        self.minEquity = entity.equity;

    }
    for (TTEquityEntity *entity in self.dataSet.data) {
        if (entity.equity>_maxEquity) {
            self.maxEquity = entity.equity+0.5;
        }
        if (entity.equity < _minEquity){
            self.minEquity = entity.equity-0.5;
        }
    }
    //将净值分档
    //将净值分档
    CGFloat d = (self.maxEquity-self.minEquity)/(self.dataSet.level-1);
    if (self.maxEquity == self.minEquity) {
        d = 50.0f; //50一个档位
        self.maxEquity =  self.maxEquity + d *(self.dataSet.level/2);
        self.minEquity = self.minEquity - d *(self.dataSet.level/2);
    }    self.leveEqutiy = [NSMutableArray array];
    for (NSInteger i=0 ;i < self.dataSet.level ;i++) {
        [self.leveEqutiy addObject:@(self.minEquity+d*i)];
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef optionalContext = UIGraphicsGetCurrentContext();
    [self drawBorder:optionalContext];
    [self drawContent:optionalContext];
}
-(TTEquityDataSet*)dataSet{
    if (!_dataSet) {
        _dataSet = [[TTEquityDataSet alloc] init];
    }
    return _dataSet;
}
//画边框
-(void)drawBorder:(CGContextRef)context{
    if (!self.dataSet) {
        return;
    }
     CGContextSetLineWidth(context, self.dataSet.borderWidth);//线的宽度
     CGContextSetFillColorWithColor(context,self.dataSet.backgroundColor.CGColor);//填充颜色
     CGContextSetStrokeColorWithColor(context, self.dataSet.borderColor.CGColor);//线框颜色
     CGContextAddRect(context,self.contentRect);//画方框
     CGContextDrawPath(context,kCGPathFillStroke);//绘画路径
//     CGContextClosePath(context);
}


//日期
-(void)drawContent:(CGContextRef)context{
    
    if (!self.dataSet) {
        return;
    }
    NSString *dateStr = [NSString stringWithFormat:@"%@ 至 %@", self.dataSet.startDate, self.dataSet.endDate];
    NSDictionary * drawAttributes= @{NSFontAttributeName:self.dataSet.textFont,NSForegroundColorAttributeName:self.dataSet.textColor,NSBackgroundColorAttributeName:[UIColor clearColor]};
    
    NSMutableAttributedString * strAtt = [[NSMutableAttributedString alloc]initWithString:dateStr attributes:drawAttributes];
    CGSize strAttSize = [strAtt size];
    CGFloat dSpace = 5;
    //日期显示在右上角
    CGFloat yStar = self.contentTop + self.dataSet.borderWidth+dSpace;
    CGFloat xStar = self.contentRight-self.dataSet.borderWidth-strAttSize.width-2;
    [self drawLabel:context attributesText:strAtt rect:CGRectMake(xStar, yStar, strAttSize.width, strAttSize.height)];
    //左边净值档位, 靠右对齐
    CGFloat maxTextWidth = 0;
    for (NSInteger i = 0; i < self.leveEqutiy.count; i++) {
        strAtt = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld", (long)[self.leveEqutiy[i] integerValue]] attributes:drawAttributes];
        strAttSize = [strAtt size];
        if (strAttSize.width> maxTextWidth) {
            maxTextWidth = strAttSize.width;
        }
    }
    //界面等分
    CGFloat textRight = self.contentLeft+self.dataSet.borderWidth+maxTextWidth+dSpace;
    yStar += strAttSize.height+dSpace;
    
    CGFloat dBottomHeiht = strAttSize.height+2*dSpace;

    CGFloat dHeigth = (self.contentHeight-2*self.borderWidth-yStar-dBottomHeiht)/(self.dataSet.level-1);
    CGFloat yLineStar = yStar;
    CGFloat yLineEnd = yStar + dHeigth * (self.dataSet.level-1);
    for (NSInteger i = (self.leveEqutiy.count-1); i >= 0; i--) {
        //划线
        [self drawline:context startPoint:CGPointMake(textRight+dSpace, yStar) stopPoint:CGPointMake(self.contentRight-self.dataSet.borderWidth-dSpace,yStar) color:[UIColor lightGrayColor] lineWidth:0.5f];
        //文字
        strAtt = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld", (long)[self.leveEqutiy[i] integerValue]] attributes:drawAttributes];
        strAttSize = [strAtt size];
        xStar = textRight-strAttSize.width;
        [self drawLabel:context attributesText:strAtt rect:CGRectMake(xStar, yStar-strAttSize.height/2, strAttSize.width, strAttSize.height)];
        yStar+= dHeigth;

    }
    //连线，线从5个像素位置开始
    xStar = textRight+dSpace+5;
    //线的宽度
    CGFloat dLineWidth =  self.contentRight- 2*self.dataSet.borderWidth-4*dSpace -textRight;
    CGFloat dWidthStep = self.dataSet.data.count <= 1?dLineWidth:dLineWidth/(self.dataSet.data.count-1);
    for (NSInteger i = 0; i < self.dataSet.data.count; i++) {
        //画点
        TTEquityEntity *entity = self.dataSet.data[i];
        CGFloat yStep = (yLineEnd-yLineStar)*((entity.equity-self.minEquity)/(self.maxEquity-self.minEquity));
        [self drawCiclyPoint:context point:CGPointMake(xStar+dWidthStep*i, yLineEnd-yStep) radius:2.0f color:self.dataSet.lineColor];
        //无动画画线
//        if(i > 0){
//            //线
//            TTEquityEntity *startEntity = self.dataSet.data[i-1];
//            CGFloat yPoint = (yLineEnd-yLineStar)*((startEntity.equity-self.minEquity)/(self.maxEquity-self.minEquity));
//            [self drawline:context startPoint:CGPointMake(xStar+dWidthStep*(i-1),yLineEnd- yPoint) stopPoint:CGPointMake(xStar+dWidthStep*i,yLineEnd- yStep) color:self.dataSet.lineColor lineWidth:0.5f];
//        }
    }
    //画线，添加动画
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.frame = self.bounds;
    lineLayer.backgroundColor = [UIColor clearColor].CGColor;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    [lineLayer setStrokeColor:self.dataSet.lineColor.CGColor];
    [lineLayer setLineWidth:0.5f];
    //开始画线
    CGMutablePathRef linePath = CGPathCreateMutable();
    for (NSInteger i = 0; i < self.dataSet.data.count; i++) {
        //画点
        TTEquityEntity *entity = self.dataSet.data[i];
        CGFloat yStep = (yLineEnd-yLineStar)*((entity.equity-self.minEquity)/(self.maxEquity-self.minEquity));
        if (i == 0) {
            CGPathMoveToPoint(linePath, NULL, xStar+dWidthStep*i, yLineEnd-yStep);
            
        }
        if(i > 0){
            CGPathAddLineToPoint(linePath, NULL, xStar+dWidthStep*i, yLineEnd- yStep);
        }
    }
    lineLayer.path = linePath;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration =   2;
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    [lineLayer addAnimation:animation forKey:@"strokeEnd"];
    [self.layer addSublayer:lineLayer];
    CGPathRelease(linePath);
    
    //底部画净值标志,居中显示 ,
    strAtt = [[NSMutableAttributedString alloc]initWithString:@"净值" attributes:drawAttributes];
    strAttSize = [strAtt size];
    CGFloat dFlagWidth = 20.f;
    CGFloat xFlagLine = self.contentLeft+(self.contentWidth/2)-(strAttSize.width+dFlagWidth+dSpace)/2;
    CGFloat yFlagLine = yLineEnd+dSpace + strAttSize.height/2;
    [self drawline:context startPoint:CGPointMake(xFlagLine, yFlagLine) stopPoint:CGPointMake(xFlagLine+dFlagWidth, yFlagLine) color:self.dataSet.lineColor lineWidth:0.5f];
    [self drawLabel:context attributesText:strAtt rect:CGRectMake(xFlagLine+dFlagWidth+dSpace, yFlagLine-strAttSize.height/2, strAttSize.width, strAttSize.height)];
    [self drawCiclyPoint:context point:CGPointMake(xFlagLine+dFlagWidth/2, yFlagLine) radius:2.0f color:self.dataSet.lineColor];
                                                                      
}
-(void)setupData:(TTEquityDataSet *)dataSet{
    if (dataSet) {
        self.dataSet=dataSet;
        [self calcuMaxAndMinEquity];
        [self notifyDataSetChanged];
    }
}
@end
