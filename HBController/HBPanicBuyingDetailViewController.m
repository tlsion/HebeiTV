//
//  HBPanicBuyingDetailViewController.m
//  HebeiTV
//
//  Created by Pro on 6/4/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "HBPanicBuyingDetailViewController.h"
#import "EGOImageView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import "HBAlertView.h"
#import "UIView+Action.h"
#import "BCActionSheet.h"
#import "UMSocial.h"
@interface HBPanicBuyingDetailViewController ()<UIActionSheetDelegate,UMSocialUIDelegate>
{
    
    IBOutlet UIScrollView *mainScrollView;
    IBOutlet EGOImageView *mainImageView;
    IBOutlet UILabel *mainNameLabel;
    
    IBOutlet UILabel *needBeansLabel;
    
    IBOutlet UILabel *panicPriceLabel;
    
    IBOutlet UILabel *orgainPriceLabel;
    
    IBOutlet UILabel *myBeansLabel;
    
    IBOutlet UILabel *ticketTimeLabel;
    
    IBOutlet UILabel *ticketAddressLabel;
    
    IBOutlet UILabel *ContactPhoneNumberLabel;
    
    IBOutlet UIView *lastBgView;
    IBOutlet UITextView *contentTextView;
    
    IBOutlet UIView *htmlShowBgView;
    
    NSDictionary * panicBuyingDataInfo;
    
    SystemSoundID  startSoundID;
    SystemSoundID  endSoundID;
    
    BOOL isShaking;
    
    BCActionSheet *myActionSheet;
}
@end

@implementation HBPanicBuyingDetailViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataBeansCount) name:@"UPDATA_NEW_BEANS" object:nil];

}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication]
     setApplicationSupportsShakeToEdit:NO];
    [self resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UPDATA_NEW_BEANS" object:nil];

}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //添加两个摇晃声音
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"shake1" ofType:@"mp3"];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path1], &startSoundID);
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"shake2" ofType:@"mp3"];
	AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path2], &endSoundID);
    
    
    mainScrollView.frame=CGRectMake(0, NAV_HEI_64, SCREEN_MAX_WIDTH, SCREEN_MAX_HEIGHT-NAV_HEI_64);
//    mainScrollView.backgroundColor=[UIColor blueColor];
//    mainScrollView.contentSize=CGSizeMake(SCREEN_MAX_WIDTH, 836);
    
    [self addShareFunction];
    
    [self updataBeansCount];
    
    
    [self getPanicBuyingDetailData];
}
-(void)updataBeansCount{
    NSInteger beansCount=[[[NSUserDefaults standardUserDefaults] objectForKey:@"beanscount"] integerValue];
    myBeansLabel.text=[NSString stringWithFormat:@"%d",beansCount];
}
-(void)updatePanicBuyingContentDic:(NSDictionary *)dic{
    mainNameLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"activityName"]];
    ticketTimeLabel.text=[NSString stringWithFormat:@"%@ 一 %@",[dic objectForKey:@"beginTime"],[dic objectForKey:@"endTime"]];
    mainNameLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"activityName"]];
    needBeansLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"minus"]];
    panicPriceLabel.text=[NSString stringWithFormat:@"抢购价￥%.2f",[[dic objectForKey:@"price"] floatValue]];
    orgainPriceLabel.text=[NSString stringWithFormat:@"原价￥%.2f",[[dic objectForKey:@"costPrice"] floatValue]];
    mainImageView.imageURL=IMG_URL([dic objectForKey:@"image"]);
    
    NSString * htmlString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
    
    if (SystemVersion<7) {
        NSRange range;
        while ((range = [htmlString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
            htmlString=[htmlString stringByReplacingCharactersInRange:range withString:@""];
        }
        contentTextView.text=htmlString;
    }
    else{
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        contentTextView.attributedText = attributedString;

    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setHtmlTextViewContentSize) userInfo:nil repeats:NO];
    
    
}
-(void)setHtmlTextViewContentSize{
    
    CGRect nFrame=contentTextView.frame;
    nFrame.size.height=contentTextView.contentSize.height;
    contentTextView.frame=nFrame;
    
    CGRect htmlBgFrame=htmlShowBgView.frame;
    htmlBgFrame.origin.y=CGRectGetMaxY(lastBgView.frame)+8;
    htmlBgFrame.size.height=nFrame.size.height+50;
    htmlShowBgView.frame=htmlBgFrame;
    
    mainScrollView.contentSize=CGSizeMake(SCREEN_MAX_WIDTH, CGRectGetMaxY(htmlShowBgView.frame)+8);
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 分享
-(void)addShareFunction{
    NSArray *NameArr=[[NSArray alloc]initWithObjects:@"新浪微博",@"腾讯微博",@"微信",@"微信朋友圈",@"QQ空间",@"QQ",@"人人网",@"豆瓣", nil];
    NSArray *imageArr=[[NSArray alloc]initWithObjects:@"umeng_socialize_sina_on",@"umeng_socialize_tx_on",@"umeng_socialize_wechat",@"umeng_socialize_wxcircle",@"umeng_socialize_qzone_on",@"umeng_socialize_qq_on",@"umeng_socialize_renren_on",@"umeng_socialize_douban_on", nil];
    
    UIView *shareView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 160)];
    shareView.userInteractionEnabled=YES;
    shareView.backgroundColor=GRAY;
    for (int i=0; i<2; i++) {
        for (int j=0; j<4; j++) {
            if (4*i+j<imageArr.count) {
                UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                shareBtn.tag=4*i+j;
                [shareBtn addTarget:self action:@selector(selectShareAction:) forControlEvents:UIControlEventTouchUpInside];
                shareBtn.frame=CGRectMake(0+80*j, 0+80*i, 78, 78);
                shareBtn.backgroundColor=[UIColor whiteColor];
                UIImage *btnImg=[UIImage imageNamed:[imageArr objectAtIndex:4*i+j]];
                NSString *tittle=[NameArr objectAtIndex:4*i+j];
                [shareBtn setTitle:tittle forState:UIControlStateNormal];
                [shareBtn setImage:btnImg forState:UIControlStateNormal];
                [shareBtn setTitleColor:YAHEI forState:UIControlStateNormal];
                shareBtn.titleLabel.font=FONT_BIG;
                shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 20, 20);
                shareBtn.titleEdgeInsets = UIEdgeInsetsMake(30, -38, 0, 0);
                
                [shareView addSubview:shareBtn];
            }
        }
    }
    
    myActionSheet = [[BCActionSheet alloc] initWithViewHeight:160 andIsShowNavigationBar:YES];
    myActionSheet.delegate = self;
    [myActionSheet.customView addSubview:shareView];
}
- (IBAction)shareAction:(UIButton *)sender {
    
    [myActionSheet showInView:self.view];
}
-(void)selectShareAction:(UIButton *)sender
{
    [myActionSheet docancel];
    
    NSArray *snsNameArr=[[NSArray alloc]initWithObjects:@"sina",@"tencent",@"wxsession",@"wxtimeline",@"qzone",@"qq",@"renren",@"douban", nil];
    
    NSString *snsName = [snsNameArr objectAtIndex:sender.tag];
    
    NSString *shareText=[NSString stringWithFormat:@"河北公告频道多多乐"];
    
    UIImage *shareImage = [UIImage imageNamed:@"HebeiLog.png"];
    
    //设置分享内容，和回调对象
    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:self];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
    snsPlatform.snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
}
//下面设置点击分享列表之后，可以直接分享
-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if (response.responseCode == UMSResponseCodeSuccess) {
        //得到分享到的微博平台名
        ALERT(@"分享成功!");
        
    }else if(response.responseCode != UMSResponseCodeCancel) {
        if (response.responseCode == UMSResponseCodeSuccess) {
             ALERT(@"分享失败!");
            
        }
    }
}

#pragma end mark
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
        
        NSInteger beansCount=[[[NSUserDefaults standardUserDefaults] objectForKey:@"beanscount"] integerValue];
        NSInteger needBeansCount=[[panicBuyingDataInfo objectForKey:@"minus"] integerValue];
        if (beansCount>=needBeansCount) {
            
            isShaking=YES;
            AudioServicesPlaySystemSound (startSoundID);
            [self.view makeToastActivity];
            [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(getPanicBuyingData) userInfo:nil repeats:NO];
        }
        else{
            HBAlertView * av=[[HBAlertView alloc]initWithDuoDuoDouPrompt:@"多多豆不足" contentText:@"很遗憾，您的多多豆不足无法参加\r想办法获取更多的多多豆吧!" leftButtonTitle:nil rightButtonTitle:@"确定"];
            [av show];
        }
        
    }
    //    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(shakeEndRecognized) userInfo:nil repeats:NO];
}
#pragma mark -- httpService
-(void)getPanicBuyingDetailData{
    [self.view makeToastActivity];
    NSDictionary * paramDic=@{@"activityId":self.activityId};
    [HBHTTPService requestGetMethod:@"ImplActivityget.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
        if (service.status==1) {
            panicBuyingDataInfo=service.dataDic;
            [self updatePanicBuyingContentDic:service.dataDic];
        }
        [self.view hideToastActivity];
    }andServiceFailBlock:^(void){
        [self.view hideToastActivity];
    }];
}
-(void)getPanicBuyingData{
    NSDictionary * paramDic=@{@"userId": [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"activityId":self.activityId};
    [HBHTTPService requestGetMethod:@"ImplActivitygetAward.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
        
        AppDelegate * app=APP;
        [app getUserInfogetBean];
        if (service.status==1) {
            if (_delegate) {
                [_delegate updatePanicBuyingGoodsIndex:0];
            }
            NSString * imageURL=[NSString stringWithFormat:@"%@",[panicBuyingDataInfo objectForKey:@"image"]];
            HBAlertView * av=[[HBAlertView alloc]initWithImageURL:IMG_URL(imageURL) titleText:[NSString stringWithFormat:@"%@",[panicBuyingDataInfo objectForKey:@"activityName"]] contentText:@"太幸运啦，恭喜您获得抢购机会!\r请到【兑奖】中查收凭证码及相关信息" leftButtonTitle:nil rightButtonTitle:@"确定"];
            [av show];
            av.dismissBlock=^(void){
                isShaking=NO;
            };
        }else if (service.status==2) {
            HBAlertView * av=[[HBAlertView alloc]initWithDuoDuoDouPrompt:[NSString stringWithFormat:@"多多豆 -%@",[panicBuyingDataInfo objectForKey:@"minus"]] contentText:@"很遗憾，您没有获得抢购机会\r下次再接再厉哦!" leftButtonTitle:nil rightButtonTitle:@"确定"];
            [av show];
            av.dismissBlock=^(void){
                isShaking=NO;
            };
        }else if (service.status==3) {
            HBAlertView * av=[[HBAlertView alloc]initWithMessage:@"活动抢购结束!"];
            [av show];
            av.dismissBlock=^(void){
                isShaking=NO;
            };
        }else if (service.status==-1) {
            HBAlertView * av=[[HBAlertView alloc]initWithTitle:@"提示" contentText:@"活动还没有开始哦!" leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
            [av show];
            av.dismissBlock=^(void){
                isShaking=NO;
            };
        }
        else{
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
