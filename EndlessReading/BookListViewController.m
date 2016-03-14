//
//  BookListViewController.m
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 16/1/25.
//  Copyright © 2016年 Satinno. All rights reserved.
//

#import "BookListViewController.h"
#import "SearchTableViewCell.h"
#import "DetailViewController.h"

@interface BookListViewController ()
{
    __weak IBOutlet UITableView *_tableView;
    NSMutableArray *_bookList;
    
    NSInteger _currentPage;
    NSInteger _totalPage;
    NSInteger _currentSelectIndex;
}
@end

@implementation BookListViewController
-(void)dealloc{
    
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([_categoryDict objectForKey:@"catalog_name"]) {
        self.title = [_categoryDict objectForKey:@"catalog_name"];
    }
    else if ( _isInterest){
        self.title = @"你感兴趣";
    }
    else{
        self.title = [_categoryDict objectForKey:@"chart_name"];
    }
    
    _bookList = [NSMutableArray new];
    _currentPage = 1;
    
    [self getBookList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getBookList{
    __weak BookListViewController *tmpSelf = self;
    [SVProgressHUD show];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    if ([_categoryDict objectForKey:@"catalog_id"]) {
        [[WebServiceHttpClient sharedWebServiceHTTPClient] getBooksListCtalogWithParams:@{@"catalog_id":[_categoryDict objectForKey:@"catalog_id"], @"page":@(_currentPage), @"pagesize":@(PAGESIZE)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [tmpSelf getBookListSuccess:responseObject];
            [SVProgressHUD dismiss];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage];
        }];
    }
    else if (_isInterest){
        [[WebServiceHttpClient sharedWebServiceHTTPClient] getBooksRecommendListWithParams:@{@"list_type":@"interest"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [tmpSelf getBookListSuccess:responseObject];
            [SVProgressHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage];
        }];
        
    }
    else{
        [[WebServiceHttpClient sharedWebServiceHTTPClient] getBooksChartsBookListWithParams:@{@"chart_key":[_categoryDict objectForKey:@"chart_key"], @"page":@(_currentPage), @"pagesize":@(PAGESIZE)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [tmpSelf getBookListSuccess:responseObject];
            [SVProgressHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage];
        }];
    }
}

- (void)getBookListSuccess:(NSDictionary*)dict{
    NSDictionary *dictDict = [dict objectForKey:@"data"];
    
    _totalPage = [[dictDict objectForKey:@"page_total"] integerValue];
    [_bookList addObjectsFromArray:[dictDict objectForKey:@"listData"]];
    
    [_tableView reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"PushToDetailViewController"]) {
        NSDictionary *dict = [_bookList objectAtIndex:_currentSelectIndex];
        
        
        DetailViewController *vc = segue.destinationViewController;
        vc.bookDict = dict;
    }
}


#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _bookList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 126.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTableViewCell"];
    NSDictionary *dict = [_bookList objectAtIndex:indexPath.row];
    [cell setupSearchTableViewCell:dict];
    
    if (indexPath.row == (_bookList.count-1) && (_currentPage < _totalPage)) {
        _currentPage++;
        [self getBookList];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _currentSelectIndex = indexPath.row;
    
    [self performSegueWithIdentifier:@"PushToDetailViewController" sender:nil];
}

@end
