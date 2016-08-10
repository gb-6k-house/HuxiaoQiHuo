//
//  TTKeyBoardManager.m
//  WashCarMechanic
//
//  Created by niupark on 16/5/5.
//  Copyright © 2016年 niupark. All rights reserved.
//

#import "TTKeyBoardManager.h"
#import <UIKit/UITapGestureRecognizer.h>
#import <UIKit/UITextField.h>
#import <UIKit/UITouch.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIViewController.h>
#import <UIKit/UIScreen.h>

@interface TTKeyBoardManager()<UIGestureRecognizerDelegate>{
    UIView *_textFieldView;
    UITapGestureRecognizer  *_tapGesture;
}
@end
@implementation UIView(viewController)


- (UIViewController *)viewController {
    UIResponder *nextResponder =  self;
    do
    {
        nextResponder = [nextResponder nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;
        
    } while (nextResponder != nil);
    
    return nil;
}

@end

@implementation TTKeyBoardManager
+ (instancetype)sharedInstance
{
    static TTKeyBoardManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc ] init];
    });
    
    return _sharedInstance;
}

-(instancetype)init
{
    if (self = [super init])
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            //  Registering for keyboard notification.
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
            //  Registering for textField notification.
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldViewDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
            _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
            [_tapGesture setDelegate:self];
            _enable = NO;


        });
    }
    return self;
}

-(void)keyboardWillShow:(NSNotification*)aNotification
{
    //_kbShowNotification = aNotification;
    if (_enable == NO)	return;
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardEndY = keyboardRect.origin.y;
    
    UIView *firstResponder = _textFieldView;
    UIView *ctrView = [_textFieldView viewController].view;
    CGFloat txtCodeY = CGRectGetMaxY([firstResponder.superview convertRect:firstResponder.frame toView:ctrView]);
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    if (keyBoardEndY < txtCodeY) {
        NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        [UIView animateWithDuration:duration.doubleValue animations:^{
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationCurve:[curve intValue]];
            ctrView.center = CGPointMake(ctrView.center.x, (screenH/2 - (txtCodeY - keyBoardEndY)) - 4);//Y值上移偏差＝输入框最大Y值－键盘初始Y值
        }];
    }

}
- (void)keyboardWillHide:(NSNotification*)aNotification{
    if (_enable == NO)	return;
    UIView *ctrView = [_textFieldView viewController].view;
    ctrView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);

}


- (void)keyboardDidHide:(NSNotification*)aNotification{
    
}
#pragma mark - UITextFieldView Delegate methods

-(void)textFieldViewDidBeginEditing:(NSNotification*)notification
{
    if (_enable == NO)	return;
    _textFieldView = notification.object;
//    [_textFieldView.window addGestureRecognizer:_tapGesture];
    [[_textFieldView viewController].view addGestureRecognizer:_tapGesture];

}
-(void)textFieldViewDidEndEditing:(NSNotification*)notification{
    if (_enable == NO)	return;
    [[_textFieldView viewController].view removeGestureRecognizer:_tapGesture];
}


#pragma mark AutoResign methods
//隐藏键盘
- (void)tapRecognized:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [gesture.view endEditing:YES];
    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}


//不处理子控件的点击操作
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return [[touch view] isKindOfClass:[UIControl class]] ? NO : YES;
}

#pragma mark - Dealloc
-(void)dealloc
{
    [self setEnable:NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
