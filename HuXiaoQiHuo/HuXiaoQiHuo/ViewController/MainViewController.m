//
//  MainViewController.m
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/12.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "MainViewController.h"
#import "TTPageView.h"
#import "MainMasterTableViewCell.h"
#import "MJRefresh.h"
#import "MyBookTableViewCell.h"
#import "Request.h"

#define MASTER_INDEX 0
#define TRADE_INDEX 1
#define BOOK_INDEX 2

#define MASTER_PAGE_SIZE 10

@interface MainViewController ()<TTPageViewSource, TTPageViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSInteger currentType;
    NSInteger currentOrderBy;
    NSArray *arrayBooked;
    NSInteger nStarLevel;
    NSInteger nFilterGoodAt;
}
@property (nonatomic, strong) NSArray *titleList;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mainSegment;
@property (weak, nonatomic) IBOutlet TTPageView *masterView;
@property (weak, nonatomic) IBOutlet UIView *bookView;

@property (strong, nonatomic) IBOutlet UIView *incomeView;
@property (weak, nonatomic) IBOutlet UITableView *masterTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSegCons;

@property (weak, nonatomic) IBOutlet UITableView *bookedTableView;

@property (strong, nonatomic) NSMutableArray *masterArrayData;

@property (strong, nonatomic) UIBarButtonItem *addButton;
@property (strong, nonatomic) UIBarButtonItem* filterButton;
@property NSInteger masterPageIndex;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super setShowBackButton:NO];
    [self loginCheck];
    self.titleList = @[@"收益榜",@"胜率榜",@"净值榜",@"人气榜"];
    self.masterView.delegate =self;
    self.masterView.dataSource = self;
    // init ui
    [self.mainSegment setSelectedSegmentIndex:0];
    self.masterView.hidden = NO;
    self.bookView.hidden = YES;
    
    _filterButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self  action:@selector(filterTouched:)];
    [_filterButton setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor], nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, nil]] forState:UIControlStateNormal];
    
    [self.navigationItem setRightBarButtonItem:_filterButton];

    _addButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self  action:@selector(addTouched:)];
    [_addButton setTitleTextAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor], nil] forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName, nil]] forState:UIControlStateNormal];
    currentType = 2;
    currentOrderBy = 1;
    [self.masterTableView registerNib:[UINib nibWithNibName:@"MainMasterTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MainMasterTableViewCell"];
    [self initData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(login:) name:@"relogin" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginOK:) name:@"loginOK" object:nil];
    
    nStarLevel = 0;
    nStarLevel = -1;
}

-(void)initData{
//    orderby（排序字段）	1.收益（默认）；2.胜率；3.净值；4.人气（被订阅数）
//    id（对应的用户ID）	查询对应用户的ID
//    type（用户类型）	2.高手跟单（默认）；3.程序化交易
//    size（返回记录数）	自定义正整数（默认为10）
//    page（页码）	自定义正整数（默认为1）
//    ordertype（排序方式）	0.asc ；1.desc（默认）
//    proid（产品种类）	品种ID、可为空
//    star（等级）	1、2、3、4、5、可为空
    //{"USER_NAME":"jianglan001","nick_name":"长江后浪","id":"1343","avatar":"http://121.43.232.204:8098/upload/jianglan001.jpg","user_type":"2","speciality":"2","plevel":"1","pt_name":"黄金","subMoney":"0.0000","sub_fee_id":"1816","muid":"631","sub_be_count":"12","balance":"3697131.78","sumprofit":"2777364.34","networth":"3.69713","maxretracement":"12.48","winrate":"64.73","sumnum":"414","row_id":"1","row_count":"54","calcdate":"2016/5/19 6:00:02","myrowid":""},

    
    //注意block中必须用weak self不然存在循环引用问题
    __weak typeof(self)  weakSelf = self;
    
    [self configeRefreshTableView:self.masterTableView headBlock:^{
        weakSelf.masterPageIndex = 1;
        [weakSelf fetchDateOrderForTableView:weakSelf.masterTableView orderBy:currentOrderBy type:currentType pageIndex:weakSelf.masterPageIndex];
    } footBlock:^{
        weakSelf.masterPageIndex++;
       [weakSelf fetchDateOrderForTableView:weakSelf.masterTableView orderBy:currentOrderBy type:currentType pageIndex:weakSelf.masterPageIndex];
    }];
    
    
    if (self.masterArrayData == nil){
        [self.masterTableView.header beginRefreshing];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//获取详情
-(void)fetchDateOrderForTableView:(UITableView*)tableView orderBy:(NSInteger)orderby  type:(NSInteger)type pageIndex:(NSInteger)index{
    NSDictionary *dic = @{@"orderby":[NSNumber numberWithInteger:orderby],
                              @"id": @1,
                              @"type":[NSNumber numberWithInteger:type],
                              @"size":@MASTER_PAGE_SIZE,
                              @"page":[NSNumber numberWithInteger:index],
                              @"ordertype":@1};

    NSMutableDictionary *dicSend = [[NSMutableDictionary alloc]initWithDictionary:dic];
    if (nStarLevel != 0) {
        [dicSend setValue:[NSNumber numberWithInteger:nStarLevel] forKey:@"star"];
    }
    if (nFilterGoodAt != -1) {
        [dicSend setValue:[NSNumber numberWithInteger:nFilterGoodAt] forKey:@"proid"];
    }
    
    [NetWork postDataWithServer:@"http://121.43.232.204:8097/ajax/DataHandler.ashx?action=getrank" sendDic:dicSend kind:HttpRequstLoadingNone tips:@"" target:self userInfo:nil callback:^(NSDictionary *dic) {
        NSLog(@"resultDic %@", dic);
        NSMutableArray *list = [dic objectForKey:@"data"];
        NSMutableArray *changeList = [[NSMutableArray alloc]initWithCapacity:list.count];
        for (NSDictionary *dic in list) {
            NSMutableDictionary* dicCopy = [NSMutableDictionary dictionaryWithDictionary:dic];
            [changeList addObject:dicCopy];
            if (arrayBooked.count != 0) {
                NSDictionary*dicBooked =  [self containBook:dicCopy];
                if (dicBooked != nil) {
                    [dicCopy setObject:[NSNumber numberWithBool:YES] forKey:@"booked"];
                    [dicCopy setObject:dicBooked[@"DiffDate"] forKey:@"DiffDate"];
                }
            }
        }
        tableView.footer.hidden = [changeList count] < MASTER_PAGE_SIZE;
        if (index > 1) { //加载跟多
            [tableView.footer endRefreshing];
            
            [self.masterArrayData addObjectsFromArray:changeList];
        }else{
            if (tableView == self.masterTableView) {
                self.masterArrayData = changeList;
            }
            
            [tableView.header endRefreshing];
            self.masterArrayData.count == 0? [self showEmtiyFlageInView:tableView]:[self hidenEmtiyFlageInView:tableView];
        }
        [tableView reloadData];
    } errorCallback:^(NSDictionary *resultDic){
        if (index > 0) { //加载跟多
            [tableView.footer endRefreshing];
        }else{
            [tableView.header endRefreshing];
        }
    }];
}

-(NSDictionary*)containBook:(NSDictionary *)dicCompare{
    for (NSDictionary*dic in arrayBooked) {
        if ([dic[@"beSubscriberId"] integerValue] == [dicCompare[@"id"] integerValue]) {
            return dic;
        }
    }
    return nil;
}

-(void)login:(NSNotification *)notification{
    [self loginCheck];
}

-(void)loginOK:(NSNotification *)notification{
    //    我的订阅列表	http://121.43.232.204:8097/ajax/DataHandler.ashx?action=mysubscrib	POST	uname（账号）
    //    pwd（密码）
    NSDictionary *dicBook = @{@"account":[GlobalValue sharedInstance].uname,
                              @"pwd": [Request getMD5:[GlobalValue sharedInstance].pwd]};
    [NetWork postDataWithServer:@"http://121.43.232.204:8097/ajax/DataHandler.ashx?action=mysubscrib" sendDic:dicBook kind:HttpRequstLoadingNone tips:@"" target:self userInfo:nil callback:^(NSDictionary *dic) {
        NSLog(@"book list=%@", dic);
        arrayBooked = dic[@"data"];
        [self.bookedTableView reloadData];
        [self.masterTableView.header beginRefreshing];
    }errorCallback:^(NSDictionary *resultDic) {
        
    }];
}

-(void)loginCheck{
    BOOL isLoginFinish = NO;
    if (!isLoginFinish) {
        //弹出登录
        UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UIViewController* loginVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"LOGIN_VC"];
        [self.navigationController presentViewController:loginVC animated:YES completion:^{
            NSLog(@"start login vc");
        }];
    }
    
}

#pragma mark - action

-(void)configureWithData:(id)data{
    NSDictionary *dicGet = data;

    if ([dicGet[@"isBack"] boolValue]) {
        self.navigationItem.rightBarButtonItem = nil;
        self.topSegCons.constant = -29.0;
        [super setShowBackButton:YES];
        nFilterGoodAt = [dicGet[@"type"] integerValue];
        nStarLevel = [dicGet[@"level"] integerValue];
        self.title = @"筛选结果";
        [self.masterTableView.header beginRefreshing];
    }
}

- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    NSInteger selectedIndex = [sender selectedSegmentIndex];
    switch (selectedIndex) {
        case MASTER_INDEX:
            self.masterView.hidden = NO;
            self.bookView.hidden = YES;
            
            currentType = 2;
            [self.masterTableView.header beginRefreshing];
            
            [self.navigationItem setRightBarButtonItem:_filterButton];
            
            break;
        case TRADE_INDEX:
            self.masterView.hidden = NO;
            self.bookView.hidden = YES;
            
            currentType = 3;
            [self.masterTableView.header beginRefreshing];
            
            [self.navigationItem setRightBarButtonItem:_filterButton];
            
            break;
        case BOOK_INDEX:
            self.masterView.hidden = YES;
            self.bookView.hidden = NO;
            
            [self.navigationItem setRightBarButtonItem:_addButton];
        
            break;
        default:
            break;
    }
}

-(void)filterTouched:(id)sender{
    [self performSegueWithIdentifier:@"MainFilterViewController" sender:nil];
}

-(void)addTouched:(id)sender{
    [self performSegueWithIdentifier:@"BookAddViewController" sender:nil];
}

-(void)bookAction:(UIButton*)sender{
    NSInteger tag = sender.tag;
    [self performSegueWithIdentifier:@"BookViewController" sender:self.masterArrayData[tag]];
}

#pragma mark TTPageView datasource delegate;
-(NSInteger)numberOfCountInPageView:(TTPageView*)pageView{
    return self.titleList.count;
}
-(void)TTPageView:(TTPageView*)pageView initTopTabView:(TTPageTopTabView*)topTabView atIndex:(NSInteger)index{
    topTabView.titleLabel.text = [self.titleList objectAtIndex:index];
}

-(void)TTPageView:(TTPageView *)pageView didSelectAtIndex:(NSInteger)index topTabView:(TTPageTopTabView *)topTabView{
    currentOrderBy = index+1;
    [self.masterTableView.header beginRefreshing];
}

#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.masterTableView) {
        return self.masterArrayData.count;
    }else{
        return arrayBooked.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    NSDictionary *dic = nil;
    if (tableView == self.masterTableView) {
        MainMasterTableViewCell *masterCell = nil;
        dic = self.masterArrayData[indexPath.row];
        masterCell = [tableView dequeueReusableCellWithIdentifier:@"MainMasterTableViewCell"];
        if (masterCell == nil) {
            masterCell = [[MainMasterTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MainMasterTableViewCell"];
        }
        masterCell = [tableView dequeueReusableCellWithIdentifier:@"MainMasterTableViewCell"];
        if (!masterCell){
            masterCell = [tableView dequeueReusableCellWithIdentifier:@"MainMasterTableViewCell"];
        }
        
        [masterCell refreshUI:dic];
        [masterCell.btnBook setTag:indexPath.row];
        [masterCell.btnBook addTarget:self action:@selector(bookAction:) forControlEvents:UIControlEventTouchUpInside];
        cell = masterCell;

    }else{
        MyBookTableViewCell *bookCell = nil;
        bookCell = [tableView dequeueReusableCellWithIdentifier:@"MyBookTableViewCell"];
        if (bookCell == nil) {
            bookCell = [[MyBookTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyBookTableViewCell"];
        }
        
        dic = arrayBooked[indexPath.row];
        [bookCell refreshUI:dic];
        cell = bookCell;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = nil;
    if (tableView == self.masterTableView) {
        dic = self.masterArrayData[indexPath.row];
        [self performSegueWithIdentifier:@"AnalysisViewController" sender:dic];
    }

}


@end
