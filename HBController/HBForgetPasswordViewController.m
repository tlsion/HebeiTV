//
//  HBForgetPasswordViewController.m
//  HebeiTV
//
//  Created by Pro on 5/29/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "HBForgetPasswordViewController.h"
#import "HBCustomerTextField.h"
#import "Regular.h"
#import "UIView+Action.h"
#import "HBSettingViewController.h"
@interface HBForgetPasswordViewController ()<UITextFieldDelegate>
{
    NSTimer * coutDownTimer;
    int secondsCountDown;
    NSString * _number;//验证码
    IBOutlet UIScrollView *mainScrollView;
    
    NSString * phoneNumber;
}
@property (strong, nonatomic) IBOutlet HBCustomerTextField *phoneNumberTxt;
@property (strong, nonatomic) IBOutlet HBCustomerTextField * Authcode;
@property (strong, nonatomic) IBOutlet HBCustomerTextField *passwordTxt1;
@property (strong, nonatomic) IBOutlet HBCustomerTextField *passwordTxt2;
@property (strong, nonatomic) IBOutlet UIButton *getAgainBtn;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@end

@implementation HBForgetPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    //键盘将要消失时的触发事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    mainScrollView.frame=CGRectMake(0, 0, SCREEN_MAX_WIDTH, self.view.frame.size.height);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.Authcode setTextTitle:@"验证码"];
    [self.phoneNumberTxt setTextTitle:@"手机号码"];
    [self.passwordTxt1 setTextTitle:@"新密码"];
    [self.passwordTxt2 setTextTitle:@"再次输入密码"];
//    [mainScrollView setContentSize:CGSizeMake(SCREEN_MAX_WIDTH, CGRectGetMaxY(self.passwordTxt2.frame)+80)];
    //    [_getAgainBtn addTarget:self action:@selector(toObtain) forControlEvents:UIControlEventTouchUpInside];
    
    //手势回收键盘
    UITapGestureRecognizer * tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    [mainScrollView addGestureRecognizer:tapGesture1];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addUserAction:(id)sender {
    [self dismissKeyBoard];
    if (![self.Authcode.text isEqualToString:_number]) {
        ALERT(@"你输入的验证码错误");
    }
    else if(self.passwordTxt1.text.length<6 || self.passwordTxt1.text.length>20 || self.passwordTxt2.text.length<6 || self.passwordTxt2.text.length>20){
        ALERT(@"请输入6-20位密码");
    }
    else if (![self.passwordTxt1.text isEqualToString:self.passwordTxt2.text]) {
        ALERT(@"两次密码不一致");
    }
    else
    {
        [self.view makeToastActivity];
        NSDictionary * paramDic=@{@"phone":phoneNumber,@"password":self.passwordTxt1.text,@"equipment":@"ios"};
        [HBHTTPService requestGetMethod:@"ImplUserInfofindPassword.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
            
            AppDelegate * app=APP;
            if (service.status==1) {
                [app.window makeToast:@"修改成功!"];
                [app updateUserInfo:[service.allDataDic objectForKey:@"dataList"]];
                for (UIViewController * viewController in self.navigationController.viewControllers) {
                    if ([viewController isKindOfClass:[HBSettingViewController class]]) {
                        [self.navigationController popToViewController:viewController animated:YES];
                    }
                }
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                
                ALERT(@"修改失败!");
            }
            [self.view hideToastActivity];
        }andServiceFailBlock:^(void){
            [self.view hideToastActivity];
            [self.view makeToast:@"请求失败!"];
        }];
    }
}

//重新获取验证码
- (IBAction)toObtain:(id)sender {
    [self dismissKeyBoard];
    if (![Regular checkTel:self.phoneNumberTxt.text]) {
        ALERT(@"手机号码不正确");
    }
    else{
        [self.view makeToastActivity];
        phoneNumber=self.phoneNumberTxt.text;
        NSDictionary * paramDic=@{@"phone":phoneNumber};
        [HBHTTPService requestPostMethod:@"ImplUserInfovalidation2.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
            if (service.status==1) {
                _number=[NSString stringWithFormat:@"%@",[service.dataDic valueForKey:@"number"]];
                
                [self.view makeToast:@"获取验证码成功!"];
                [self setAuthcodeCountTimer];
            }
            else
            {
                ALERT(service.msg);
                _bgView.userInteractionEnabled=YES;
                [coutDownTimer invalidate];
                [_getAgainBtn setTitle:@"重发" forState:UIControlStateNormal];
            }
            [self.view hideToastActivity];
        }andServiceFailBlock:^(void){
            [self.view hideToastActivity];
            [self.view makeToast:@"请求失败!"];
        }];
    }
    
}
-(void)setAuthcodeCountTimer{
    _bgView.userInteractionEnabled=NO;
    if (coutDownTimer) {
        coutDownTimer=nil;
        [coutDownTimer invalidate];
    }
    secondsCountDown = TIMER;
    coutDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}
// 重新获取验证码 定时器的方法
-(void)timeFireMethod{
    secondsCountDown--;
    if(secondsCountDown==0){
        [_getAgainBtn setTitle:@"重发" forState:UIControlStateNormal];
        [coutDownTimer invalidate];
        _bgView.userInteractionEnabled=YES;
    }
    else
    {
        [_getAgainBtn setTitle:[NSString stringWithFormat:@"重发(%d秒)",secondsCountDown] forState:UIControlStateNormal];
        _bgView.userInteractionEnabled=NO;
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    int flag1=setY(textField)+NAV_HEI_64;
    int flag2=SCREEN_MAX_HEIGHT-216;
    int flag3=flag1-flag2+44;
    mainScrollView.contentSize=CGSizeMake(SCREEN_MAX_WIDTH, mainScrollView.bounds.size.height +216);
    if (flag1>flag2) {
        
        [mainScrollView setContentOffset:CGPointMake(0, flag3) animated:YES];
    }
}
-(void)keyboardWillBeHidden:(id)sender{
    mainScrollView.contentSize=CGSizeMake(SCREEN_MAX_WIDTH, mainScrollView.bounds.size.height);
    [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}
-(void)dismissKeyBoard{
    [self.phoneNumberTxt resignFirstResponder];
    [self.Authcode resignFirstResponder];
    [self.passwordTxt1 resignFirstResponder];
    [self.passwordTxt2 resignFirstResponder];
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
