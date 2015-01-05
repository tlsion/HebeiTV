//
//  HBAboutViewController.m
//  HebeiTV
//
//  Created by Pro on 6/6/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "HBAboutViewController.h"

@interface HBAboutViewController ()
{
    
    IBOutlet UILabel *vanInfoLabel;
    IBOutlet UIImageView *aboutImageView;
}
@end

@implementation HBAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    if (SCREEN_MAX_HEIGHT==480) {
//        
//        aboutImageView.image=[UIImage imageNamed:@"欢迎画面832X640"];
//    }
//    else{
//        
//        aboutImageView.image=[UIImage imageNamed:@"欢迎画面1008X640"];
//    }

    NSString * currentVersion=[NSString stringWithFormat:@"V %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];

    vanInfoLabel.text=[NSString stringWithFormat:@"版本信息：%@",currentVersion];
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    aboutImageView.frame=CGRectMake(0, 0, 320, SCREEN_MAX_HEIGHT-NAV_HEI_64);
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
