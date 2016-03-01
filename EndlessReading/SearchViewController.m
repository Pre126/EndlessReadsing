//
//  SearchViewController.m
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 15/12/28.
//  Copyright © 2015年 Satinno. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "DetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "BookListViewController.h"

@interface SearchViewController ()<UISearchBarDelegate>
{
    __weak IBOutlet UITableView *_tableView;
    
    UISearchBar *_searchBar;
    NSMutableArray *_searchArray;
    NSMutableArray *_interestArray;
    
    NSInteger _currentPage;
    NSInteger _totalPage;
    
    NSInteger _currentSelectIndex;
    NSDictionary *_currentSelectBook;
    
    //////////
    __weak IBOutlet UIImageView *_likeImage1;
    __weak IBOutlet UILabel *_likeLabel1;
    
    __weak IBOutlet UIImageView *_likeImage2;
    __weak IBOutlet UILabel *_likeLabel2;
    
    __weak IBOutlet UIImageView *_likeImage3;
    __weak IBOutlet UILabel *_likeLabel3;
    
    __weak IBOutlet UIImageView *_likeImage4;
    __weak IBOutlet UILabel *_likeLabel4;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_MIN_LENGTH-90, 44)];
    _searchBar.placeholder = @"输入书名/作者名";
    _searchBar.delegate = self;
    
    for (UIView *subview in [[_searchBar.subviews lastObject] subviews]) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    
    [_searchBar setBackgroundColor:[UIColor clearColor]];
    [_searchBar setBarTintColor:[UIColor clearColor]]; //this is what you want
    
    //
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [okButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    
    okButton.frame = CGRectMake(0, 6, 45, 30);
//    [okButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    
    [okButton setImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:okButton];
    self.navigationItem.titleView = _searchBar;
    
    _searchArray = [NSMutableArray new];
    _interestArray = [NSMutableArray new];
    
    [self getBooksInterestList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchButtonClicked:(UIButton*)button{
    [_searchBar resignFirstResponder];
    
    [_searchArray removeAllObjects];
    [_tableView reloadData];
    
    _currentPage = 1;
    
    if (_searchBar.text.length > 0) {
        [self getBookList];
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
    [_searchArray removeAllObjects];
    [_tableView reloadData];
    
    _currentPage = 0;
    
    if (_searchBar.text.length > 0) {
        [self getBookList];
    }
}


- (void)getBookList{
    __weak SearchViewController *tmpSelf = self;
    
    [[WebServiceHttpClient sharedWebServiceHTTPClient] getBooksListCtalogWithParams:@{@"search_key":_searchBar.text, @"page":@(_currentPage), @"pagesize":@(PAGESIZE)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [tmpSelf getBookListSuccess:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage) {
        [SVProgressHUD showErrorWithStatus:errorMessage];
    }];
}

- (void)getBookListSuccess:(NSDictionary*)dict{
    NSDictionary *dictDict = [dict objectForKey:@"data"];
    
    _totalPage = [[dictDict objectForKey:@"page_total"] integerValue];
    [_searchArray addObjectsFromArray:[dictDict objectForKey:@"listData"]];
    
    [_tableView reloadData];
}

- (void)getBooksInterestList{
    __weak SearchViewController *tmpSelf = self;
    
    [[WebServiceHttpClient sharedWebServiceHTTPClient] getBooksRecommendListWithParams:@{@"list_type":@"interest"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [tmpSelf getBooksInterestListSuccess:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage) {
        [SVProgressHUD showErrorWithStatus:errorMessage];
    }];
}

- (void)getBooksInterestListSuccess:(NSDictionary*)dict{
    NSDictionary *dictDict = [dict objectForKey:@"data"];
    [_interestArray addObjectsFromArray:[dictDict objectForKey:@"listData"]];

    
    if (_interestArray.count >= 1) {
        NSDictionary *bookDict = [_interestArray objectAtIndex:0];
        NSString *imagePath = [bookDict objectForKey:@"book_img"];
        [_likeImage1 setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil];
        
        _likeLabel1.text = [bookDict objectForKey:@"book_name"];
    }
    if (_interestArray.count >= 2) {
        NSDictionary *bookDict = [_interestArray objectAtIndex:1];
        NSString *imagePath = [bookDict objectForKey:@"book_img"];
        [_likeImage3 setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil];
        
        _likeLabel2.text = [bookDict objectForKey:@"book_name"];
    }
    if (_interestArray.count >= 3) {
        NSDictionary *bookDict = [_interestArray objectAtIndex:2];
        NSString *imagePath = [bookDict objectForKey:@"book_img"];
        [_likeImage3 setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil];
        
        _likeLabel3.text = [bookDict objectForKey:@"book_name"];
    }
    if (_interestArray.count >= 4) {
        NSDictionary *bookDict = [_interestArray objectAtIndex:3];
        NSString *imagePath = [bookDict objectForKey:@"book_img"];
        [_likeImage4 setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil];
        
        _likeLabel4.text = [bookDict objectForKey:@"book_name"];
    }
}

#pragma  mark -
////////////
- (IBAction)likeButton1Clicked:(id)sender {
    _currentSelectBook = [_interestArray objectAtIndex:0];
    [self performSegueWithIdentifier:@"PushToDetailViewController" sender:nil];
}

- (IBAction)likeButton2Clicked:(id)sender {
    _currentSelectBook = [_interestArray objectAtIndex:1];
    [self performSegueWithIdentifier:@"PushToDetailViewController" sender:nil];
}

- (IBAction)likeButton3Clicked:(id)sender {
    _currentSelectBook = [_interestArray objectAtIndex:2];
    [self performSegueWithIdentifier:@"PushToDetailViewController" sender:nil];
}

- (IBAction)likeButton4Clicked:(id)sender {
    _currentSelectBook = [_interestArray objectAtIndex:3];
    [self performSegueWithIdentifier:@"PushToDetailViewController" sender:nil];
}

- (IBAction)moreButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"PushToBookListViewController" sender:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"PushToDetailViewController"]) {
        DetailViewController *vc = segue.destinationViewController;
        
        if (_currentSelectBook) {
            vc.bookDict = _currentSelectBook;
            
            _currentSelectBook = nil;
        }
        else{
            NSDictionary *dict = [_searchArray objectAtIndex:_currentSelectIndex];
            vc.bookDict = dict;
        }
    }
    else if ([segue.identifier isEqualToString:@"PushToBookListViewController"]) {
        BookListViewController *vc = segue.destinationViewController;
        vc.isInterest = YES;
    }
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 126.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTableViewCell"];
    NSDictionary *dict = [_searchArray objectAtIndex:indexPath.row];
    [cell setupSearchTableViewCell:dict];
    
    if (indexPath.row == (_searchArray.count-1) && (_currentPage < _totalPage)) {
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
