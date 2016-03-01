//
//  HomeViewController.m
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 15/12/28.
//  Copyright © 2015年 Satinno. All rights reserved.
//

#import "HomeViewController.h"
#import "CBAutoScrollLabel.h"
#import "HomeTableViewCell.h"
#import "DetailViewController.h"
#import "FoundViewController.h"
#import "ReadViewController.h"

@interface HomeViewController ()<UIActionSheetDelegate>
{
    __weak IBOutlet CBAutoScrollLabel *_autoScrollLabel;
    __weak IBOutlet UITableView *_tableView;
    
    __weak IBOutlet UIView *_headerView;
    
    __weak IBOutlet NSLayoutConstraint *_trangleCenterConstraint;
    
    __weak IBOutlet UIImageView *_trangleImageView;
    
    NSInteger _currentSelectIndex;
    NSMutableArray *_homeArray;

    NSInteger _exportIndex;
    NSArray *_serviceArray;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _autoScrollLabel.text = @"测试滚动label测试滚动label测试滚动label测试滚动label测试滚动label 测试滚动label测试滚动label测试滚动label";
//    _autoScrollLabel.textColor = [UIColor blueColor];
//    _autoScrollLabel.labelSpacing = 35; // distance between start and end labels
//    _autoScrollLabel.pauseInterval = 3.7; // seconds of pause before scrolling starts again
//    _autoScrollLabel.scrollSpeed = 30; // pixels per second
//    _autoScrollLabel.textAlignment = NSTextAlignmentCenter; // centers text _autoScrollLabel no auto-scrolling is applied
//    _autoScrollLabel.fadeLength = 12.f; // length of the left and right edge fade, 0 to disable
    
    _foundArray = [NSMutableArray new];
}


- (void)triangleAnimation{
    _trangleCenterConstraint.constant = 180;
    [_headerView updateConstraintsIfNeeded];
    [_headerView layoutIfNeeded];
    
    _trangleCenterConstraint.constant= 0;
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
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _homeArray = [userDefaults objectForKey:BookrackUserDefaultKey];
    
    [_tableView reloadData];
}



- (void)getBookList{
    __weak HomeViewController *tmpSelf = self;
    
    if (_homeArray.count > 0) {
        NSMutableString *booksIDString = [NSMutableString new];
        
        for (NSDictionary *dict in _homeArray) {
            if (dict == [_homeArray firstObject]) {
                [booksIDString appendFormat:@"%@", [[dict objectForKey:@"book_id"] description]];
            }
            else{
                [booksIDString appendFormat:@",%@", [[dict objectForKey:@"book_id"] description]];
            }
        }
        
        [[WebServiceHttpClient sharedWebServiceHTTPClient] getBooksListCtalogWithParams:@{@"book_ids":booksIDString} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [tmpSelf getBookListSuccess:responseObject];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage];
        }];
    }
    
    
}

- (void)getBookListSuccess:(NSDictionary*)dict{
    NSDictionary *dictDict = [dict objectForKey:@"data"];
    
    _serviceArray = [dictDict objectForKey:@"listData"];
    
    [_tableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"PushToDetailViewController"]) {
        NSDictionary *dict = [_homeArray objectAtIndex:_currentSelectIndex];

        DetailViewController *vc = segue.destinationViewController;
        vc.bookDict = dict;
    }
    else if ([segue.identifier isEqualToString:@"PushToFoundViewController"]){
        FoundViewController *vc = segue.destinationViewController;
        vc.exportIndex = _exportIndex;
    }
    else if ([segue.identifier isEqualToString:@"PushToReadViewController"]) {
        NSDictionary *dict = [_homeArray objectAtIndex:_currentSelectIndex];
        
        ReadViewController *vc = segue.destinationViewController;
        vc.bookDict = dict;
    }
}

- (IBAction)searchButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"PushToSearchViewController" sender:nil];
    
}

- (IBAction)settingButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"PushToSettingViewController" sender:nil];
}

- (IBAction)foundButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"PushToFoundViewController" sender:nil];
}

- (IBAction)plusButtonClicked:(id)sender {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分类", @"排行榜", nil];
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        buttonIndex = 2;
    }
    else if (buttonIndex == 1) {
        buttonIndex = 1;
    }
    _exportIndex = buttonIndex;
    
    [self performSegueWithIdentifier:@"PushToFoundViewController" sender:nil];
}

#pragma mark - 删除文件
- (void)deleteBook:(NSInteger)index{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:_homeArray];
    [tmpArray removeObjectAtIndex:index];
    
    [userDefaults setObject:tmpArray forKey:BookrackUserDefaultKey];
    [userDefaults synchronize];
    
    _homeArray = tmpArray;
    [_tableView reloadData];
    
    [SVProgressHUD showSuccessWithStatus:@"已移出你的书架"];
}

#pragma mark - UITableView Delegate & Datasrouce -
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak HomeViewController *tmpSelf = self;
    
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        [tmpSelf deleteBook:indexPath.row];
                                    }];
    
    UIColor *deleteColor = [UIColor redColor];
    button.backgroundColor = deleteColor; //arbitrary color

    return @[button]; //array with all the buttons you want. 1,2,3, etc...
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // you need to implement this method too or nothing will work:
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES; //tableview must be editable or nothing will work...
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _homeArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 91.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell"];
    NSDictionary *dict = [_homeArray objectAtIndex:indexPath.row];
    
    if (_serviceArray.count > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.book_id == %@", [dict objectForKey:@"book_id"]];
        NSArray *results = [_serviceArray filteredArrayUsingPredicate:predicate];
        
        if (results.count > 0) {
            NSDictionary *serverDict = [results firstObject];
            
            if ([[serverDict objectForKey:@"chapter_all_nums"] integerValue] != [[dict objectForKey:@"chapter_all_nums"] integerValue]) {
                [cell setupHomeTableViewCell:dict HaveUpdate:YES];
            }
            else{
                [cell setupHomeTableViewCell:dict HaveUpdate:NO];
            }
        }
    }
    else{
        [cell setupHomeTableViewCell:dict HaveUpdate:NO];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _currentSelectIndex = indexPath.row;
    
    NSDictionary *dict = [_homeArray objectAtIndex:indexPath.row];
    
    if (_serviceArray.count > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.book_id == %@", [dict objectForKey:@"book_id"]];
        NSArray *results = [_serviceArray filteredArrayUsingPredicate:predicate];
        
        if (results.count > 0) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

            NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:_homeArray];
            [tmpArray replaceObjectAtIndex:_currentSelectIndex withObject:results.firstObject];
            
            [userDefaults setObject:tmpArray forKey:BookrackUserDefaultKey];
            [userDefaults synchronize];
            
            [_tableView reloadData];
        }
    }
    
    [self performSegueWithIdentifier:@"PushToReadViewController" sender:nil];
}

@end
