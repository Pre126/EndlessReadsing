//
//  FoundViewController.m
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 16/1/25.
//  Copyright © 2016年 Satinno. All rights reserved.
//

#import "FoundViewController.h"
#import "SearchTableViewCell.h"
#import "TableviewSectionHeaderView.h"
#import "TypeTableViewCell.h"
#import "BookListViewController.h"
#import "DetailViewController.h"
#import "HomeViewController.h"

@interface FoundViewController ()<TableviewSectionHeaderViewDelegate>

{
    NSMutableArray *_foundArray;
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UIButton *_foundButton;
    __weak IBOutlet UIImageView *_trangleImageView;
    
    __weak IBOutlet UIView *_headerView;
    
    __weak IBOutlet NSLayoutConstraint *_trangleCenterConstraint;
    
    NSInteger _currentPage;
    NSInteger _totalPage;
    
    NSIndexPath *_selectedIndexPath;
}
@end

@implementation FoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = nil;
    _foundArray = [NSMutableArray new];
    
    if (_exportIndex == 1) {
        [_foundArray addObject:@{@"image":@"find_icon_paihang.png", @"title":@"排行榜", @"export":@(YES), @"data":@[]}];
    }
    else{
        [_foundArray addObject:@{@"image":@"find_icon_paihang.png", @"title":@"排行榜", @"export":@(NO), @"data":@[]}];
    }
    
    if (_exportIndex == 2) {
        [_foundArray addObject:@{@"image":@"find_icon_sort.png", @"title":@"分类", @"export":@(YES), @"data":@[]}];
    }
    else{
        [_foundArray addObject:@{@"image":@"find_icon_sort.png", @"title":@"分类", @"export":@(NO), @"data":@[]}];
    }
    
    if (_exportIndex != 1 || _exportIndex != 2) {
        [_foundArray addObject:@{@"image":@"find_icon_tuijan.png", @"title":@"推荐", @"export":@(YES), @"data":@[]}];
    }
    else{
        [_foundArray addObject:@{@"image":@"find_icon_tuijan.png", @"title":@"推荐", @"export":@(NO), @"data":@[]}];
    }
    
    _currentPage = 1;
    
    [self getBooksCtalog];
    [self getBooksChartsList];
    [self getBooksRecommendList];
    
    [self performSelector:@selector(triangleAnimation) withObject:nil afterDelay:0.1];
}

- (void)triangleAnimation{
    _trangleCenterConstraint.constant= 180;
    
    [UIView animateWithDuration:0.3 animations:^{
        [_headerView updateConstraintsIfNeeded];
        [_headerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)getBooksChartsList{
    __weak FoundViewController *tmpSelf = self;
    
    [[WebServiceHttpClient sharedWebServiceHTTPClient] getBooksChartsListWithParams:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [tmpSelf getBooksChartsListSuccess:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage) {
        [SVProgressHUD showErrorWithStatus:errorMessage];
    }];
}

- (void)getBooksChartsListSuccess:(NSDictionary*)dict{
    NSDictionary *foundDict = [_foundArray objectAtIndex:0];
    
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithDictionary:foundDict];
    [tmpDict setObject:[dict objectForKey:@"data"] forKey:@"data"];
    [_foundArray replaceObjectAtIndex:0 withObject:tmpDict];
    
    [_tableView reloadData];
}



- (void)getBooksCtalog{
    __weak FoundViewController *tmpSelf = self;
    
    [[WebServiceHttpClient sharedWebServiceHTTPClient] getBooksCtalogWithParams:@{} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [tmpSelf getBooksCtalogSuccess:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage) {
        [SVProgressHUD showErrorWithStatus:errorMessage];
    }];
}

- (void)getBooksCtalogSuccess:(NSDictionary*)dict{
    NSDictionary *foundDict = [_foundArray objectAtIndex:1];
    
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithDictionary:foundDict];
    [tmpDict setObject:[dict objectForKey:@"data"] forKey:@"data"];
    [_foundArray replaceObjectAtIndex:1 withObject:tmpDict];
    
    [_tableView reloadData];
}

- (void)getBooksRecommendList{
    __weak FoundViewController *tmpSelf = self;
    
    [[WebServiceHttpClient sharedWebServiceHTTPClient] getBooksRecommendListWithParams:@{@"list_type":@"recommend", @"page":@(_currentPage), @"page_size":@(PAGESIZE)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [tmpSelf getBooksRecommendListSuccess:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage) {
        [SVProgressHUD showErrorWithStatus:errorMessage];
    }];
}

- (void)getBooksRecommendListSuccess:(NSDictionary*)dict{
    NSDictionary *foundDict = [_foundArray objectAtIndex:2];
    
    NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithDictionary:foundDict];
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:[foundDict objectForKey:@"data"]];
    
    NSDictionary *dictDict = [dict objectForKey:@"data"];
    
    _totalPage = [[dictDict objectForKey:@"page_total"] integerValue];
    [tmpArray addObjectsFromArray:[dictDict objectForKey:@"listData"]];
    
    [tmpDict setObject:tmpArray forKey:@"data"];
    
    [_foundArray replaceObjectAtIndex:2 withObject:tmpDict];
    
    [_tableView reloadData];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"PushToBookListViewController"]) {
         NSDictionary *dict = [_foundArray objectAtIndex:_selectedIndexPath.section];
         
         NSArray *catArray = [dict objectForKey:@"data"];
         
         BookListViewController *vc = segue.destinationViewController;
         vc.categoryDict = [catArray objectAtIndex:_selectedIndexPath.row];
     }
     else if ([segue.identifier isEqualToString:@"PushToDetailViewController"]) {
         NSDictionary *dict = [_foundArray objectAtIndex:_selectedIndexPath.section];
         
         NSArray *catArray = [dict objectForKey:@"data"];
         DetailViewController *vc = segue.destinationViewController;
         vc.bookDict = [catArray objectAtIndex:_selectedIndexPath.row];
     }
 }

- (IBAction)searchButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"PushToSearchViewController" sender:nil];
    
}

- (IBAction)settingButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"PushToSettingViewController" sender:nil];
}

- (IBAction)bookrackButtonClicked:(id)sender {
    HomeViewController *vc = [[self.navigationController viewControllers] objectAtIndex:([[self.navigationController viewControllers] count]-2)];
    [vc triangleAnimation];
    
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark - UITableView Delegate & Datasrouce -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _foundArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = [_foundArray objectAtIndex:section];
    
    if ([[dict objectForKey:@"export"] boolValue]) {
        NSArray *data = [dict objectForKey:@"data"];
        return data.count;
    }
    else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 126.f;
    }
    else{
        return 44.f;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Instantiate the nib content without any reference to it.
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TableviewSectionHeaderView" owner:nil options:nil];
    
    // Find the view among nib contents (not too hard assuming there is only one view in it).
    TableviewSectionHeaderView *tableviewSectionHeaderView = [nibContents lastObject];
    
    tableviewSectionHeaderView.frame = CGRectMake(0, 0, SCREEN_MIN_LENGTH, 44.f);
    NSDictionary *dict = [_foundArray objectAtIndex:section];
    [tableviewSectionHeaderView setupTableviewSectionHeaderView:dict];
    tableviewSectionHeaderView.tag = section;
    tableviewSectionHeaderView.delegate = self;
    
    return tableviewSectionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTableViewCell"];
        
        NSDictionary *dict = [_foundArray objectAtIndex:indexPath.section];
        NSArray *data = [dict objectForKey:@"data"];
        
        NSDictionary *bookDict = [data objectAtIndex:indexPath.row];
        [cell setupSearchTableViewCell:bookDict];
        
        if (indexPath.row == (data.count-1) && (_currentPage < _totalPage)) {
            _currentPage++;
            [self getBooksRecommendList];
        }
        
        return cell;
    }
    else{
        TypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TypeTableViewCell"];
        
        NSDictionary *dict = [_foundArray objectAtIndex:indexPath.section];
        NSArray *data = [dict objectForKey:@"data"];
        
        NSDictionary *bookDict = [data objectAtIndex:indexPath.row];
        [cell setupTypeTableViewCell:bookDict];
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedIndexPath = indexPath;
    
    if (indexPath.section == 2) {
        [self performSegueWithIdentifier:@"PushToDetailViewController" sender:nil];
    }
    else{
        [self performSegueWithIdentifier:@"PushToBookListViewController" sender:nil];
    }
    
}


#pragma mark - TableviewSectionHeaderViewDelegate
- (void)tableviewSectionHeaderViewClicked:(NSInteger)index{
    NSDictionary *foundDict = [_foundArray objectAtIndex:index];
    
    NSMutableDictionary *currentDict = [NSMutableDictionary dictionaryWithDictionary:foundDict];
    
    if (![[foundDict objectForKey:@"export"] boolValue]) {
        NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithDictionary:[_foundArray objectAtIndex:0]];
        [tmpDict setObject:@(NO) forKey:@"export"];
        [_foundArray replaceObjectAtIndex:0 withObject:tmpDict];
        
        tmpDict = [NSMutableDictionary dictionaryWithDictionary:[_foundArray objectAtIndex:1]];
        [tmpDict setObject:@(NO) forKey:@"export"];
        [_foundArray replaceObjectAtIndex:1 withObject:tmpDict];
        
        tmpDict = [NSMutableDictionary dictionaryWithDictionary:[_foundArray objectAtIndex:2]];
        [tmpDict setObject:@(NO) forKey:@"export"];
        [_foundArray replaceObjectAtIndex:2 withObject:tmpDict];
    }
    
    [currentDict setObject:@(![[foundDict objectForKey:@"export"] boolValue]) forKey:@"export"];
    [_foundArray replaceObjectAtIndex:index withObject:currentDict];
    
    [_tableView reloadData];

}
@end
