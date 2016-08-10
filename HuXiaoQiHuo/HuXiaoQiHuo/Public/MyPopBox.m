//
//  MyPopBox.m
//  Bussiness
//
//  Created by liukai on 14-8-14.
//  Copyright (c) 2014年 yhc. All rights reserved.
//

#import "MyPopBox.h"
#define RGBA(R,G,B,A) [UIColor colorWithRed:R/255.0F green:G/255.0F blue:B/255.0F alpha:A]

@interface MyPopBox()
@property(nonatomic, retain)UITapGestureRecognizer *singleTap;
@end
@implementation MyPopBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)init{
    self = [super init];
    if (self) {
        //缺省样式
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
        self.singleTap.delegate = self;
        self.singleTap.numberOfTapsRequired = 1;
        self.singleTap.numberOfTouchesRequired = 1;
        self.style = MyPopBoxStyleNormal;

    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)dealloc{
}
-(void)setStyle:(MyPopBoxStyle)style{
    if (MyPopBoxStyleNonAutoDisplay & style) {
        [self removeGestureRecognizer:self.singleTap];
    }else{
        [self addGestureRecognizer:self.singleTap];
    }
    _style = style;
}
-(void)tapClicked:(UITapGestureRecognizer*)tap{
    [self hide];
}

//在superview上显示窗口
-(void)showView:(UIView*)view inSuperView:(UIView*)superView{
    if (!view||!superView) return;
    void (^block)(void) = ^{
        self.frame = superView.bounds;
        [self addSubview:view];
        if (!(MyPopBoxStyleExternalCoordinate & self.style)) {
            view.center = CGPointMake(self.bounds.size.width / 2,
                                      self.bounds.size.height / 2);
        }
        [superView addSubview:self];
    };
    dispatch_async(dispatch_get_main_queue(),block);
    
}
//windows上显示
-(void)showView:(UIView *)view{
    UIWindow *window= [UIApplication sharedApplication].keyWindow;
    [self showView:view inSuperView:window];
}
+(MyPopBox*)defualPopBox{
    MyPopBox *box = [[MyPopBox alloc] init];
    return box;
}
-(void)hide{
    if(self.delegate && [self.delegate respondsToSelector:@selector(dismissPopView)]){
        [self.delegate dismissPopView];
    }
    [self removeFromSuperview];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 取消UITableViewCellContentView
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}


@end
