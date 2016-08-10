//
//  BookAddViewController.m
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/19.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "BookAddViewController.h"
#import "BookAddTableViewCell.h"

#define SEARCH_PAGE_SIZE 10

@interface BookAddViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrayData;
@property NSInteger pageIndex;
@end

@implementation BookAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self.view setBackgroundColor:[UIColor YColorBackGroudGray]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    
    //注意block中必须用weak self不然存在循环引用问题
    __weak typeof(self)  weakSelf = self;
    self.pageIndex = 0;
    [self configeRefreshTableView:self.tableView headBlock:^{
        weakSelf.pageIndex = 1;
        [weakSelf fetchDateOrderForTableView:weakSelf.tableView pageIndex:weakSelf.pageIndex];
    } footBlock:^{
        weakSelf.pageIndex++;
        [weakSelf fetchDateOrderForTableView:weakSelf.tableView pageIndex:weakSelf.pageIndex];
    }];
    
}

//获取详情
-(void)fetchDateOrderForTableView:(UITableView*)tableView pageIndex:(NSInteger)index{
    
    //    搜索可订阅用户	http://121.43.232.204:8097/ajax/DataHandler.ashx?action=subscribsearch	POST	uname（账号）
    //    pwd（密码）
    //    uname(用户名）
    //          size（返回记录数）	默认为10
    //          page（页码）	默认为1
    
    NSDictionary *dic = @{
                          @"uname": self.search.text,
                          @"account":[GlobalValue sharedInstance].uname,
                          @"pwd": [Request getMD5:[GlobalValue sharedInstance].pwd],
                          @"size":@SEARCH_PAGE_SIZE,
                          @"page":[NSNumber numberWithInteger:index]};
    
    [NetWork postDataWithServer:@"http://121.43.232.204:8097/ajax/DataHandler.ashx?action=subscribsearch" sendDic:dic kind:HttpRequstLoadingNone tips:@"" target:self userInfo:nil callback:^(NSDictionary *dic) {
        NSLog(@"resultDic %@", dic);
        NSMutableArray *list = [dic objectForKey:@"data"];
        tableView.footer.hidden = [list count] < SEARCH_PAGE_SIZE;
        if (index > 1) { //加载跟多
            [tableView.footer endRefreshing];
            
            [self.arrayData addObjectsFromArray:list];
        }else{
            if (tableView == self.tableView) {
                self.arrayData = list;
            }
            
            [tableView.header endRefreshing];
            self.arrayData.count == 0? [self showEmtiyFlageInView:tableView]:[self hidenEmtiyFlageInView:tableView];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookAddTableViewCell *cell = nil;
    NSDictionary *dicData = self.arrayData[indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:@"BookAddTableViewCell"];
    if (cell == nil) {
        cell = [[BookAddTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"BookAddTableViewCell"];
    }
    
    [cell refreshUI:dicData];
//    cell.backgroundColor = [UIColor clearColor];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dicData = self.arrayData[indexPath.row];
    [self performSegueWithIdentifier:@"AnalysisViewController" sender:dicData];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.tableView.header beginRefreshing];
    [self.search resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [self.search resignFirstResponder];
}

@end
