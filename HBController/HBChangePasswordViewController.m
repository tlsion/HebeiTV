//
//  HBChangePasswordViewController.m
//  HebeiTV
//
//  Created by Pro on 6/6/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "HBChangePasswordViewController.h"
#import "HBCustomerTextField.h"
#import "HBAlertView.h"
#import "UIView+Action.h"
@interface HBChangePasswordViewController ()<UITextFieldDelegate>{
    
    IBOutlet UIScrollView *mainScrollView;
    
    IBOutlet HBCustomerTextField *passwordTxt1;
    
    IBOutlet HBCustomerTextField *passwordTxt2;
    
    IBOutlet HBCustomerTextField *passwordTxt3;
}

@end

@implementation HBChangePasswordViewController

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
    [passwordTxt1 setTextTitle:@"旧密码"];
    [passwordTxt2 setTextTitle:@"新密码"];
    [passwordTxt3 setTextTitle:@"再次输入新密码"];
    
    //手势回收键盘
    UITapGestureRecognizer * tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    [mainScrollView addGestureRecognizer:tapGesture1];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    int flag1=setY(textField)+NAV_HEI_64;
    int flag2=SCREEN_MAX_HEIGHT-216;
    int flag3=flag1-flag2+44;
    mainScrollView.contentSize=CGSizeMake(SCREEN_MAX_WIDTH, mainScrollView.bounds.size.height +40);
    if (flag1>flag2) {
        
        [mainScrollView setContentOffset:CGPointMake(0, flag3) animated:YES];
    }
}
- (IBAction)comfireChangePasswordAction:(id)sender {
    [self dismissKeyBoard];
    NSString * originalPassword=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"password"]];
    if (![passwordTxt1.text isEqualToString:originalPassword]) {
        HBAlertView * av=[[HBAlertView alloc]initWithMessage:@"旧密码输入错误"];
        [av show];
    }
    else if(passwordTxt3.text.length<6 || passwordTxt3.text.length>20 || passwordTxt2.text.length<6 || passwordTxt2.text.length>20){
        HBAlertView * av=[[HBAlertView alloc]initWithMessage:@"请输入6-20位密码"];
        [av show];
    }
    else if(![passwordTxt2.text isEqualToString:passwordTxt3.text]){
        HBAlertView * av=[[HBAlertView alloc]initWithMessage:@"新密码不一致"];
        [av show];
    }
    else{
        [self.view makeToastActivity];
        NSString * phoneNumber=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"]];
        NSDictionary * paramDic=@{@"phone":phoneNumber,@"password":passwordTxt2.text,@"equipment":@"ios"};
        [HBHTTPService requestGetMethod:@"ImplUserInfofindPassword.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
            
            AppDelegate * app=APP;
            if (service.status==1) {
                [app.window makeToast:@"修改成功!"];
                [[NSUserDefaults standardUserDefaults] setObject:passwordTxt2.text forKey:@"password"];
                [[NSUserDefaults standardUserDefaults] synchronize];
//                [app updateUserInfo:[service.allDataDic objectForKey:@"dataList"]];
//                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                HBAlertView * av=[[HBAlertView alloc]initWithMessage:@"修改失败!"];
                [av show];
            }
            [self.view hideToastActivity];
        }andServiceFailBlock:^(void){
            [self.view hideToastActivity];
            HBAlertView * av=[[HBAlertView alloc]initWithMessage:@"请求失败!"];
            [av show];
        }];
    }
}
-(void)keyboardWillBeHidden:(id)sender{
    mainScrollView.contentSize=CGSizeMake(SCREEN_MAX_WIDTH, mainScrollView.bounds.size.height);
    [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}
-(void)dismissKeyBoard{
    [passwordTxt1 resignFirstResponder];
    [passwordTxt2 resignFirstResponder];
    [passwordTxt3 resignFirstResponder];
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
