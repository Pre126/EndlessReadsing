//
//  DetailViewController.m
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 15/12/29.
//  Copyright © 2015年 Satinno. All rights reserved.
//

#import "DetailViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "BookListViewController.h"
#import "ReadViewController.h"
#import "NSString+Helper.h"
#import "UIView+Helper.h"

@interface DetailViewController ()
{
    __weak IBOutlet UIButton *_rightButton;
    
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_authorLabel;
    
    __weak IBOutlet UILabel *_timeLabel;
    __weak IBOutlet UILabel *_readNumberLabel;
    __weak IBOutlet UIButton *_addBookrackButton;
    __weak IBOutlet UIButton *_startReadButton;
    
    __weak IBOutlet UILabel *_contentLabel;
    
    __weak IBOutlet UIImageView *_adsImageView;
    __weak IBOutlet UILabel *_adsTitleLabel;
    __weak IBOutlet UILabel *_adsContentLabel;
    
    NSMutableArray *_interestArray;
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
    
    NSArray *_chartArray;
    NSInteger _haveDownloadNumber;
}
@end

@implementation DetailViewController
-(void)dealloc{
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];

    _rightButton.frame = CGRectMake(0, 0, 60, 30);
    
    self.title = [_bookDict objectForKey:@"book_name"];
    
    _interestArray = [NSMutableArray new];
    
    [self getBookDetail];
    [self getBooksInterestList];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [userDefaults objectForKey:BookrackUserDefaultKey];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.book_id == %@", [_bookDict objectForKey:@"book_id"]];
    NSArray *results = [array filteredArrayUsingPredicate:predicate];
    if (results.count > 0) {
        [_addBookrackButton setTitle:@"移出书架" forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getBookDetail{
    __weak DetailViewController *tmpSelf = self;
    [SVProgressHUD show];
    [[WebServiceHttpClient sharedWebServiceHTTPClient] getBooksDetailWithParams:@{@"book_id":[_bookDict objectForKey:@"book_id"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [tmpSelf getBookDetailSuccess:responseObject];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage) {
        [SVProgressHUD showErrorWithStatus:errorMessage];
    }];
    
}
- (void)getBookDetailSuccess:(NSDictionary*)dict{
    NSDictionary *getDetailDict = [dict objectForKey:@"data"];
    
    NSString *imagePath = [getDetailDict objectForKey:@"book_img"];
    [_imageView setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil];
    
    _nameLabel.text = [getDetailDict objectForKey:@"book_name"];
    _authorLabel.text = [NSString stringWithFormat:@"%@ | %@", [getDetailDict objectForKey:@"zuozhe"], [getDetailDict objectForKey:@"catalog_name"]];
    _readNumberLabel.text = [NSString stringWithFormat:@"%@人在读", [getDetailDict objectForKey:@"bookclick"]];
    
    _timeLabel.text = [getDetailDict objectForKey:@"update_time"];
    _contentLabel.text = [getDetailDict objectForKey:@"description"];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"PushToBookListViewController"]) {
        BookListViewController *vc = segue.destinationViewController;
        vc.isInterest = YES;
    }
    else if ([segue.identifier isEqualToString:@"PushToReadViewController"]) {
        ReadViewController *vc = segue.destinationViewController;
        vc.bookDict = self.bookDict;
    }
}


- (IBAction)addBookrackButtonClicked:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *array = [userDefaults objectForKey:BookrackUserDefaultKey];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.book_id == %@", [_bookDict objectForKey:@"book_id"]];
    NSArray *results = [array filteredArrayUsingPredicate:predicate];
    
    if (results.count > 0) {
        NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:array];
        [tmpArray removeObjectsInArray:results];
        
        [userDefaults setObject:tmpArray forKey:BookrackUserDefaultKey];
        [userDefaults synchronize];
        
        [_addBookrackButton setTitle:@"放入书架" forState:UIControlStateNormal];
        [SVProgressHUD showSuccessWithStatus:@"已移出你的书架"];
    }
    else{
        NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:array];
        [tmpArray addObject:_bookDict];
        
        [userDefaults setObject:tmpArray forKey:BookrackUserDefaultKey];
        [userDefaults synchronize];
        [_addBookrackButton setTitle:@"移出书架" forState:UIControlStateNormal];
//        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        
        [SVProgressHUD showSuccessWithStatus:@"已放入你的书架"];
    }
}

- (IBAction)startReadButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"PushToReadViewController" sender:nil];
}
#pragma mark -
- (void)getBookChapters{
    __weak DetailViewController *tmpSelf = self;
    
    [SVProgressHUD show];
    [[WebServiceHttpClient sharedWebServiceHTTPClient] getBooksChaptersWithParams:@{@"book_id":[_bookDict objectForKey:@"book_id"], @"alldata":@(1)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [tmpSelf getBooksChaptersSuccess:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage) {
        [SVProgressHUD showErrorWithStatus:errorMessage];
    }];
}

- (void)getBooksChaptersSuccess:(NSDictionary*)dict{
    NSDictionary *dictDict = [dict objectForKey:@"data"];
    
    _chartArray = [dictDict objectForKey:@"listData"];
    
    if (_chartArray.count > 0) {
        NSDictionary *chartDict = [_chartArray firstObject];
        
        [self getBooksChapterContent:[chartDict objectForKey:@"chapter_id"]];
    }
}

- (void)getBooksChapterContent:(NSString*)chapterId{
    NSString *fileName = [NSString stringWithFormat:@"%@%@.txt", [[_bookDict objectForKey:@"book_id"] description], chapterId];
    NSString *filePath = [[NSString saveFilePath] stringByAppendingPathComponent:fileName];
    
    [_rightButton setTitle:[NSString stringWithFormat:@"%ld/%lu", (long)_haveDownloadNumber, (unsigned long)_chartArray.count] forState:UIControlStateNormal];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:nil]) {
        _haveDownloadNumber++;
        
        if (_chartArray.count > _haveDownloadNumber) {
            NSDictionary *chartDict = [_chartArray objectAtIndex:_haveDownloadNumber];
            
            [self getBooksChapterContent:[chartDict objectForKey:@"chapter_id"]];
        }
        else{
            [SVProgressHUD dismiss];
        }
    }
    else{
        __weak DetailViewController *tmpSelf = self;
        __weak NSString *tmpChapterId = chapterId;
        
        [[WebServiceHttpClient sharedWebServiceHTTPClient] getBooksChapterContentWithParams:@{@"book_id":[_bookDict objectForKey:@"book_id"], @"chapter_id":chapterId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [tmpSelf getBooksChapterContentSuccess:responseObject ChapterId:tmpChapterId];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage];
        }];
    }
}

- (void)getBooksChapterContentSuccess:(NSDictionary*)dict ChapterId:(NSString*)chapterId{
    _haveDownloadNumber++;
    
    if (_chartArray.count > _haveDownloadNumber) {
        NSDictionary *chartDict = [_chartArray objectAtIndex:_haveDownloadNumber];
        
        [self getBooksChapterContent:[chartDict objectForKey:@"chapter_id"]];
    }
    else{
        [_rightButton setTitle:@"缓存完成" forState:UIControlStateNormal];
    }
    
    NSString *chapterContent = [[dict objectForKey:@"data"] objectForKey:@"chapter_content"];
    
    NSError *error;
    
    NSString *fileName = [NSString stringWithFormat:@"%@%@.txt", [[_bookDict objectForKey:@"book_id"] description], chapterId];
    NSString *filePath = [[NSString saveFilePath] stringByAppendingPathComponent:fileName];
    
    BOOL succeed = [chapterContent writeToFile:filePath
                                     atomically:YES
                                       encoding:NSUTF8StringEncoding
                                          error:&error];
    if (!succeed){
        // Handle error here
    }
}

- (void)getBooksInterestList{
    __weak DetailViewController *tmpSelf = self;
    
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
- (IBAction)downloadAllButtonClicked:(id)sender {
    _haveDownloadNumber = 0;
    
    [self getBookChapters];
}
////////////
- (IBAction)likeButton1Clicked:(id)sender {
    self.bookDict = [_interestArray objectAtIndex:0];
    
    self.title = [_bookDict objectForKey:@"book_name"];
    [self getBookDetail];
}

- (IBAction)likeButton2Clicked:(id)sender {
    self.bookDict = [_interestArray objectAtIndex:1];
    
    self.title = [_bookDict objectForKey:@"book_name"];
    [self getBookDetail];
}

- (IBAction)likeButton3Clicked:(id)sender {
    self.bookDict = [_interestArray objectAtIndex:2];
    
    self.title = [_bookDict objectForKey:@"book_name"];
    [self getBookDetail];
}

- (IBAction)likeButton4Clicked:(id)sender {
    self.bookDict = [_interestArray objectAtIndex:3];
    
    self.title = [_bookDict objectForKey:@"book_name"];
    [self getBookDetail];
}

- (IBAction)moreButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"PushToBookListViewController" sender:nil];
}

@end
