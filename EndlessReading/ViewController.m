//
//  ViewController.m
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 15/12/18.
//  Copyright © 2015年 Satinno. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Helper.h"
#import "UIColor+Helper.h"

@interface ViewController ()
{
    __weak IBOutlet UIButton *_skipButton;
    __weak IBOutlet UIImageView *_adsImageView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UINavigationBar* navBar = self.navigationController.navigationBar;
    int borderSize = 1;
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0, navBar.frame.size.height-borderSize,navBar.frame.size.width, borderSize)];
    [navBorder setBackgroundColor:[UIColor redColor]];
    [self.navigationController.navigationBar addSubview:navBorder];
    
    [_skipButton cornerRadius:2.f BorderWidth:1.f BorderColor:[UIColor colorWithHexString:@"#cccccc"]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)skipButtonClicked:(id)sender {
//    [[WebServiceHttpClient sharedWebServiceHTTPClient] getAdvertiseWithParams:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error, NSString *errorMessage) {
//        
//    }];
    [self performSegueWithIdentifier:@"PushToHomeViewController" sender:nil];
}
- (IBAction)adsButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"PushToADSViewController" sender:nil];
}

@end
