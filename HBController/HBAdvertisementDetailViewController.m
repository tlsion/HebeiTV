//
//  HBAdvertisementDetailViewController.m
//  HebeiTV
//
//  Created by Pro on 6/5/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "HBAdvertisementDetailViewController.h"

@interface HBAdvertisementDetailViewController ()
{
    
     UIWebView *mainWebView;
}
@end

@implementation HBAdvertisementDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURLRequest * urlRequest=[NSURLRequest requestWithURL:self.adURL];
    mainWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, SCREEN_MAX_HEIGHT-NAV_HEI_64)];
    [self.view addSubview:mainWebView];
    [mainWebView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
