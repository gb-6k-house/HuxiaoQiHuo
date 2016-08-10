//
//  MarketViewController.m
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/12.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "MarketViewController.h"
#import "TTPageView.h"
#import "MarketMainItemCell.h"
#import "MarketRecommendSectionHeadView.h"
#import "MerpList_Obj.h"
@interface MarketViewController ()<TTPageViewSource, TTPageViewDelegate, UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *titleList;

@property (strong, nonatomic) IBOutlet UIView *pageIndexView1;
@property (strong, nonatomic) IBOutlet UIView *pageIndexView2;
@property (strong, nonatomic) IBOutlet UIView *pageIndexView3;
@property (weak, nonatomic) IBOutlet TTPageView *pageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;

@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (weak, nonatomic) IBOutlet UITableView *tableView3;
@property(nonatomic, strong)NSMutableArray *arrayZx;//自选
@property(nonatomic, strong)NSMutableArray *arrayAll;//全部
@property(nonatomic, strong)NSArray *arrayRecommend;//推荐
@property (weak, nonatomic) IBOutlet UIButton *btnAddCustom;
@property(nonatomic, strong)NSMutableArray *arrayPageSubView;
@property(nonatomic, strong)NSCountedSet *mainSet;

@end

@implementation MarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setShowBackButton:NO];
    // Do any additional setup after loading the view.
//    UIBarButtonItem *rightButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search_add"] style:UIBarButtonItemStyleBordered target:self action:@selector(addCustomAction:)];
//    
//    [self.navigationItem setRightBarButtonItem:rightButton];
    self.titleList = @[@"自选",@"推荐品种",@"国际期货"];
    self.pageView.delegate = self;
    self.pageView.dataSource = self;
    self.arrayPageSubView = [NSMutableArray array];
    [self addCustomShow:YES];

    self.mainSet = [NSCountedSet set]; //商品
    self.arrayAll = [NSMutableArray array];
    NSArray *subTags = [[CTradeClientSocket sharedInstance] getSubTagForTagID:const_GlobleMarketQihuoTag];
    for (Login_Tags_Obj *tag in subTags) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"expand"] = @(NO);
        dic[@"title"] = tag.name;
        dic[@"datas"] = [[CTradeClientSocket sharedInstance] merpLitObjByClassicID:[@(tag.ID)stringValue]];
        [self.arrayAll addObject:dic];
    }
    self.arrayRecommend = [[CTradeClientSocket sharedInstance] recommendMerpListObj];

    for (NSInteger i = 0; i< self.titleList.count-1; i++) {
        UITableView *tableView =  [[UITableView alloc] initWithFrame:CGRectZero];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerNib:[UINib nibWithNibName:@"MarketMainItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MarketMainItemCell"];
        [self.arrayPageSubView addObject:tableView];
    }
    [self.tableView1 registerNib:[UINib nibWithNibName:@"MarketMainItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MarketMainItemCell"];
    [self.tableView2 registerNib:[UINib nibWithNibName:@"MarketMainItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MarketMainItemCell"];

    [self.tableView3 registerNib:[UINib nibWithNibName:@"MarketMainItemCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MarketMainItemCell"];


    //[self.tableView1 setEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.arrayZx = [[GlobalValue sharedInstance] loadZXFile];
    [self.tableView1 reloadData];
    [self addCustomShow:self.arrayZx.count==0];
}


-(void)addCustomShow:(BOOL)show{
    if (show) {
        self.btnAddCustom.hidden = NO;
        self.tableView1.hidden = YES;
    }else{
        self.btnAddCustom.hidden = YES;
        self.tableView1.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark TTPageView datasource delegate;
-(NSInteger)numberOfCountInPageView:(TTPageView*)pageView{
    return self.titleList.count;
}
-(void)TTPageView:(TTPageView*)pageView initTopTabView:(TTPageTopTabView*)topTabView atIndex:(NSInteger)index{
    topTabView.titleLabel.text = [self.titleList objectAtIndex:index];
}
-(UIView*)contentViewForPageView:(TTPageView*)pageView atIndex:(NSInteger)index{
    if (index ==0) {
        return  self.pageIndexView1;
    } else if(index == 1){
        return  self.pageIndexView2;
    }
    else{
        return  self.pageIndexView3;
    }
}
-(void)TTPageView:(TTPageView*)pageView didSelectAtIndex:(NSInteger)index topTabView:(TTPageTopTabView*)topTabView{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark tableview datasource & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.tableView3 == tableView) {
        return [self.arrayAll count];
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.tableView1 == tableView) {
        return self.arrayZx.count;
    }else  if (self.tableView2 == tableView) {
        return self.arrayRecommend.count;
    }else{
        if ([(self.arrayAll[section][@"expand"]) boolValue]) {
            return [(self.arrayAll[section][@"datas"]) count];
        }else{
            return 0;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.tableView3 == tableView) {
        return 35.0;
    }else{
        return 0;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MarketRecommendSectionHeadView* contentCell = (MarketRecommendSectionHeadView*)[tableView dequeueReusableCellWithIdentifier:@"MarketRecommendSectionHeadView"];
    contentCell.tag = section;
    [contentCell configeWithData:@{@"expand":[self.arrayAll objectAtIndex:section][@"expand"],@"title":[self.arrayAll objectAtIndex:section][@"title"]}];
    contentCell.block = ^(BOOL expanded, MarketRecommendSectionHeadView *view){
        [[self.arrayAll objectAtIndex:section] setValue:@(expanded) forKey:@"expand"];
        [self.tableView3 reloadData];
    };
    return contentCell;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MarketMainItemCell* contentCell = (MarketMainItemCell*)[tableView dequeueReusableCellWithIdentifier:@"MarketMainItemCell"] ;
    if (tableView == self.tableView2) {
        //获取商品信息
        MerpList_Obj *obj = self.arrayRecommend[indexPath.row];
        [contentCell refreshUI:obj];
        if (![self.mainSet containsObject:obj]) {
            NSMutableSet *set =  [NSMutableSet set];
            [set addObject:@(obj.nIndex)];
            [self.mainSet addObject:obj];
            [[CTradeClientSocket sharedInstance] updateMarketInfoWithMpIndexs:set];

        }
    }else if (tableView == self.tableView3) {
        MerpList_Obj *obj = (self.arrayAll[indexPath.section][@"datas"])[indexPath.row];
        [contentCell refreshUI:obj];
        if (![self.mainSet containsObject:obj]) {
            NSMutableSet *set =  [NSMutableSet set];
            [set addObject:@(obj.nIndex)];
            [self.mainSet addObject:obj];
            [[CTradeClientSocket sharedInstance] updateMarketInfoWithMpIndexs:set];
            
        }

    }else if (tableView == self.tableView1){
        MerpList_Obj *obj = [[CTradeClientSocket sharedInstance] merpListObjWithMpIndex:self.arrayZx[indexPath.row]];
        [contentCell refreshUI:obj];
        if (![self.mainSet containsObject:obj]) {
            NSMutableSet *set =  [NSMutableSet set];
            [set addObject:@(obj.nIndex)];
            [self.mainSet addObject:obj];
            [[CTradeClientSocket sharedInstance] updateMarketInfoWithMpIndexs:set];
            
        }


    }
    return contentCell;
}
- (IBAction)gotoSelStockAction:(id)sender {
    [self performSegueWithIdentifier:@"GotoSelectStock" sender:@(1) completion:^(id data) {
        MerpList_Obj *obj = data;
        [[GlobalValue sharedInstance] addZxWithMpId:[@(obj.nIndex) stringValue]];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *sendData =  [NSMutableDictionary dictionary];
    if (self.tableView1 == tableView) {
        MerpList_Obj *obj = [[CTradeClientSocket sharedInstance] merpListObjWithMpIndex:self.arrayZx[indexPath.row]];
        [sendData setObject:obj forKey:@"mpInfo"];

    }else if (tableView == self.tableView2) {
        //获取商品信息
        [sendData setObject:[self.arrayRecommend objectAtIndex:indexPath.row] forKey:@"mpInfo"];

    }else if (tableView == self.tableView3) {
        MerpList_Obj *obj = (self.arrayAll[indexPath.section][@"datas"])[indexPath.row];
        [sendData setObject:obj forKey:@"mpInfo"];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self performSegueWithIdentifier:@"GotoStockDetail" sender:sendData completion:^(id data) {
    }];
}
//返回YES，表示支持单元格的编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.tableView1){
        return YES;
    }else{
        return NO;
    }
}
//单元格返回的编辑风格，包括删除 添加 和 默认  和不可编辑三种风格
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        MerpList_Obj *obj = [[CTradeClientSocket sharedInstance] merpListObjWithMpIndex:self.arrayZx[indexPath.row]];
        [[GlobalValue sharedInstance] removeZxWithMpId:[NSString stringWithFormat:@"%ld", (long)obj.nIndex]];
        [TToast showToast:@"删除自选成功" afterDelay:1.0f];
        
        self.arrayZx = [[GlobalValue sharedInstance] loadZXFile];
        [self.tableView1 reloadData];
        [self addCustomShow:self.arrayZx.count==0];
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (IBAction)addCustomAction:(id)sender {
    [self gotoSelStockAction:sender];
}

//行情信息刷新, 返回PriceData_Obj信息
SOCKET_PROTOCOL(NewPrice){
    if (self.isApear) {
        NSArray *visiblePaths;
        if (self.pageView.selectedIndex==0) {
            visiblePaths = [self.tableView1 indexPathsForVisibleRows];
            [self.tableView1 reloadRowsAtIndexPaths:visiblePaths withRowAnimation:UITableViewRowAnimationNone];
        }else if (self.pageView.selectedIndex == 1){
            visiblePaths = [self.tableView2 indexPathsForVisibleRows];
            [self.tableView2 reloadRowsAtIndexPaths:visiblePaths withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            visiblePaths = [self.tableView3 indexPathsForVisibleRows];
            [self.tableView3 reloadRowsAtIndexPaths:visiblePaths withRowAnimation:UITableViewRowAnimationNone];
            
            
        }

    }
    

    
//    
//    for (int i = 0; i < self.arrayPageSubView.count; i++) {
//        UITableView * tableview = self.arrayPageSubView[i];
//        NSArray *visiblePaths = [tableview indexPathsForVisibleRows];
//        NSArray * datas = i==0?self.arrayRecommend:self.arrayGolbalQihuo;
//        for (NSIndexPath *indexPath in visiblePaths){
//            MerpList_Obj *obj = datas[indexPath.row];
//            if (obj.nIndex == [objPriceData.strMapID integerValue]) {
//                obj.priceObJ = objPriceData;
//                //            NSLog(@"%@ 最新价 %f",obj.strMpname,objPriceData.fLatestPrice);
//                [tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
//                
//            }
//            
//        }
//    }
//   
}
@end
