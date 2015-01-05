//
//  HBSettingViewController.m
//  HebeiTV
//
//  Created by Pro on 6/6/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "HBSettingViewController.h"
#import "HBAlertView.h"
#import "UIView+Action.h"

#import <ZYPush/LPService.h>
@interface HBSettingViewController ()
{
    NSUserDefaults * userDefaults;
    IBOutlet UIButton *loginButton;
    
    IBOutlet UIButton *detectionVersionButton;
}
@end

@implementation HBSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setButtonStatue];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    userDefaults=[NSUserDefaults standardUserDefaults];
   
//    NSString * currentVersion=[NSString stringWithFormat:@"V %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
//    UILabel *l1=[[UILabel alloc]initWithFrame:CGRectMake(180, 10, 80, 20)];
//    l1.backgroundColor = CLEAR;
//    l1.textAlignment=NSTextAlignmentCenter;
//    l1.text=currentVersion;
//    [l1 setTextColor:GRAY];
//    [detectionVersionButton addSubview:l1];
    
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)detectionVersion:(id)sender {
    [self getAppManagerupdateApk];
}
- (IBAction)loginAndLogoutAction:(UIButton *)sender {
    if (sender.selected) {
        HBAlertView * av=[[HBAlertView alloc]initWithTitle:@"提示" contentText:@"您现在处于登录状态，是否退出登录" leftButtonTitle:@"取消" rightButtonTitle:@"退出"];
        [av show];
        av.rightBlock=^(void){
            [userDefaults setObject:NO forKey:@"islogin"];
            [userDefaults setObject:@"" forKey:@"phone"];
            [userDefaults setObject:@"" forKey:@"password"];
            [userDefaults setObject:@"0" forKey:@"age"];
            [userDefaults setObject:@"0" forKey:@"sex"];
            [userDefaults setObject:@"0" forKey:@"type"];
            [userDefaults setObject:@"" forKey:@"userId"];
            [userDefaults setObject:@"" forKey:@"userimages"];
            [userDefaults setObject:@"" forKey:@"username"];
            [userDefaults synchronize];
            [LPService cancelAlias:^(BOOL isSucess, NSString *info) {
                
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATA_NEW_BEANS" object:nil];
            [self performSegueWithIdentifier:@"LoginModel" sender:self];
        };
    }else {
        
        [self performSegueWithIdentifier:@"LoginModel" sender:self];
    }

}
- (IBAction)PersonalInfoAction:(id)sender {
    if ([[userDefaults objectForKey:@"islogin"]boolValue]) {
        
        [self performSegueWithIdentifier:@"PersonalInfoPush" sender:self];
    }else{
        HBAlertView * av=[[HBAlertView alloc]initWithTitle:@"提示" contentText:@"您还未登录，请先登录" leftButtonTitle:@"取消" rightButtonTitle:@"登录"];
        [av show];
        av.rightBlock=^(void){
            [self performSegueWithIdentifier:@"LoginModel" sender:self];
        };
    }
}
-(void)setButtonStatue{
    if ([[userDefaults objectForKey:@"islogin"]boolValue]) {
        [loginButton setSelected:YES];
        [loginButton setTitle:@"注销" forState:UIControlStateNormal];
    }
    else{
        
        [loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [loginButton setSelected:NO];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getAppManagerupdateApk{
    [self.view makeToastActivity];
    NSDictionary
    * paramDic=@{@"appDesc": @"ios"};
    [HBHTTPService requestGetMethod:@"ImplAppManagerupdateApk.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
        AppDelegate * app=APP;
        [app getUserInfogetBean];
        if (service.status==1) {
            if (service.allLists.count>=1) {
                NSDictionary * dic=[service.allLists objectAtIndex:0];
                int appVersion=[[dic objectForKey:@"appVersion"] intValue];
                
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                
                int appBuild = [[infoDictionary objectForKey:@"CFBundleVersion"] intValue];
                if (appVersion>appBuild) {
                    HBAlertView * av=[[HBAlertView alloc]initWithTitle:@"提示" contentText:@"目前有最新版本，是否升级?" leftButtonTitle:@"取消" rightButtonTitle:@"升级"];
                    [av show];
                    av.rightBlock=^(){
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:DownLoadURL]];
                    
                    };
                }
                else{
                    HBAlertView * av=[[HBAlertView alloc]initWithMessage:@"当前版本为最新版本"];
                    [av show];
                }
                
            }
        }
        [self.view hideToastActivity];
        
    }andServiceFailBlock:^(void){
        ALERT(@"服务器出错!");
        [self.view hideToastActivity];
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //    if ((alertView.tag==100 && buttonIndex==0) || (alertView.tag==101 && buttonIndex==1)) {
    //         [self.navigationController popViewControllerAnimated:YES];
    //    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
