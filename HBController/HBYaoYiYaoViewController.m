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
    
    self.shakeBgView.frame=CGRectMake(0, NAV_HEI_64, SCREEN_MAX_WIDTH, SCREEN_MAX_HEIGHT-NAV_HEI_64);
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
