//
//  HBCardAnimationShowViewController.m
//  HebeiTV
//
//  Created by Pro on 5/21/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "HBCardAnimationShowViewController.h"
#import "iCarousel.h"
#import "SJAvatarBrowser.h"
#define ITEM_SPACING 200
#import "UIView+Action.h"
#import "HYScratchCardView.h"
#import <AudioToolbox/AudioToolbox.h>
#define ChangeBeforeFont FONTBOLD(14)

static CGRect dallFrame;

//#import "STScratchView.h"
@interface HBCardAnimationShowViewController ()<iCarouselDataSource,iCarouselDelegate,STScratchViewDelegate>
{
    BOOL isPrize;
    SJAvatarBrowser * browser;
    
    UIView * cardBgView;
    CGRect oldframe;
}
@property (strong, nonatomic) IBOutlet iCarousel *carousel;
@property (strong, nonatomic) IBOutlet UIView *promptView;

@property (strong, nonatomic) IBOutlet UILabel *duoduoCountLabel;
@property (strong, nonatomic) IBOutlet UIView *titlePromptView;
@property (nonatomic,assign) BOOL wrap;
@property (strong, nonatomic) IBOutlet UILabel *needBeansCountLabel;


@end

@implementation HBCardAnimationShowViewController
@synthesize carousel;
@synthesize wrap;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        wrap = YES;
    }
    
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    carousel.hidden=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataBeansCount) name:@"UPDATA_NEW_BEANS" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    carousel.hidden=YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UPDATA_NEW_BEANS" object:nil];
}

-(void)loadView{
    [super loadView];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"大背景图.png"]];
    
    _promptView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"消费提示"]];
    _titlePromptView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"多多豆显示"]];
    _titlePromptView.frame=CGRectMake(7, 20, 306, 25);
//    CGRect newFrame=_promptView.frame;
//    newFrame.origin.y=SCREEN_MAX_HEIGHT-320;
//    _promptView.frame=newFrame;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSInteger beansCount=[[[NSUserDefaults standardUserDefaults] objectForKey:@"beanscount"] integerValue];
    self.duoduoCountLabel.text=[NSString stringWithFormat:@"%d",beansCount];
    NSString * needCountStr=[NSString stringWithFormat:@"%@",[self.cardInfoDic objectForKey:@"minus"]];
    if (needCountStr && ![needCountStr isEqualToString:@"(null)"]) {
        self.needBeansCountLabel.text=needCountStr;
    }
    carousel.type = iCarouselTypeCoverFlow;
    [self getScrathCardProbability];
    
    cardBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    cardBgView.backgroundColor=[UIColor blackColor];
    cardBgView.hidden=YES;
    [self.view addSubview:cardBgView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [cardBgView addGestureRecognizer: tap];
    
    
}
-(void)updataBeansCount{
    NSInteger beansCount=[[[NSUserDefaults standardUserDefaults] objectForKey:@"beanscount"] integerValue];
    _duoduoCountLabel.text=[NSString stringWithFormat:@"%d",beansCount];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
//
//- (IBAction)switchCarouselType
//{
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择类型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"直线", @"圆圈", @"反向圆圈", @"圆桶", @"反向圆桶", @"封面展示", @"封面展示2", @"纸牌", nil];
//    [sheet showInView:self.view];
//    [sheet release];
//}
//
//- (IBAction)toggleWrap
//{
//    wrap = !wrap;
//    navItem.rightBarButtonItem.title = wrap? @"边界:ON": @"边界:OFF";
//    [carousel reloadData];
//}

//#pragma mark -
//
//- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    for (UIView *view in carousel.visibleItemViews)
//    {
//        view.alpha = 1.0;
//    }
//    
//    [UIView beginAnimations:nil context:nil];
//    carousel.type = buttonIndex;
//    [UIView commitAnimations];
//    
//    navItem.title = [actionSheet buttonTitleAtIndex:buttonIndex];
//}

#pragma mark -

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 30;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    UIImage *balloon = [UIImage imageNamed:@"刮刮卡.png"];

    UIView *view = [[UIImageView alloc] initWithImage:balloon];
    view.userInteractionEnabled=YES;
    view.frame = CGRectMake(70, 80, 180, 260);
    dallFrame=CGRectMake(10, view.frame.size.height-40, view.frame.size.width-20, 30);
//    UILabel * _prizeNameLabel=[[UILabel alloc]initWithFrame:dallFrame];
//    _prizeNameLabel.textAlignment=NSTextAlignmentCenter;
//    _prizeNameLabel.textColor=YAHEI;
//    _prizeNameLabel.font=ChangeBeforeFont;
//    //        if (prizeName) {
//    //            [_prizeNameLabel setText:prizeName];
//    //        }else{
//    [_prizeNameLabel setText:@"谢谢参与"];
//    //        }
//    [view addSubview:_prizeNameLabel];
    
//    STScratchView * _scratchView=[[STScratchView alloc]initWithFrame:dallFrame];
//    //        _scratchView.delegate = delegate;
//    [_scratchView setSizeBrush:50.0];
//    [view addSubview:_scratchView];
    // Create a (child) UIView
    //        UIImageView *ball = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(_scratchView.frame), CGRectGetHeight(_scratchView.frame))];
    //        [ball setImage:[UIImage imageNamed:@"灰条(带字).png"]];
    UILabel * ball=[[UILabel alloc]initWithFrame:dallFrame];
    ball.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"灰条"]];
    ball.text=@"刮开有奖";
    ball.font=ChangeBeforeFont;
    ball.textColor=YAHEI;
    ball.textAlignment=NSTextAlignmentCenter;
    
    [view addSubview:ball];
    
//    UIImage * grayImage=[UIImage imageNamed:@"灰条.png"];
//    UIView * grayView= [[UIImageView alloc] initWithImage:grayImage];
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showCardRecognizer:)];
    [view addGestureRecognizer:tap];
//    grayView.frame=CGRectMake(10, 180, 109, 27);
//    UILabel * promptLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 220, 160, 32)];
//    promptLab.textAlignment=NSTextAlignmentCenter;
//    promptLab.font=FONTBOLD(17);
//    promptLab.textColor=YAHEI;
//    promptLab.text=@"刮开有奖";
//    promptLab.backgroundColor=[UIColor colorWithPatternImage:grayImage];
//    [view addSubview:promptLab];
//    [[ view layer] setBackgroundColor:[[UIColor blackColor] CGColor]];
//
//    
//    //图片层
//    
//    CALayer *topLayer = [[CALayer alloc] init];
//    
//    [topLayer setBounds:CGRectMake(0.0f, 0.0f, 320-100.0, 240-100)];
//    
//    [topLayer setPosition:CGPointMake(160.0f, 120.0f)];
//    
//    [topLayer setContents:(id)[balloon CGImage]];
//    
//    [[view layer] addSublayer:topLayer];
//    
//    //图片阴影层
//    
//    CALayer *reflectionLayer = [[CALayer alloc] init];
//    
//    [reflectionLayer setBounds:CGRectMake(0.0f, 0.0f, 320.0-100, 240.0-100)];
//    
//    [reflectionLayer setPosition:CGPointMake(160.0f, 310.0f-100)];
//    
//    [reflectionLayer setContents:[topLayer contents]];
//    
//    [reflectionLayer setValue:[NSNumber numberWithFloat:180.0] forKeyPath:@"transform.rotation.x"];
//    
//    //渐变层
//    
//    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
//    
//    [gradientLayer setBounds:[reflectionLayer bounds]];
//    
//    [gradientLayer setPosition:CGPointMake([reflectionLayer bounds].size.width/2, [reflectionLayer bounds].size.height/2)];
//    
//    [gradientLayer setColors:[NSArray arrayWithObjects: (id)[[UIColor clearColor] CGColor],(id)[[UIColor blackColor] CGColor], nil]];
//    
//    [gradientLayer setStartPoint:CGPointMake(0.5,0.35)];
//    
//    [gradientLayer setEndPoint:CGPointMake(0.5,1.0)];
//    
//    [reflectionLayer setMask:gradientLayer];
//    
//    [[view layer] addSublayer:reflectionLayer];
    
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return 30;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return ITEM_SPACING;
}
- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return wrap;
}
- (BOOL)carousel:(iCarousel *)_carousel shouldSelectItemAtIndex:(NSInteger)index{
//    [self showImage:_carousel.visibleItemViews[index]];
//    browser=[[SJAvatarBrowser alloc]init];
//    UIImageView * cardView=_carousel.visibleItemViews[index];
//    
//    //    SJAvatarBrowser * browser=[[SJAvatarBrowser alloc]init];
//    NSString * prizeName=nil;
//    if (isPrize) {
//        prizeName=@"恭喜您,中奖了";
//    }else{
//        prizeName=@"谢谢参与";
//    }
//    [browser showImage:cardView andPrizeName:prizeName andDelegate:self];
    return YES;
}
-(void)scratchedTrigger{
    [browser removeAllView];
//    ALERT(@"恭喜您中奖了！");
    
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    if (isPrize) {
        [self getScrathCardScrathgetWin:1];
    }else {
        [self getScrathCardScrathgetWin:2];
    }
}
-(void)showCardRecognizer:(UITapGestureRecognizer *)sender{
//    NSArray * views=carousel.visibleItemViews;
    UIImageView * cardView=(UIImageView *)sender.view;
    
//    SJAvatarBrowser * browser=[[SJAvatarBrowser alloc]init];
    NSString * prizeName=nil;
    if (isPrize) {
        prizeName=@"恭喜您,中奖了";
    }else{
        prizeName=@"谢谢参与";
    }
    [self showImage:cardView prompt:prizeName];
//    browser=[[SJAvatarBrowser alloc]init];
//    [browser showImage:cardView andPrizeName:prizeName andDelegate:self];
}

-(void)getScrathCardProbability{
    [self.view makeToastActivity];
    NSDictionary * paramDic=@{@"probability": [NSString stringWithFormat:@"%@",[_cardInfoDic objectForKey:@"probability"]],@"scratchId":[NSString stringWithFormat:@"%@",[_cardInfoDic objectForKey:@"scratchId"]]};
    [HBHTTPService requestGetMethod:@"ImplScrathgetAward.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
        if (service.status==1) {
            isPrize=YES;
        }else if (service.status==2) {
            isPrize=NO;
        }
        [self.view hideToastActivity];
        
    }andServiceFailBlock:^(void){
        [self.view hideToastActivity];
    }];
}
-(void)getScrathCardScrathgetWin:(int)type{
    [self.view makeToastActivity];
    NSDictionary * paramDic=@{@"userId": [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"scratchId":[_cardInfoDic objectForKey:@"scratchId"],@"type":[NSString stringWithFormat:@"%d",type]};
    [HBHTTPService requestGetMethod:@"ImplScrathgetWin.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
        AppDelegate * app=APP;
        [app getUserInfogetBean];
        if (service.status==1) {
            HBAlertView * winAv=[[HBAlertView alloc]initWithMessage:@"恭喜您中奖了，请前往中奖区领取奖品!"];
            winAv.rightBlock=^{
                [self.navigationController popViewControllerAnimated:YES];
            };
            [winAv show];
        }
        else if (service.status==2){
            HBAlertView * nowinAv=[[HBAlertView alloc]initWithMessage:@"木有中奖噢，再接再厉!"];
            nowinAv.rightBlock=^{
                [self.navigationController popViewControllerAnimated:YES];
            };
            [nowinAv show];
        }else if (service.status==3){
            HBAlertView * nowinAv=[[HBAlertView alloc]initWithMessage:@"谢谢参与，活动已结束!"];
            nowinAv.rightBlock=^{
                [self.navigationController popViewControllerAnimated:YES];
            };
            [nowinAv show];
        }
        else {
            HBAlertView * av=[[HBAlertView alloc]initWithMessage:@"服务器出错"];
            av.rightBlock=^{
                [self.navigationController popViewControllerAnimated:YES];
            };
            [av show];
        }
        [self.view hideToastActivity];
        
    }andServiceFailBlock:^(void){
        HBAlertView * av=[[HBAlertView alloc]initWithMessage:@"服务器出错"];
        av.rightBlock=^{
            [self.navigationController popViewControllerAnimated:YES];
        };
        [av show];
        [self.view hideToastActivity];
    }];
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
////    if ((alertView.tag==100 && buttonIndex==0) || (alertView.tag==101 && buttonIndex==1)) {
////         [self.navigationController popViewControllerAnimated:YES];
////    }
//    [self.navigationController popViewControllerAnimated:YES];
//}
#pragma  markk -- 刮刮卡大图浏览
-(void)showImage:(UIImageView *)avatarImageView prompt:(NSString *)promptStr{
    CGFloat imageWidth=180 * 1.5;
    CGFloat imageHeight=260 * 1.5;
    UIImage *image=avatarImageView.image;
//    UIWindow *window=[UIApplication sharedApplication].keyWindow;
//    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:self.view];
    cardBgView.alpha=0;
    cardBgView.hidden=NO;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=110;
    imageView.userInteractionEnabled=YES;
    [self.view addSubview:imageView];
//    [self.view addSubview:backgroundView];
    UILabel * _prizeNameLabel=[[UILabel alloc]initWithFrame:dallFrame];
    _prizeNameLabel.textAlignment=NSTextAlignmentCenter;
    _prizeNameLabel.textColor=YAHEI;
    _prizeNameLabel.font=ChangeBeforeFont;
    _prizeNameLabel.backgroundColor=[UIColor whiteColor];
    //        if (prizeName) {
    //            [_prizeNameLabel setText:prizeName];
    //        }else{
    [_prizeNameLabel setText:promptStr];
    //        }
    [imageView addSubview:_prizeNameLabel];
    
    STScratchView * _scratchView=[[STScratchView alloc]initWithFrame:dallFrame];
    _scratchView.delegate=self;
    //        _scratchView.delegate = delegate;
    [_scratchView setSizeBrush:50.0];
    [imageView addSubview:_scratchView];
    // Create a (child) UIView
    //        UIImageView *ball = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(_scratchView.frame), CGRectGetHeight(_scratchView.frame))];
    //        [ball setImage:[UIImage imageNamed:@"灰条(带字).png"]];
    UIView * ballBgView=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(_scratchView.frame), CGRectGetHeight(_scratchView.frame))];
    ballBgView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"灰条"]];
    UILabel * ball=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scratchView.frame), CGRectGetHeight(_scratchView.frame))];
    ball.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"灰条"]];
    ball.text=@"刮开有奖";
    ball.font=ChangeBeforeFont;
    ball.textColor=YAHEI;
    ball.textAlignment=NSTextAlignmentCenter;
    
    [ballBgView addSubview:ball];
    [_scratchView setHideView:ballBgView];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake((self.view.bounds.size.width/2-imageWidth/2),(self.view.bounds.size.height/2-imageHeight/2), imageWidth, imageHeight);
        CGRect newDallFrame=CGRectMake(17, imageHeight-57, imageWidth-34, 44);
        _prizeNameLabel.frame=newDallFrame;
        _scratchView.frame=newDallFrame;
//        _prizeNameLabel.font=ChangeAfterFont;
//        ball.font=ChangeAfterFont;
        cardBgView.alpha=0.7;
    } completion:^(BOOL finished) {
//        imageView.image=[UIImage imageNamed:@"刮刮卡"];
//        CGRect dallFrame=CGRectMake(17, imageHeight-57, imageWidth-34, 44);
//        UILabel * _prizeNameLabel=[[UILabel alloc]initWithFrame:dallFrame];
//        _prizeNameLabel.textAlignment=NSTextAlignmentCenter;
//        _prizeNameLabel.textColor=YAHEI;
//        _prizeNameLabel.font=FONTBOLD(20);
////        if (prizeName) {
////            [_prizeNameLabel setText:prizeName];
////        }else{
//            [_prizeNameLabel setText:@"谢谢参与"];
////        }
//        [imageView addSubview:_prizeNameLabel];
//        
////        HYScratchCardView * scratchCardView = [[HYScratchCardView alloc]initWithFrame:dallFrame];
////        scratchCardView.image = [UIImage imageNamed:@"置顶广告图.png"];
////        [imageView addSubview:scratchCardView];
////        
////        scratchCardView.completion = ^(id userInfo) {
////            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"恭喜"
////                                                               message:@"恭喜中奖."
////                                                              delegate:nil
////                                                     cancelButtonTitle:@"确定"
////                                                     otherButtonTitles:nil];
////            [alertView show];
////        };
//
//        STScratchView * _scratchView=[[STScratchView alloc]initWithFrame:dallFrame];
////        _scratchView.delegate = delegate;
//        [_scratchView setSizeBrush:50.0];
//        [imageView addSubview:_scratchView];
//        // Create a (child) UIView
////        UIImageView *ball = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(_scratchView.frame), CGRectGetHeight(_scratchView.frame))];
////        [ball setImage:[UIImage imageNamed:@"灰条(带字).png"]];
//        UIView * ballBgView=[[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(_scratchView.frame), CGRectGetHeight(_scratchView.frame))];
//        ballBgView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"灰条"]];
//        UILabel * ball=[[UILabel alloc]initWithFrame:CGRectMake(70, 10.0, CGRectGetWidth(_scratchView.frame)-140, CGRectGetHeight(_scratchView.frame)-20)];
////        ball.backgroundColor=[UIColor blueColor];
//        ball.text=@"刮开有奖";
//        ball.font=FONTBOLD(24);
//        ball.textColor=YAHEI;
//        ball.textAlignment=NSTextAlignmentCenter;
//        
//        [ballBgView addSubview:ball];
//        [_scratchView setHideView:ballBgView];
        
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
        [imageView addGestureRecognizer:tap];
    }];
}
-(void)hideImage:(UITapGestureRecognizer*)tap{
    UIImageView *imageView=(UIImageView*)[self.view viewWithTag:110];
    
    UIView * subView2=imageView.subviews[1];
    UIView * subView1=imageView.subviews[0];
    [subView1 removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        
//        subView1.frame=dallFrame;
        subView2.frame=dallFrame;
        imageView.frame=oldframe;
        cardBgView.alpha=0;
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        cardBgView.hidden=YES;
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
