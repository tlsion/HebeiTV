//
//  HBLogAndResignViewController.m
//  HebeiTV
//
//  Created by Pro on 5/19/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "HBLogViewController.h"
#import "HBHomeViewController.h"
#import "Regular.h"
#import "UIView+Action.h"
@interface HBLogViewController ()

@end

@implementation HBLogViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self dismissKeyBoard];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFinishAction) name:@"Post_Login_Finished" object:nil];
    
    // Do any additional setup after loading the view.
    [self.phoneNumber setTextTitle:@"账号"];
    [self.passWord setTextTitle:@"密码"];
    
    //手势回收键盘
    UITapGestureRecognizer * tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    [self.view addGestureRecognizer:tapGesture1];
}
- (IBAction)backAction:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)LoginAction:(id)sender {
    [self.passWord resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
    if (([self.phoneNumber.text length] * [self.passWord.text length] == 0) || self.passWord.text.length<6) {
        ALERT(@"请填写完整");
    }
    else if (![Regular checkTel:self.phoneNumber.text]) {
        ALERT(@"手机号码不正确");
    }
    else {
        [self.view makeToastActivity];        NSDictionary * paramDic=@{@"Q_phone_S_EQ": self.phoneNumber.text,@"Q_password_S_EQ": self.passWord.text,@"Q_equipment_S_EQ": @"ios"};
        [HBHTTPService requestPostMethod:@"ImplUserInfogetUserByName.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
            AppDelegate * app=APP;
            if (service.status==1) {
                [app updateUserInfo:service.dataDic];
                [app.window makeToast:@"登录成功!"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                ALERT(@"登录失败!");
            }
            [self.view hideToastActivity];
        }andServiceFailBlock:^(void){
            ALERT(@"登录失败");
            [self.view hideToastActivity];
        }];
    }
}
-(void)dismissKeyBoard
{
    [self.phoneNumber resignFirstResponder];
    [self.passWord resignFirstResponder];
}

-(void)loginFinishAction
{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
//    HBHomeViewController *home=[self.storyboard instantiateViewControllerWithIdentifier:@"HBHomeViewController"];
//    [self.navigationController pushViewController:home animated:YES];
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
