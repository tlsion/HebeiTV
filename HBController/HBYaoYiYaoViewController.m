//
//  HBYaoYiYaoViewController.m
//  HebeiTV
//
//  Created by Pro on 5/21/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "HBYaoYiYaoViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import "HBAlertView.h"
#import "UIView+Action.h"
//#import "UIResponder+MotionRecognizers.h"
@interface HBYaoYiYaoViewController ()
{
    SystemSoundID  startSoundID;
    SystemSoundID  endSoundID;
    
    BOOL isShaking;
    
    
}
@property (strong, nonatomic) IBOutlet UIImageView *shakeBgView;
@end

@implementation HBYaoYiYaoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [[UIApplication sharedApplication]
     setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication]
     setApplicationSupportsShakeToEdit:NO];
    [self resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a
    
    //添加两个摇晃声音
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"shake1" ofType:@"mp3"];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path1], &startSoundID);
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"shake2" ofType:@"mp3"];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path2], &endSoundID);
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)warningAction:(id)sender {
    
    UIAlertView * av =[[UIAlertView alloc]initWithTitle:nil message:@"奖品：由该程序“多多乐”的广告商家提供赞助礼品（食品、生活用品、数码产品等）\n摇一摇规则说明：参加者使用该应用程序进行摇手机，抽取程序内有效的虚拟积分：多多豆。\n\r重要声明：1、本次的抽奖活动由河北电视台公共新闻频道发起，奖品由该应用程序上的投放的广告商家提供。\n2、此次抽奖活动的中奖信息以该应用程序“多多乐”实时公布为准，其他途径公布的消息无效；解释权及规则归河北电视台公共新闻频道所有。\n3、本次抽奖活动及奖品提供与苹果公司无关，苹果不是发起者，也没有以任何方式参与活动。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [av show];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}
-(void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
}
-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
}
- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event {
	if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
		[self motionWasRecognized];
	}
}

-(void)shakeEndRecognized{
    AudioServicesPlaySystemSound (endSoundID);
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}
- (void) motionWasRecognized{
    //AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    if (!isShaking) {
        isShaking=YES;
        AudioServicesPlaySystemSound (startSoundID);
        
        [self.view makeToastActivity];
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(getYaoYiYaoData) userInfo:nil repeats:NO];
        
    }
//    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(shakeEndRecognized) userInfo:nil repeats:NO];
}
#pragma mark -- httpService
-(void)getYaoYiYaoData{
    NSDictionary * paramDic=@{@"userId": [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]};
    [HBHTTPService requestGetMethod:@"ImplShakegetAward.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
        if (service.status==1) {
            int beansCount=[[[service.allDataDic objectForKey:@"dataList"] objectForKey:@"beans"] intValue];
            HBAlertView * av=[[HBAlertView alloc]initWithDuoDuoDouCount:beansCount leftButtonTitle:nil rightButtonTitle:@"确定"];
            [av show];
            av.dismissBlock=^(void){
                isShaking=NO;
            };
            AppDelegate * app=APP;
            [app getUserInfogetBean];
        }
        else if (service.status==2) {
            HBAlertView * av=[[HBAlertView alloc]initWithTitle:@"提示" contentText:@"加油! 再接再厉哦!" leftButtonTitle:nil rightButtonTitle:@"确定"];
            [av show];
            av.dismissBlock=^(void){
                isShaking=NO;
            };
        }
        else if (service.status==-1) {
            HBAlertView * av=[[HBAlertView alloc]initWithTitle:@"提示" contentText:@"活动还没有开始哦!\r\n请密切关注电视节目或短信通知" leftButtonTitle:nil rightButtonTitle:@"确认"];
            [av show];
            av.dismissBlock=^(void){
                isShaking=NO;
            };
        }else{
            isShaking=NO;
        }
        [self.view hideToastActivity];
        
        [self shakeEndRecognized];
    }andServiceFailBlock:^(void){
        [self.view hideToastActivity];
        isShaking=NO;
        [self shakeEndRecognized];
    }];
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
