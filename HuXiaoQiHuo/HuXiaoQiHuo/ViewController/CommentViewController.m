//
//  CommentViewController.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/18.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "Request.h"

#define COMMENT_PAGE_SIZE 10

@interface CommentViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>{
    NSInteger uid;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *writeComment;

@property (strong, nonatomic) NSMutableArray *arrayData;
@property NSInteger pageIndex;
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageIndex = 0;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
   
}

-(void)configureWithData:(id)data{
    uid = [data integerValue];
    
    __weak typeof(self)  weakSelf = self;
    
    [self configeRefreshTableView:self.tableView headBlock:^{
        weakSelf.pageIndex = 1;
        [weakSelf fetchCommentForTableView:weakSelf.tableView pageIndex:weakSelf.pageIndex];
    } footBlock:^{
        weakSelf.pageIndex++;
        [weakSelf fetchCommentForTableView:weakSelf.tableView pageIndex:weakSelf.pageIndex];
    }];
    
    if (self.arrayData == nil){
        [self.tableView.header beginRefreshing];
        
    }

}

-(void)fetchCommentForTableView:(UITableView*)tableView pageIndex:(NSInteger)index{
    NSDictionary *dicSend = @{@"uid":[NSNumber numberWithInteger:uid],
                              @"pid": [NSNumber numberWithInteger:index],
                              @"count":@COMMENT_PAGE_SIZE
                              };
    
    [NetWork postDataWithServer:@"http://121.43.232.204:8097/ajax/datahandler.ashx?action=replies" sendDic:dicSend kind:HttpRequstLoading tips:@"正在取得用户信息..." target:self userInfo:nil callback:^(NSDictionary *dic){
        NSLog(@"resultDic %@", dic);
        NSMutableArray *list = [dic objectForKey:@"Data"];
        tableView.footer.hidden = [list count] < COMMENT_PAGE_SIZE;
        if (index > 1) { //加载跟多
            [tableView.footer endRefreshing];
            [self.arrayData addObjectsFromArray:list];
            
        }else{
            self.arrayData = list;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentTableViewCell *cell = nil;
    NSDictionary *dicData = self.arrayData[indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell"];
    if (cell == nil) {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CommentTableViewCell"];
    }
    
    [cell refreshUI:dicData];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat fHeith = [tableView fd_heightForCellWithIdentifier:@"CommentTableViewCell" cacheByIndexPath:indexPath configuration:^(CommentTableViewCell * cell) {
        NSDictionary *dicData = [self.arrayData objectAtIndex:indexPath.row];
        [cell refreshUI:dicData];
        
    }];
    return fHeith>100?fHeith:100;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendMessageToServer:textField.text];
    
    return YES;
    
}

-(void)sendMessageToServer:(NSString*)strContent{
    if ([strContent isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入评价内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alertView show];
        
        return;
    }
    
//    评论回复	http://121.43.232.204:8097/ajax/datahandler.ashx?action=reply	POST	uname（账号）
//    pwd（密码）
//    content（内容）
//    uid（目标用户ID）
    NSDictionary *dicSend = @{@"pwd":[Request getMD5:[GlobalValue sharedInstance].pwd],
                              @"uname": [GlobalValue sharedInstance].uname,
                              @"content":strContent,
                              @"uid":[NSNumber numberWithInteger:uid]};
    [NetWork postDataWithServer:@"http://121.43.232.204:8097/ajax/datahandler.ashx?action=reply" sendDic:dicSend kind:HttpRequstLoadingNone tips:@"" target:self userInfo:nil callback:^(NSDictionary *dic) {
        self.writeComment.text = @"";
        [self.writeComment resignFirstResponder];
        [self.tableView.header beginRefreshing];
    }errorCallback:^(NSDictionary *resultDic) {
        
    }];

    
}


@end
