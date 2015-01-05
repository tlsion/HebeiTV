//
//  HBRegisterViewController.m
//  HebeiTV
//
//  Created by Pro on 5/19/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "HBRegisterViewController.h"
#import "HBCustomerTextField.h"
#import "Regular.h"
#import "HBAuthcodeViewController.h"
#import "UIView+Action.h"
@interface HBRegisterViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet HBCustomerTextField *accountNumberTxt;
@property (strong, nonatomic) IBOutlet HBCustomerTextField *passwordTxt1;
@property (strong, nonatomic) IBOutlet HBCustomerTextField *passwordTxt2;
@end

@implementation HBRegisterViewController

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
    [self.accountNumberTxt setTextTitle:@"账号"];
    [self.passwordTxt1 setTextTitle:@"密码"];
    [self.passwordTxt2 setTextTitle:@"再次输入密码"];
    
//    self.accountNumberTxt.text=@"18950124642";
//    self.passwordTxt1.text=@"123456";
//    self.passwordTxt2.text=@"123456";
    
    //手势回收键盘
    UITapGestureRecognizer * tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    [self.view addGestureRecognizer:tapGesture1];
    
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self GetInfovalidationAction:nil];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)GetInfovalidationAction:(id)sender {
    [self dismissKeyBoard];
    if (![Regular checkTel:self.accountNumberTxt.text]) {
        ALERT(@"手机号码不正确");
    }
    else if(self.passwordTxt1.text.length<6 || self.passwordTxt1.text.length>20 || self.passwordTxt2.text.length<6 || self.passwordTxt2.text.length>20){
        ALERT(@"请输入6-20位密码");
    }
    else if(![self.passwordTxt1.text isEqualToString:self.passwordTxt2.text]){
        ALERT(@"两次密码输入不一致");
    }
    else{
        [self GetInfovalidation];
    }
}
-(void)GetInfovalidation{
    [self.view makeToastActivity];
    NSDictionary * paramDic=@{@"phone":self.accountNumberTxt.text};
    [HBHTTPService requestPostMethod:@"ImplUserInfovalidation.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
        if (service.status==1) {
            
            AppDelegate * app=APP;
            [app.window makeToast:[NSString stringWithFormat:@"获取验证码成功!"]];
            NSString *number=[NSString stringWithFormat:@"%@",[service.dataDic valueForKey:@"number"]];
            HBAuthcodeViewController *authcode=[self.storyboard instantiateViewControllerWithIdentifier:@"HBAuthcodeViewController"];
            authcode.password=self.passwordTxt1.text;
            authcode.number=number;
            authcode.phone=self.accountNumberTxt.text;
            [self.navigationController pushViewController:authcode animated:YES];
            
        }
       else  {
           ALERT(service.msg);
        }
        [self.view hideToastActivity];
    }andServiceFailBlock:^(void){
         ALERT(@"获取验证码失败,请重试");
        [self.view hideToastActivity];
    }];
}
-(void)dismissKeyBoard
{
    [self.accountNumberTxt resignFirstResponder];
    [self.passwordTxt1 resignFirstResponder];
    [self.passwordTxt2 resignFirstResponder];
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
