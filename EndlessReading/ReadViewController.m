//
//  ReadViewController.m
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 16/1/6.
//  Copyright © 2016年 Satinno. All rights reserved.
//

#import "ReadViewController.h"
#import "ReadHeaderView.h"
#import "ReadFooterView.h"
#import "CharTableViewCell.h"
#import "NSString+Helper.h"

#define headerHeight 64
#define footerHeight 180

@interface ReadViewController ()<ReadHeaderViewDelegate, ReadFooterViewDelegate>
{
    __weak IBOutlet UILabel *_titleLabel;
    
    __weak IBOutlet UITextView *_textView1;
    __weak IBOutlet UITextView *_textView2;
    
    NSString *_chapterContent;
    
    BOOL _isShowingTextView1;
    
    NSInteger _currentPage;
    NSMutableArray *_pageArray;
    
    ReadHeaderView *_headerView;
    ReadFooterView *_footerView;
    
    BOOL _isAnimation;
    BOOL _headerFooterHidden;
    
    __weak IBOutlet UITableView *_charTableView;
    
    NSMutableArray *_chartArray;
    
    NSInteger _currentChartIndex;
    
    BOOL _isDownloading;
    
    NSInteger _haveDownloadNumber;
}
@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIScreen mainScreen] setBrightness:0.5];

    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"ReadHeaderView"
                                   owner:nil
                                 options:nil] objectAtIndex:0];
    _footerView = [[[NSBundle mainBundle] loadNibNamed:@"ReadFooterView"
                                                 owner:nil
                                               options:nil] objectAtIndex:0];
    
    
    _headerView.frame = CGRectMake(0, -headerHeight, SCREEN_MIN_LENGTH, headerHeight);
    [self.view addSubview:_headerView];
    _headerView.delegate = self;
    [_headerView setTitle:[_bookDict objectForKey:@"book_name"]];
    
    _footerView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)+footerHeight, SCREEN_MIN_LENGTH, footerHeight);
    [self.view addSubview:_footerView];
    _footerView.delegate = self;
    
    _isAnimation = NO;
    _headerFooterHidden = YES;
    
    _charTableView.hidden = YES;
    
    _chartArray = [NSMutableArray new];
    
    [self getBookChapters];
    
    _pageArray = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.view bringSubviewToFront:_headerView];
    [self.view bringSubviewToFront:_footerView];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)getBookChapters{
    __weak ReadViewController *tmpSelf = self;
    
    if (_isDownloading) {
        [SVProgressHUD show];
    }
    [[WebServiceHttpClient sharedWebServiceHTTPClient] getBooksChaptersWithParams:@{@"book_id":[_bookDict objectForKey:@"book_id"], @"alldata":@(1)} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [tmpSelf getBooksChaptersSuccess:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage) {
        [SVProgressHUD showErrorWithStatus:errorMessage];
    }];
}

- (void)getBooksChaptersSuccess:(NSDictionary*)dict{
    NSDictionary *dictDict = [dict objectForKey:@"data"];
    
    [_chartArray addObjectsFromArray:[dictDict objectForKey:@"listData"]];
    [_charTableView reloadData];
    
    if (_chartArray.count > 0) {
        NSDictionary *chartDict = [_chartArray firstObject];
        _currentChartIndex = 0;
        
        _titleLabel.text = [chartDict objectForKey:@"chapter_title"];
        [self getBooksChapterContent:[chartDict objectForKey:@"chapter_id"]];
    }
}

- (void)getBooksChapterContent:(NSString*)chapterId{
    NSString *fileName = [NSString stringWithFormat:@"%@%@.txt", [[_bookDict objectForKey:@"book_id"] description], chapterId];
    NSString *filePath = [[NSString saveFilePath] stringByAppendingPathComponent:fileName];
    
    if (_isDownloading) {
        [_footerView setDownloadLabelText:[NSString stringWithFormat:@"%ld/%lu", (long)_haveDownloadNumber, (unsigned long)_chartArray.count]];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:nil]) {
        _chapterContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        
        if (_isDownloading) {
            _haveDownloadNumber++;
            
            if (_chartArray.count > _haveDownloadNumber) {
                NSDictionary *chartDict = [_chartArray objectAtIndex:_haveDownloadNumber];
                
                [self getBooksChapterContent:[chartDict objectForKey:@"chapter_id"]];
            }
            else{
                [_footerView setDownloadLabelText:@"缓存完成"];
            }
        }
        else{
            [self updateContent:_chapterContent];
        }
    }
    else{
        __weak ReadViewController *tmpSelf = self;
        __weak NSString *tmpChapterId = chapterId;
        
        [[WebServiceHttpClient sharedWebServiceHTTPClient] getBooksChapterContentWithParams:@{@"book_id":[_bookDict objectForKey:@"book_id"], @"chapter_id":chapterId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [tmpSelf getBooksChapterContentSuccess:responseObject ChapterId:tmpChapterId];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage) {
            [SVProgressHUD showErrorWithStatus:errorMessage];
        }];
    }
}

- (void)getBooksChapterContentSuccess:(NSDictionary*)dict ChapterId:(NSString*)chapterId{
    _chapterContent = [[dict objectForKey:@"data"] objectForKey:@"chapter_content"];
    
    if (_isDownloading) {
        _haveDownloadNumber++;
        
        if (_chartArray.count > _haveDownloadNumber) {
            NSDictionary *chartDict = [_chartArray objectAtIndex:_haveDownloadNumber];
            
            [self getBooksChapterContent:[chartDict objectForKey:@"chapter_id"]];
        }
        else{
            [_footerView setDownloadLabelText:@"缓存完成"];
        }
    }
    else{
        [self updateContent:_chapterContent];
    }

    NSError *error;
    
    NSString *fileName = [NSString stringWithFormat:@"%@%@.txt", [[_bookDict objectForKey:@"book_id"] description], chapterId];
    NSString *filePath = [[NSString saveFilePath] stringByAppendingPathComponent:fileName];
    BOOL succeed = [_chapterContent writeToFile:filePath
                                     atomically:YES
                                       encoding:NSUTF8StringEncoding
                                          error:&error];
    if (!succeed){
        // Handle error here
    }
}

- (void)updateContent:(NSString*)chapterContent{
    NSInteger contentLenght = chapterContent.length;
    
    NSDictionary *attributes = @{NSFontAttributeName: _textView1.font};
    
    NSInteger startIndex = 0;
    for (NSInteger i = 0; i < contentLenght; i++) {
        NSInteger tmpI = i + 500;
        if (tmpI >= contentLenght) {
            tmpI = contentLenght;
        }
        NSString *subString = [chapterContent substringWithRange:NSMakeRange(startIndex, tmpI-startIndex)];
        
        CGRect tmpRect = [subString boundingRectWithSize:CGSizeMake(SCREEN_MIN_LENGTH, 1000)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:attributes context:nil];
        
        if (CGRectGetHeight(tmpRect) > CGRectGetHeight(self.view.bounds)) {
            for (NSInteger j = tmpI-startIndex; j > 0; j--) {
                subString = [chapterContent substringWithRange:NSMakeRange(startIndex, j)];
                
                tmpRect = [subString boundingRectWithSize:CGSizeMake(SCREEN_MIN_LENGTH, 1000)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:attributes context:nil];
                
                if (CGRectGetHeight(tmpRect) <= CGRectGetHeight(self.view.bounds)) {
                    subString = [chapterContent substringWithRange:NSMakeRange(startIndex, j)];
                    [_pageArray addObject:subString];
                    
                    i = startIndex + j;
                    
                    startIndex = i;
                    
                    break;
                }
            }
        }
    }
    
    _currentPage = 0;
    _textView1.text = [_pageArray firstObject];
    _isShowingTextView1 = YES;
    
    _textView1.frame = CGRectMake(0, 30, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    _textView2.frame = CGRectMake(CGRectGetWidth(self.view.frame), 30, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)prevButtonClicked:(id)sender {
    if (_currentPage > 0) {
        _currentPage--;

        if (_isShowingTextView1) {
            _isShowingTextView1 = NO;
            
            _textView2.text = [_pageArray objectAtIndex:_currentPage];
            _textView2.frame = CGRectMake(-CGRectGetWidth(self.view.frame), 30, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            
            [UIView animateWithDuration:0.2 animations:^{
                _textView2.frame = CGRectMake(0, 30, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
                _textView1.frame = CGRectMake(CGRectGetWidth(self.view.frame), 30, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            } completion:^(BOOL finished) {
                
            }];
        }
        else{
            _isShowingTextView1 = YES;
            
            _textView1.text = [_pageArray objectAtIndex:_currentPage];
            _textView1.frame = CGRectMake(-CGRectGetWidth(self.view.frame), 30, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            
            [UIView animateWithDuration:0.2 animations:^{
                _textView1.frame = CGRectMake(0, 30, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
                _textView2.frame = CGRectMake(CGRectGetWidth(self.view.frame), 30, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}
- (IBAction)centerButtonClicked:(id)sender {
    _charTableView.hidden = YES;
    if (!_isAnimation) {
        _isAnimation = YES;
        
        [UIView animateWithDuration:0.5 animations:^{
            if (_headerFooterHidden) {
                _headerFooterHidden = NO;
                
                _headerView.frame = CGRectMake(0, 0, SCREEN_MIN_LENGTH, headerHeight);
                
                _footerView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)-footerHeight, SCREEN_MIN_LENGTH, footerHeight);
            }
            else{
                _headerFooterHidden = YES;
                
                _headerView.frame = CGRectMake(0, -headerHeight, SCREEN_MIN_LENGTH, headerHeight);
                
                _footerView.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)+footerHeight, SCREEN_MIN_LENGTH, footerHeight);
            }
            
        } completion:^(BOOL finished) {
            _isAnimation = NO;
        }];
    }
    
}

- (IBAction)nextButtonClicked:(id)sender {
    if (_currentPage < (_pageArray.count-1)) {
        _currentPage++;
        
        if (_isShowingTextView1) {
            _isShowingTextView1 = NO;
            
            _textView2.text = [_pageArray objectAtIndex:_currentPage];
            _textView2.frame = CGRectMake(CGRectGetWidth(self.view.frame), 30, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            
            [UIView animateWithDuration:0.2 animations:^{
                _textView2.frame = CGRectMake(0, 30, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
                _textView1.frame = CGRectMake(-CGRectGetWidth(self.view.frame), 30, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            } completion:^(BOOL finished) {
                
            }];
        }
        else{
            _isShowingTextView1 = YES;
            
            _textView1.text = [_pageArray objectAtIndex:_currentPage];
            _textView1.frame = CGRectMake(CGRectGetWidth(self.view.frame), 30, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            
            [UIView animateWithDuration:0.2 animations:^{
                _textView1.frame = CGRectMake(0, 30, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
                _textView2.frame = CGRectMake(-CGRectGetWidth(self.view.frame), 30, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    else if(_currentChartIndex < (_chartArray.count-1)){
        _currentChartIndex++;
        
        NSDictionary *chartDict = [_chartArray objectAtIndex:_currentChartIndex];
        
        _titleLabel.text = [chartDict objectForKey:@"chapter_title"];
        
        [self getBooksChapterContent:[chartDict objectForKey:@"chapter_id"]];
    }
}

#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _chartArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CharTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CharTableViewCell"];
    NSDictionary *dict = [_chartArray objectAtIndex:indexPath.row];
    [cell setupCharTableViewCell:dict isCurrent:(_currentChartIndex==indexPath.row)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *chartDict = [_chartArray objectAtIndex:indexPath.row];
    [self getBooksChapterContent:[chartDict objectForKey:@"chapter_id"]];
    
    _currentChartIndex = indexPath.row;
    _titleLabel.text = [chartDict objectForKey:@"chapter_title"];
    
    _charTableView.hidden = YES;
}

#pragma mark - ReadHeaderViewDelegate <NSObject>

- (void)backButtonClicked{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *array = [userDefaults objectForKey:BookrackUserDefaultKey];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.book_id == %@", [_bookDict objectForKey:@"book_id"]];
    NSArray *results = [array filteredArrayUsingPredicate:predicate];
    
    if (results.count > 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否放入书架？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"放入", nil];
        
        [alertView show];
    }
}

#pragma mark -  ReadFooterViewDelegate <NSObject>

- (void)sliderValueChanged:(CGFloat)brightness{
    [[UIScreen mainScreen] setBrightness:brightness];
}

- (void)whiteButtonClicked{
    _textView1.backgroundColor = [UIColor whiteColor];
    _textView2.backgroundColor = [UIColor whiteColor];
}

- (void)blueButtonClicked{
    _textView1.backgroundColor = [UIColor colorWithRed:199.f/255 green:237.f/255 blue:204.f/255 alpha:1.f];
    _textView2.backgroundColor = [UIColor colorWithRed:199.f/255 green:237.f/255 blue:204.f/255 alpha:1.f];
}

- (void)yellowButtonClicked{
    UIColor *backColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"yellowbackground.jpg"]];
    
    _textView1.backgroundColor = backColor;
    _textView2.backgroundColor = backColor;
}

- (void)zoomOutFontButtonClicked{
    CGFloat fontSize = _textView1.font.pointSize;
    if (fontSize> 10) {
        fontSize--;
        _textView1.font = [UIFont systemFontOfSize:fontSize];
        _textView2.font = [UIFont systemFontOfSize:fontSize];
        _titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    
    [self updateContent:_chapterContent];
}

- (void)zoomInFontButtonClicked{
    CGFloat fontSize = _textView1.font.pointSize;
    if (fontSize < 30) {
        fontSize++;
        _textView1.font = [UIFont systemFontOfSize:fontSize];
        _textView2.font = [UIFont systemFontOfSize:fontSize];
        _titleLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    
    [self updateContent:_chapterContent];
}

- (void)nightButtonClicked{
    
}

- (void)horizontalButtonClicked{
//    NSNumber *vale = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//    [[UIDevice currentDevice] setValue:vale forKey:@"orientation"];
//    
    //设置应用程序的状态栏到指定的方向
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    //view旋转
    [self.view setTransform:CGAffineTransformMakeRotation(M_PI/2)];
    
    self.view.frame = CGRectMake(0, 0, SCREEN_MAX_LENGTH, SCREEN_MIN_LENGTH);
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];
    
    if (!_headerFooterHidden) {
        _headerView.frame = CGRectMake(0, 0, SCREEN_MAX_LENGTH, headerHeight);
        _footerView.frame = CGRectMake(0, SCREEN_MIN_LENGTH-footerHeight, SCREEN_MAX_LENGTH, footerHeight);
    }
}

- (void)downloadButtonClicked{
    _isDownloading = YES;

    _haveDownloadNumber = 0;
    [SVProgressHUD dismiss];
    
    NSDictionary *chartDict = [_chartArray objectAtIndex:_haveDownloadNumber];
    [self getBooksChapterContent:[chartDict objectForKey:@"chapter_id"]];
}

- (void)catalogButtonClicked{
    if (_charTableView.hidden) {
        [_charTableView reloadData];
        
        _charTableView.hidden = NO;
    }
    else{
        _charTableView.hidden = YES;
    }
}

#pragma mark - 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSArray *array = [userDefaults objectForKey:BookrackUserDefaultKey];
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:array];
        [tmpArray addObject:_bookDict];
        
        [userDefaults setObject:tmpArray forKey:BookrackUserDefaultKey];
        [userDefaults synchronize];
        
        [SVProgressHUD showSuccessWithStatus:@"已放入你的书架"];
    }
}
@end
