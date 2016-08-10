//
//  TTBaseViewController.m
//  YouChi
//
//  Created by niupark on 16/1/14.
//  Copyright © 2016年 FKLK. All rights reserved.
//

#import "TTBaseViewController.h"
#import "CSocketListenerManager.h"
#import "MTA.h"
@interface TTBaseViewController (){
    BOOL _isAppear;
}

@property(copy, nonatomic)void (^lastBackBlock)(id data); //上个界面需要的返回处理函数，只是临时变量
@property(copy, nonatomic)void (^backBlock)(id data); //返回处理函数

@property(nonatomic) BOOL isShowBack;

@end

@interface UINavigationController (TTBaseViewController)
@property(nonatomic, strong)id<UIGestureRecognizerDelegate> rightSwipDelegate;
@end


@implementation UINavigationController(TTBaseViewController)

static const char TTrightSwipDelegateKey = '\0';
-(id<UIGestureRecognizerDelegate>)rightSwipDelegate{
    return  objc_getAssociatedObject(self, &TTrightSwipDelegateKey);
}
-(void)setRightSwipDelegate:(id<UIGestureRecognizerDelegate>)rightSwipDelegate{
    objc_setAssociatedObject(self, &TTrightSwipDelegateKey,
                             rightSwipDelegate, OBJC_ASSOCIATION_RETAIN);
}
@end

@implementation TTBaseViewController

#ifdef DEBUG
-(void)dealloc{
    NSLog(@"%@ 销毁...", NSStringFromClass([self class]));
    [[CSocketListenerManager sharedInstance] unregisterListener:self];
}
#endif
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[CSocketListenerManager sharedInstance] registerListener:self];

    // Do any additional setup after loading the view.
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabBarBkg"] forBarMetrics:UIBarMetricsDefault];
    
    // 自定义导航栏的"返回"按钮
    self.navigationController.navigationItem.hidesBackButton = YES;
    self.isShowBack = YES;
    
}


-(void)setShowBackButton:(BOOL)isShow{
    self.isShowBack = isShow;
}

-(void)goBackAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _isAppear = YES;
    [MTA trackPageViewBegin:NSStringFromClass([self class])];

    //开启ios右滑返回
    [self rightSwipBackEnable:YES];

    [self.navigationController setNavigationBarHidden:NO];
    if (self.isShowBack) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(12, 22, 10, 19);
        [btn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [btn addTarget:self action: @selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
        
        self.back = [[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = self.back;
        
        [self setTabBarHidden:YES];
    }else{
        [self setTabBarHidden:NO];
    }
}

-(UIWindow*)window{
    return [UIApplication sharedApplication].keyWindow;
}

-(void)rightSwipBackEnable:(BOOL)enable{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (self.navigationController.interactivePopGestureRecognizer.delegate) {
            self.navigationController.rightSwipDelegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        }
        if (enable) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }else{
            self.navigationController.interactivePopGestureRecognizer.delegate = self.navigationController.rightSwipDelegate;
        }
    }
}
-(BOOL)isApear{
    return _isAppear;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _isAppear = NO;
    [MTA trackPageViewEnd:NSStringFromClass([self class])];
    
}

-(void)configureWithData:(id)data{
    NSLog(@"%@ 初始化...", NSStringFromClass([self class]));
    //
}

-(void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender completion:(void (^)(id data))completion{
    
    /*
     * 此处使用了一点技巧，self.lastBackBlock不直接等于completion，
     * 如果直接等于,那么completion如果有调用self的时候就会存在循环调用，除非completion中__weak方式传递self
     * 此处用另外一个block调用completion，这样completion中使用self就不会存在循环调用的问题。
     */
    //    self.lastBackBlock = completion; 最好不这样
    self.lastBackBlock = ^ void (id data) {
        if (completion!=nil) {
            completion(data);
        }
    };
    [self performSegueWithIdentifier:identifier sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *ctl = [segue destinationViewController];
    if ([ctl respondsToSelector:@selector(configureWithData:)] && [ctl view]) {
        ((TTBaseViewController*)ctl).backBlock = self.lastBackBlock;
        self.lastBackBlock = nil;
        [ctl performSelector:@selector(configureWithData:) withObject:sender];
    }
    
}

-(void)completeWithData:(id)data{
    if (self.backBlock != nil) {
        self.backBlock(data);
    }
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)configeRefreshTableView:(UITableView*)tableView headBlock:(MJRefreshComponentRefreshingBlock)headBlock footBlock:(MJRefreshComponentRefreshingBlock)footBlock{
    if (headBlock != nil) {
        tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:headBlock];
    }
    if (footBlock !=nil) {
        tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:footBlock];
        tableView.footer.hidden = YES;
    }
}

// Method implementations
- (void)setTabBarHidden:(BOOL)hidden
{
    UIView *tab = self.tabBarController.view;
    
    if ([tab.subviews count] < 2) {
        return;
    }
    UIView *view;
    
    if ([[tab.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]]) {
        view = [tab.subviews objectAtIndex:1];
    } else {
        view = [tab.subviews objectAtIndex:0];
    }
    
    if (hidden) {
        view.frame = tab.bounds;
    } else {
        view.frame = CGRectMake(tab.bounds.origin.x, tab.bounds.origin.y, tab.bounds.size.width, tab.bounds.size.height);
    }
    self.view.frame = view.frame;
    self.tabBarController.tabBar.hidden = hidden;
}

-(float)getScareRatioX{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    return delegate.autoSizeScaleX;
}
-(float)getScareRatioY{
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    return delegate.autoSizeScaleY;
}


//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (alertView.tag == 1007) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//}
//-(void)showEmtiyFlageInView:(UIView*)view{
//    if (![view viewWithTag:8080]) {
//        UILabel *lblEmpty = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
//        lblEmpty.textAlignment = NSTextAlignmentCenter;
//        lblEmpty.text = @"无记录";
//        lblEmpty.textColor =  [UIColor TTColorLightMidGray];
//        lblEmpty.tag = 8080;
//        lblEmpty.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
//        [view addSubview:lblEmpty];
//    }
//}
//-(void)hidenEmtiyFlageInView:(UIView*)view{
//    [[view viewWithTag:8080] removeFromSuperview];
//}
// 缺省不支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

-(void)showEmtiyFlageInView:(UIView*)view{
    if (![view viewWithTag:8080]) {
        UILabel *lblEmpty = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        lblEmpty.textAlignment = NSTextAlignmentCenter;
        lblEmpty.text = @"无记录";
        lblEmpty.textColor =  [UIColor YColorGray];
        lblEmpty.tag = 8080;
        lblEmpty.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
        [view addSubview:lblEmpty];
    }
}

-(void)hidenEmtiyFlageInView:(UIView*)view{
    [[view viewWithTag:8080] removeFromSuperview];
}

@end
