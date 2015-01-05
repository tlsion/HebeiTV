//
//  HBAuthcodeViewController.m
//  HebeiTV
//
//  Created by 智美合 on 14-5-19.
//  Copyright (c) 2014年 MyOrganization. All rights reserved.
//
#import "HBCustomerTextField.h"
#import "HBAuthcodeViewController.h"
#import "HBRegisterFinishViewController.h"
@interface HBAuthcodeViewController ()
{
    int secondsCountDown;
    NSTimer *coutDownTimer;
}
@property (strong, nonatomic) IBOutlet UIButton *getAgainBtn;
@property (strong, nonatomic) IBOutlet UIView *bgView;


@end

@implementation HBAuthcodeViewController

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
    [self.Authcode setTextTitle:@"验证码"];
    [self.Authcode becomeFirstResponder];
//    [_getAgainBtn addTarget:self action:@selector(toObtain) forControlEvents:UIControlEventTouchUpInside];
    coutDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    secondsCountDown = TIMER;
    
    //手势回收键盘
    UITapGestureRecognizer * tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    [self.view addGestureRecognizer:tapGesture1];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addUserAction:(id)sender {
    if ([self.Authcode.text isEqualToString:_number]) {
        HBRegisterFinishViewController *finished=[self.storyboard instantiateViewControllerWithIdentifier:@"HBRegisterFinishViewController"];
        finished.phone=_phone;
        finished.passWord=_password;
        [self.navigationController pushViewController:finished animated:YES];
    }
    else
    {
        ALERT(@"你输入的验证码错误");
    }
}

//重新获取验证码
- (IBAction)toObtain:(id)sender {
    _bgView.userInteractionEnabled=NO;
    secondsCountDown = TIMER;
    coutDownTimer=nil;
    [coutDownTimer invalidate];

    coutDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    
    NSDictionary * paramDic=@{@"phone":_phone};
    [HBHTTPService requestPostMethod:@"ImplUserInfovalidation.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
        if (service.status==1) {
             _number=[NSString stringWithFormat:@"%@",[service.dataDic valueForKey:@"number"]];
            
            ALERT(@"重新获取验证码成功");
            _bgView.userInteractionEnabled=NO;
            secondsCountDown = TIMER;
            
        }
        else
        {
            ALERT(service.msg);
            _bgView.userInteractionEnabled=YES;
            [coutDownTimer invalidate];
            [_getAgainBtn setTitle:@"重发" forState:UIControlStateNormal];
        }
    }andServiceFailBlock:^(void){
    }];
    
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

-(void)dismissKeyBoard
{
    [self.Authcode resignFirstResponder];
}/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
