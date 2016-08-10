//
//  SearchProductViewController.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/6/2.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "SearchProductViewController.h"
#import "TTPageView.h"
#import "MarketMainItemCell.h"
#import "SearchDBManager.h"

@interface SearchProductViewController ()<TTPageViewSource, TTPageViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *arrayIndex,*arrayZx;
    BOOL bForZx;

}
@property (nonatomic, strong) NSArray *titleList;
@property (weak, nonatomic) IBOutlet TTPageView *pageView;
@property (nonatomic, strong) UITableView *zxTableView;
@property (nonatomic, strong) UITableView *positionTableView;
@end

@implementation SearchProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)configureWithData:(id)data{
    UITableView *tableView =  [[UITableView alloc] initWithFrame:CGRectZero];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerNib:[UINib nibWithNibName:@"MarketMainItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MarketMainItemCell"];
    self.zxTableView = tableView;
    tableView =  [[UITableView alloc] initWithFrame:CGRectZero];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerNib:[UINib nibWithNibName:@"MarketMainItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MarketMainItemCell"];
    self.positionTableView = tableView;

    if (data) {
        bForZx = YES;
        self.pageView.hidden = YES;
        self.positionTableView.frame= CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height);
        [self.view addSubview:self.positionTableView];
    }else{
        self.pageView.delegate = self;
        self.pageView.dataSource = self;
        self.titleList = @[@"自选商品", @"持仓商品"];
        UITableView *tableView =  [[UITableView alloc] initWithFrame:CGRectZero];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerNib:[UINib nibWithNibName:@"MarketMainItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MarketMainItemCell"];
        self.zxTableView = tableView;
        tableView =  [[UITableView alloc] initWithFrame:CGRectZero];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerNib:[UINib nibWithNibName:@"MarketMainItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MarketMainItemCell"];
        self.positionTableView = tableView;
        arrayZx = [[GlobalValue sharedInstance] loadZXFile];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark TTPageView datasource delegate;
-(NSInteger)numberOfCountInPageView:(TTPageView*)pageView{
    return self.titleList.count;
}
-(void)TTPageView:(TTPageView*)pageView initTopTabView:(TTPageTopTabView*)topTabView atIndex:(NSInteger)index{
    topTabView.titleLabel.text = [self.titleList objectAtIndex:index];
}
-(UIView*)contentViewForPageView:(TTPageView*)pageView atIndex:(NSInteger)index{
    if (index == 0) {
        return self.zxTableView;
    }else{
        return self.positionTableView;
    }
}

#pragma mark -UISearchBar 代理
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        return;
    }
    
    SearchDBManager *manager = [SearchDBManager sharedInstance];
    arrayIndex = [manager queryData_Search_DataByIndexString:searchBar.text];
    
    
    if (arrayIndex.count==0) {
        arrayIndex = nil;
        [self showEmtiyFlageInView:self.positionTableView];
        [self.positionTableView reloadData];
        
    }else{
        [self hidenEmtiyFlageInView:self.positionTableView];
        [self.positionTableView reloadData];
    }
    
}

#pragma mark tableview datasource & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.zxTableView) {
        return arrayZx.count;
    }else{
        return arrayIndex.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MarketMainItemCell* contentCell = (MarketMainItemCell*)[tableView dequeueReusableCellWithIdentifier:@"MarketMainItemCell"] ;
    contentCell.lblChg .hidden = YES;
    contentCell.lblPrice.hidden = YES;
    if (tableView == self.zxTableView) {
        //获取商品信息
        MerpList_Obj *obj = [[CTradeClientSocket sharedInstance] merpListObjWithMpIndex:arrayZx[indexPath.row]];
        [contentCell refreshUI:obj];
        
    }else if (tableView == self.positionTableView) {
        MerpList_Obj *obj = [[CTradeClientSocket sharedInstance] merpListObjWithMpIndex:arrayIndex[indexPath.row]];
        [contentCell refreshUI:obj];
        
    }
    return contentCell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[self performSegueWithIdentifier:@"GotoStockDetail" sender:nil];
    MerpList_Obj *obj;
    if (tableView == self.zxTableView) {
        //获取商品信息
        obj = [[CTradeClientSocket sharedInstance] merpListObjWithMpIndex:arrayZx[indexPath.row]];
        
    }else if (tableView == self.positionTableView) {
        obj = [[CTradeClientSocket sharedInstance] merpListObjWithMpIndex:arrayIndex[indexPath.row]];
        
    }
    [self completeWithData:obj];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
