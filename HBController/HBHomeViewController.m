//
//  HBHomeViewController.m
//  HebeiTV
//
//  Created by Pro on 5/14/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//
#import "HBHomeViewController.h"
#import "HBHomeAdCell.h"
//#import "HBBannerView.h"
#import "HBBannerDetailViewController.h"
#import "HBPageControl.h"
#import "HBAlertView.h"
#import "HBScratchCardsTableViewController.h"
#import "UIView+Action.h"
#import "HBPanicBuyingViewController.h"
#import "HBYaoYiYaoViewController.h"
#import "HBScratchCardsTableViewController.h"
#import "HBLogViewController.h"
#import "HBNavigationController.h"
#import "HBLoginNavigationController.h"
#import "HBAdvertisementDetailViewController.h"
//#import <ZYPush/LPService.h>

#define LOGIN_PROMPT @"您还未登录，请先登录!"
#define TopBannerTag 1000
#define TopBannerTimer 5
//static int TopBannerCount;

#define LeftBannerTag 2000
#define LeftBannerTimer 4
//static int LeftBannerCount;

@interface HBHomeViewController ()<UIScrollViewDelegate>
{
    IBOutlet UIScrollView *bannerScrollView;
    NSArray * topBannerDatas;
    HBPageControl  * topPageControl;
    
    IBOutlet UIScrollView *leftBannerScrollView;
    IBOutlet UIView *leftBgView;
    
    IBOutlet UILabel *luckyNotionLabel;
    HBPageControl  * leftPageControl;
    NSArray * leftBannerDatas;
    
    
    NSArray * scrollBannerDatas;
    
    
    IBOutlet UIView *myBeansView;
    IBOutlet UIView *panicBuyingView1;
    IBOutlet UIView *panicBuyingView2;
    IBOutlet UIView *panicBuyingView3;
    
    IBOutlet UILabel *beansCountLabel;
    
    IBOutlet EGOImageView *panicSelectImageView1;
    
    IBOutlet UILabel *panicSelectNameLabel1;
    IBOutlet EGOImageView *panicSelectImageView2;
    IBOutlet UILabel *panicSelectNameLabel2;
    
    IBOutlet EGOImageView *panicSelectImageView3;
    IBOutlet UILabel *panicSelectNameLabel3;
    NSUserDefaults * userDefaults;
    
    NSInteger selectPanicBuyingIndex;
    
    NSString * selectAdURL;
    
    NSArray * luckyInfos;
}
@end

@implementation HBHomeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataBeansCount) name:@"UPDATA_NEW_BEANS" object:nil];
//    self.navigationController.navigationBar.tintColor = YAHEI;
//    self.navigationController.navigationBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"首页顶部.png"]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UITapGestureRecognizer * tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPanciBuyingGecongnizer:)];
    UITapGestureRecognizer * tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPanciBuyingGecongnizer:)];
    UITapGestureRecognizer * tap3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPanciBuyingGecongnizer:)];
    
    [panicBuyingView1 addGestureRecognizer:tap1];
    [panicBuyingView2 addGestureRecognizer:tap2];
    [panicBuyingView3 addGestureRecognizer:tap3];
    
    UITapGestureRecognizer * tap4=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMyBeansWindow)];
    [myBeansView addGestureRecognizer:tap4];
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    [self getAdsgetAdsInfo];
    
    [self getWinlist];
    
    AppDelegate * app=APP;
    [app getUserInfogetBean];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     YAHEI, UITextAttributeTextColor,
                                                                     CLEAR, UITextAttributeTextShadowColor,
                                                                     [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                                     [UIFont fontWithName:@"Arial-Bold" size:0.0], UITextAttributeFont,
                                                                     nil]];
    [self updataBeansCount];
}

-(void)showMyBeansWindow{

    if ([[userDefaults objectForKey:@"islogin"]boolValue]) {
        HBAlertView * av=[[HBAlertView alloc]initWithDuoDuoDouPrompt:beansCountLabel.text contentText:@"拥有多多豆可以参与\r【刮刮卡】和【同城抢购】\r更多活动即将登场，敬请期待!" leftButtonTitle:nil rightButtonTitle:@"确定"];
        av.beansTitleLabel.textColor=[UIColor orangeColor];
        [av show];
    }else{
        HBAlertView * av=[[HBAlertView alloc]initWithTitle:@"提示" contentText:LOGIN_PROMPT leftButtonTitle:@"取消" rightButtonTitle:@"登录"];
        [av show];
        av.rightBlock=^(void){
            [self enterLoginController];
        };
    }
}
- (IBAction)functionAction:(UIButton *)sender {
    if (sender.tag==10) {
        if ([[userDefaults objectForKey:@"islogin"]boolValue]) {
            [self performSegueWithIdentifier:@"YaoyiyaoPush" sender:self];
        }else{
            HBAlertView * av=[[HBAlertView alloc]initWithTitle:@"提示" contentText:LOGIN_PROMPT leftButtonTitle:@"取消" rightButtonTitle:@"登录"];
            [av show];
            av.rightBlock=^(void){
                [self enterLoginController];
            };
        }
    }
    else if(sender.tag==11){
        if ([[userDefaults objectForKey:@"islogin"]boolValue]) {
            [self performSegueWithIdentifier:@"ScratchCardsPush" sender:self];
        }else{
            HBAlertView * av=[[HBAlertView alloc]initWithTitle:@"提示" contentText:LOGIN_PROMPT leftButtonTitle:@"取消" rightButtonTitle:@"登录"];
            [av show];
            av.rightBlock=^(void){
                [self enterLoginController];
            };
        }
    }
    else if(sender.tag==12){
        if ([[userDefaults objectForKey:@"islogin"]boolValue]) {
            [self performSegueWithIdentifier:@"TicketListPush" sender:self];
        }else{
            HBAlertView * av=[[HBAlertView alloc]initWithTitle:@"提示" contentText:LOGIN_PROMPT leftButtonTitle:@"取消" rightButtonTitle:@"登录"];
            [av show];
            av.rightBlock=^(void){
                [self enterLoginController];
            };
        }

    }
    else if(sender.tag==13){
    
    }
}


-(void)enterLoginController{
    
    [self performSegueWithIdentifier:@"LoginModel" sender:self];
}
-(void)updataBeansCount{
    if ([[userDefaults objectForKey:@"islogin"]boolValue]) {
        
        NSInteger beansCount=[[[NSUserDefaults standardUserDefaults] objectForKey:@"beanscount"] integerValue];
        beansCountLabel.text=[NSString stringWithFormat:@"%d",beansCount];
    }else{
        beansCountLabel.text=@"未登录";
    }
}
-(void)selectPanciBuyingGecongnizer:(UITapGestureRecognizer *)sender{
    
    if ([[userDefaults objectForKey:@"islogin"]boolValue]) {
        UIView * selectView=sender.view;
        selectPanicBuyingIndex=selectView.tag;
        [self performSegueWithIdentifier:@"PanicBuyingPush" sender:self];
    }else{
        HBAlertView * av=[[HBAlertView alloc]initWithTitle:@"提示" contentText:LOGIN_PROMPT leftButtonTitle:@"取消" rightButtonTitle:@"登录"];
        [av show];
        av.rightBlock=^(void){
            [self enterLoginController];
        };
    }
}
-(void)enterAdvertisementDetailURLStr:(NSString *)url adType:(int) type{
    if (type==2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        selectAdURL=url;
        [self performSegueWithIdentifier:@"AdvertisementPush" sender:self];
    }
}
#pragma mark-- 创建顶部轮播图片
-(void)createBannerContent
{
    //设置大小
    bannerScrollView.contentSize=CGSizeMake(SCREEN_MAX_WIDTH*topBannerDatas.count, 115);
    
//    bannerViews=[[NSMutableArray alloc]initWithCapacity:BannerCount];
    //添加轮播图片
    for (int i=0; i<topBannerDatas.count; i++)
    {
        NSDictionary * topDic=[topBannerDatas objectAtIndex:i];
        EGOImageView * bannerImgView=[[EGOImageView alloc]initWithFrame:CGRectMake(i*320, 0, 320, 115)];
        bannerImgView.userInteractionEnabled=YES;
        bannerImgView.placeholderImage=[UIImage imageNamed:@"置顶广告图"];
        bannerImgView.imageURL=IMG_URL([topDic objectForKey:@"smallImage"]);
        bannerImgView.tag=i+TopBannerTag;
        UITapGestureRecognizer * topTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(operateTopBannerViewGecognizer:)];
        [bannerImgView addGestureRecognizer:topTap];
        [bannerScrollView addSubview:bannerImgView];
    }
    
    
    
    //创建三个点的试图
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bannerScrollView.frame)-12, 320, 12)];
//    imgView.image=[UIImage imageNamed:@"pageControlView.png"];
    [self.view addSubview:imgView];
    
    //创建三个点（UIPageControl）
    topPageControl=[[HBPageControl alloc]initWithFrame:CGRectMake(10, 0, topBannerDatas.count*16, 12)];
    topPageControl.numberOfPages=topBannerDatas.count;
    topPageControl.indicatorMargin=1;
    [topPageControl sizeForNumberOfPages:16];
    [topPageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"广告图浮标.png"]];
    [topPageControl setPageIndicatorImage:[UIImage imageNamed:@"广告图浮标2.png"]];
    
    //当前点
    [imgView addSubview:topPageControl];
    
    
    
    //创建定时器,5s切换图片
    [self performSelector:@selector(switchFocusImage) withObject:nil afterDelay:TopBannerTimer];
}
-(void)operateTopBannerViewGecognizer:(UITapGestureRecognizer *)sender
{
    UIView  * adView=sender.view;
    NSDictionary * adDic=[topBannerDatas objectAtIndex:adView.tag-TopBannerTag];
    [self enterAdvertisementDetailURLStr:[adDic objectForKey:@"url"] adType:[[adDic objectForKey:@"linkType"] intValue]];
}
//图片自动轮播
-(void) switchFocusImage
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchFocusImage) object:nil];
    //获取目标位置
    CGFloat targetX = bannerScrollView.contentOffset.x + bannerScrollView.frame.size.width;
    //移动到指定位置
    [self moveToTargetPosition:targetX];
    //隔多久调用此方法
    [self performSelector:@selector(switchFocusImage) withObject:nil afterDelay:TopBannerTimer];
}
- (void)moveToTargetPosition:(CGFloat)targetX
{
    //最后一张，移动到0
    if (targetX >= bannerScrollView.contentSize.width)
    {
        targetX = 0.0;
    }
    //改变偏移量
    [bannerScrollView setContentOffset:CGPointMake(targetX, 0) animated:YES] ;
    //获取当前页面
    topPageControl.currentPage = (bannerScrollView.contentOffset.x / bannerScrollView.frame.size.width);
}
#pragma mark -- 左右滑动轮播图片
-(void)createLeftBannerContent
{
    float floatFlag=[[NSString stringWithFormat:@"%d",(int)leftBannerDatas.count]floatValue]/2;
    int leftFlag = roundf(floatFlag);
//    float leftFlag2=[NSString stringWithFormat:@"%.0f",leftFlag];
    //设置大小
    leftBannerScrollView.contentSize=CGSizeMake(SCREEN_MAX_WIDTH*leftFlag, 100);
    
    //    bannerViews=[[NSMutableArray alloc]initWithCapacity:BannerCount];
    //添加轮播图片
    for (int i=0; i<leftBannerDatas.count; i++)
    {
        NSDictionary * leftDic=[leftBannerDatas objectAtIndex:i];
        EGOImageView * bannerImgView=[[EGOImageView alloc]initWithFrame:CGRectMake(((i+1)%2)==1? (i/2)*320+6 : (i/2)*320 + 163.5, 0, 150, 100)];
        bannerImgView.userInteractionEnabled=YES;
//        bannerImgView.placeholderImage=[UIImage imageNamed:@"左右滑动广告（默认）"];
        bannerImgView.imageURL=IMG_URL([leftDic objectForKey:@"smallImage"]);
        bannerImgView.tag=i+LeftBannerTag;
        
        UITapGestureRecognizer * leftTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(operateLeftBannerViewGecognizer:)];
        [bannerImgView addGestureRecognizer:leftTap];
        [leftBannerScrollView addSubview:bannerImgView];
        
        UILabel * leftTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, bannerImgView.frame.size.height-20, bannerImgView.frame.size.width, 20)];
        leftTitleLabel.textColor=[UIColor whiteColor];
        leftTitleLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"左右滑动广告黑条.png"]];
        leftTitleLabel.textAlignment=NSTextAlignmentCenter;
        leftTitleLabel.font=FONT_BIG;
        leftTitleLabel.text=[leftDic objectForKey:@"adSlogan"];
        [bannerImgView addSubview:leftTitleLabel];
        
    }

    
    
    
    //创建三个点的试图
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(leftBgView.frame)-15, 320, 15)];
    //    imgView.image=[UIImage imageNamed:@"pageControlView.png"];
//    imgView.backgroundColor=YAHEI;
    [leftBgView addSubview:imgView];
    
    //创建三个点（UIPageControl）
    leftPageControl=[[HBPageControl alloc]initWithFrame:CGRectMake(0, 0, leftFlag*16, 12)];
    leftPageControl.center=CGPointMake(160, 12.5);
    leftPageControl.indicatorMargin=-3;
    leftPageControl.numberOfPages=leftFlag;
    [leftPageControl sizeForNumberOfPages:16];
    [leftPageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"左右滑动广告页码.png"]];
    [leftPageControl setPageIndicatorImage:[UIImage imageNamed:@"左右滑动广告页码2.png"]];
    
    //当前点
    [imgView addSubview:leftPageControl];
    
    
    
    //创建定时器,5s切换图片
    [self performSelector:@selector(leftSwitchFocusImage) withObject:nil afterDelay:LeftBannerTimer];
}
-(void)operateLeftBannerViewGecognizer:(UITapGestureRecognizer *)sender
{
    UIView  * adView=sender.view;
    NSDictionary * adDic=[leftBannerDatas objectAtIndex:adView.tag-LeftBannerTag];
    [self enterAdvertisementDetailURLStr:[adDic objectForKey:@"url"] adType:[[adDic objectForKey:@"linkType"] intValue]];
}
//图片自动轮播
-(void) leftSwitchFocusImage
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(leftSwitchFocusImage) object:nil];
    //获取目标位置
    CGFloat targetX = leftBannerScrollView.contentOffset.x + leftBannerScrollView.frame.size.width;
    //移动到指定位置
    [self leftMoveToTargetPosition:targetX];
    //隔多久调用此方法
    [self performSelector:@selector(leftSwitchFocusImage) withObject:nil afterDelay:LeftBannerTimer];
}
- (void)leftMoveToTargetPosition:(CGFloat)targetX
{
    //最后一张，移动到0
    if (targetX >= leftBannerScrollView.contentSize.width)
    {
        targetX = 0.0;
    }
    //改变偏移量
    [leftBannerScrollView setContentOffset:CGPointMake(targetX, 0) animated:YES] ;
    //获取当前页面
    leftPageControl.currentPage = (leftBannerScrollView.contentOffset.x / leftBannerScrollView.frame.size.width);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (bannerScrollView==scrollView)
    {
        topPageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
    }
    else if (leftBannerScrollView==scrollView)
    {
        leftPageControl.currentPage = (int)(scrollView.contentOffset.x / scrollView.frame.size.width);
    }
    //[self.newsTable tableViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //[self.newsTable tableViewDidEndDragging:scrollView];
    
}
#pragma mark -- 获取完广告数据赋值
-(void)setTopBannerAdsData:(NSArray *)topBannerAds{
    topBannerDatas =topBannerAds;
    [self createBannerContent];
}
-(void)setLeftBannerAdsData:(NSArray *)leftBannerAds{
    leftBannerDatas =leftBannerAds;
    [self createLeftBannerContent];
}
-(void)setUpBannerAdsData:(NSArray *)upBannerAds{
    scrollBannerDatas=upBannerAds;
    [self.tableView reloadData];
}
-(void)setCityAdsData:(NSArray *)cityAds{
    for (int i=0; i<cityAds.count; i++) {
        NSDictionary * dic=cityAds[i];
        NSString * imageURL=[NSString stringWithFormat:@"%@",[dic objectForKey:@"smallImage"]];
        NSString * adSlogan=[NSString stringWithFormat:@"%@",[dic objectForKey:@"adSlogan"]];
        if ([[dic objectForKey:@"type"]intValue]==4) {
            panicSelectImageView1.imageURL=IMG_URL(imageURL);
            panicSelectNameLabel1.text=adSlogan;
        }
        else if ([[dic objectForKey:@"type"]intValue]==5) {
            panicSelectImageView2.imageURL=IMG_URL(imageURL);
            panicSelectNameLabel2.text=adSlogan;
        }
        else if ([[dic objectForKey:@"type"]intValue]==6) {
            panicSelectImageView3.imageURL=IMG_URL(imageURL);
            panicSelectNameLabel3.text=adSlogan;
        }
    }
}
#pragma end mark
#pragma mark  --  幸运公告
static int luckyIndex=0;

-(void)updateLuckyUser{
    if (luckyIndex>=luckyInfos.count) {
        luckyIndex=0;
    }
    NSDictionary * ticketDic=luckyInfos[luckyIndex];
    NSDictionary * activityDic=[ticketDic objectForKey:@"activity"];
    NSDictionary * scrathDic=[ticketDic objectForKey:@"scrath"];
    NSString * userName=[NSString stringWithFormat:@"%@",[ticketDic objectForKey:@"remark2"]];
    NSString * luckyContent=@"";
    if (![activityDic isEqual:[NSNull null]]) {
        NSString * activityName=[NSString stringWithFormat:@"%@",[activityDic objectForKey:@"activityName"]];
        luckyContent=[NSString stringWithFormat:@"恭喜用户【%@】，在同城抢购活动中获得了【%@】抢购机会",userName,activityName];
    }
    else if (![scrathDic isEqual:[NSNull null]]) {
        NSString * scratchName=[NSString stringWithFormat:@"%@",[scrathDic objectForKey:@"scratchName"]];
        luckyContent=[NSString stringWithFormat:@"恭喜用户【%@】，在刮刮卡活动中赢取了【%@】一份",userName,scratchName];
    }
    luckyNotionLabel.text=luckyContent;
    luckyIndex++;
}
#pragma end mark
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return scrollBannerDatas.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
- (HBHomeAdCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * indentifierName=@"HBHomeAdCell";
    HBHomeAdCell * cell=[tableView dequeueReusableCellWithIdentifier:indentifierName];
    
    if (!cell) {
        cell=[[HBHomeAdCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifierName];
    }
    NSDictionary * dic=[scrollBannerDatas objectAtIndex:indexPath.row];
//    cell.mainImageView.placeholderImage=[UIImage imageNamed:@"广告（例）"];
    cell.mainImageView.imageURL=IMG_URL([dic objectForKey:@"smallImage"]);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * adDic=[scrollBannerDatas objectAtIndex:indexPath.row];
    [self enterAdvertisementDetailURLStr:[adDic objectForKey:@"url"] adType:[[adDic objectForKey:@"linkType"] intValue]];

//    HBAlertView * av=[[HBAlertView alloc]initWithDuoDuoDouCount:50 leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
//    [av show];
}
#pragma mark -- httpService
-(void)getAdsgetAdsInfo{
//    AppDelegate * app=APP;
    
//    [app.window makeToastActivity];
    NSDictionary * paramDic=@{};
    [HBHTTPService requestGetMethod:@"ImplAdsgetAdsInfo.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
        if (service.status==1) {
            NSDictionary * dataList=[service.allDataDic objectForKey:@"dataList"];
            NSArray * leftAds=[dataList objectForKey:@"left"];
            NSArray * supriseAds=[dataList objectForKey:@"city"];
            NSArray * topAds=[dataList objectForKey:@"top"];
            NSArray * upAds=[dataList objectForKey:@"up"];
            
            
            [self setTopBannerAdsData:topAds];
            [self setLeftBannerAdsData:leftAds];
            [self setCityAdsData:supriseAds];
            [self setUpBannerAdsData:upAds];
            
        }
//        [app.window hideToastActivity];
    }andServiceFailBlock:^(void){
//        [app.window hideToastActivity];
    }];
}
-(void)getWinlist{
    NSDictionary * paramDic=@{@"pageStart":@"0",@"pageSize":[NSString stringWithFormat:@"%d",LuckyNoticeCount]};
    [HBHTTPService requestPostMethod:@"ImplWinlist.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
        if (service.status==1) {
            if (service.allLists.count>0) {
                luckyInfos=service.allLists;
                [self updateLuckyUser];
                [NSTimer scheduledTimerWithTimeInterval:LuckyTimer target:self selector:@selector(updateLuckyUser) userInfo:nil repeats:YES];
            }
//            [ticketMessages addObjectsFromArray:service.allLists];
//            [self.tableView reloadData];
        }
    }andServiceFailBlock:^(void){
        
    }];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"LoginModel"]){
//        DetailsTVC *detailsVC = [segue destinationViewController];
//        detailsVC.delegate = self;
//        detailsVC.displayedLetter = [tableview objectAtIndex:row]
        
    }else if ([[segue identifier] isEqualToString:@"PanicBuyingPush"]) {
        HBPanicBuyingViewController * panicBuyingVC=[segue destinationViewController];
        panicBuyingVC.selectIndex=selectPanicBuyingIndex;
    }
    else if ([[segue identifier] isEqualToString:@"ScratchCardsPush"]) {
        HBScratchCardsTableViewController * scratchCardsVC=[segue destinationViewController];
        scratchCardsVC.luckyInfos=luckyInfos;
        
    }else if ([[segue identifier] isEqualToString:@"AdvertisementPush"]){
        HBAdvertisementDetailViewController * adDetailVC=[segue destinationViewController];
        adDetailVC.adURL=[NSURL URLWithString:selectAdURL];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UPDATA_NEW_BEANS" object:nil];
}
@end
