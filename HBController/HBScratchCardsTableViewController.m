//
//  HBScratchCardsTableViewController.m
//  HebeiTV
//
//  Created by Pro on 5/20/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "HBScratchCardsTableViewController.h"
#import "HBScratchCardsGoodsCell.h"
#import "HBCardAnimationShowViewController.h"
#import "UIView+Action.h"
//#import "UIScrollView+UzysCircularProgressPullToRefresh.h"
#import "MJRefresh.h"
//#import "UIScrollView+SpiralPullToRefresh.h"
@interface HBScratchCardsTableViewController ()
{
    NSMutableArray * tableDataList;
    UIActivityIndicatorView *loadingMoreView;
    
//    MJRefreshHeaderView * refreshHeaderView;
    
    IBOutlet UILabel *beansCountLabel;
    
    NSDictionary * selectInfoDic;
     IBOutlet UILabel *luckyNotionLabel;
    IBOutlet UIView *myBeanBgView;
    
}
@end

@implementation HBScratchCardsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Because of self.automaticallyAdjustsScrollViewInsets you must add code below in viewWillApper
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataBeansCount) name:@"UPDATA_NEW_BEANS" object:nil];
    NSInteger beansCount=[[[NSUserDefaults standardUserDefaults] objectForKey:@"beanscount"] integerValue];
    beansCountLabel.text=[NSString stringWithFormat:@"%d",beansCount];

    
    
    tableDataList=[[NSMutableArray alloc]init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIView * footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    loadingMoreView=[[UIActivityIndicatorView  alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    loadingMoreView.center=CGPointMake(160, 14);
    loadingMoreView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [footView addSubview:loadingMoreView];
    self.tableView.tableFooterView=footView;
    
    UITapGestureRecognizer * tap4=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMyBeansWindow)];
    [myBeanBgView addGestureRecognizer:tap4];
    
//    self.tableView.frame=CGRectMake(0, 200, 320, SCREEN_MAX_HEIGHT-200);
    
//    refreshHeaderView=[[MJRefreshHeaderView alloc]initWithScrollView:self.tableView];
//    refreshHeaderView.delegate=self;
//    [self addRefreingFunction];
    
    [self getScrathlist];
    
    [self updateLuckyUser];
    [NSTimer scheduledTimerWithTimeInterval:LuckyTimer target:self selector:@selector(updateLuckyUser) userInfo:nil repeats:YES];

}
-(void)showMyBeansWindow{
    
    HBAlertView * av=[[HBAlertView alloc]initWithDuoDuoDouPrompt:beansCountLabel.text contentText:@"拥有多多豆可以参与\r【刮刮卡】和【同城抢购】\r更多活动即将登场，敬请期待!" leftButtonTitle:nil rightButtonTitle:@"确定"];
    av.beansTitleLabel.textColor=[UIColor orangeColor];
    [av show];
    
}
#pragma mark  --  幸运公告
static int luckyIndex=0;

-(void)updateLuckyUser{
    if (self.luckyInfos.count>0) {
        if (luckyIndex>=self.luckyInfos.count) {
            luckyIndex=0;
        }
        NSDictionary * ticketDic=self.luckyInfos[luckyIndex];
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
}
#pragma end mark
-(void)updataBeansCount{
    NSInteger beansCount=[[[NSUserDefaults standardUserDefaults] objectForKey:@"beanscount"] integerValue];
    beansCountLabel.text=[NSString stringWithFormat:@"%d",beansCount];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
//    if (refreshView==refreshHeaderView) {
//        [tableDataList removeAllObjects];
//        [self getScrathlist];
//    }
//}
//
////下拉刷新
//-(void)addRefreingFunction{
////    self.navigationController.navigationBarHidden=YES;
//    __typeof (&*self) __weak weakSelf = self;
//    
//    [self.tableView addPullToRefreshWithActionHandler:^ {
//        int64_t delayInSeconds = 1.0;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [weakSelf refreshTriggered];
//        });
//    }];
//    
//    // Three type of waiting animations available now: Random, Linear and Circular
//    self.tableView.pullToRefreshController.waitingAnimation = SpiralPullToRefreshWaitAnimationCircular;
//}
//- (void)refreshTriggered {
//    [self statTodoSomething];
//}
//- (void)statTodoSomething {
//    
//    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onAllworkDoneTimer:) userInfo:nil repeats:NO];
//}
//- (void)onAllworkDoneTimer:(NSTimer *)sender{
//    [sender invalidate];
//    sender = nil;
//    
//    [self.tableView.pullToRefreshController didFinishRefresh];
//    [self.tableView reloadData];
//}
#pragma mark -- 下拉刷新

//- (void)insertRowAtTop {
//    __weak typeof(self) weakSelf = self;
//    
//    int64_t delayInSeconds = 2.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        [weakSelf.tableView beginUpdates];
////        [weakSelf.pData insertObject:[NSDate date] atIndex:0];
////        [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
////        [weakSelf.tableView endUpdates];
//        
//        //Stop PullToRefresh Activity Animation
//        [weakSelf.tableView stopRefreshAnimation];
//    });
//}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
//    [refreshHeaderView endRefreshing];
//    return 10;
    return tableDataList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell=[self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        return CGRectGetHeight(cell.frame);
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * reuseIdentifier=@"HBScratchCardsGoodsCell";
    HBScratchCardsGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell=[[HBScratchCardsGoodsCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    NSDictionary * dic=[tableDataList objectAtIndex:indexPath.row];
    
    NSString * imageUrl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"image"]];
    cell.mainImageView.imageURL=IMG_URL(imageUrl);
    cell.titleLabel.text=[dic objectForKey:@"scratchName"];
    
    cell.countLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"minus"]];
//    cell.mainImageView.image=[UIImage imageNamed:@"刮刮卡大图（例子）"];
//    cell.titleLabel.text=@"高露洁高清亮白洁厕剂";
//    cell.countLabel.text=@"50";
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectInfoDic=[tableDataList objectAtIndex:indexPath.row];
    NSInteger beansCount=[[[NSUserDefaults standardUserDefaults] objectForKey:@"beanscount"] integerValue];
    NSInteger needBeansCount=[[selectInfoDic objectForKey:@"minus"] integerValue];
    if (beansCount>=needBeansCount) {

        [self performSegueWithIdentifier:@"CardAnimationPush" sender:self];
    }
    else{
        [self.view makeToast:@"您的豆豆数不足!"];
    }
    
}
static int oldOffsetY=0;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float coffset=((scrollView.contentSize.height - scrollView.frame.size.height));
    int flag=scrollView.contentOffset.y-oldOffsetY;
    if (scrollView.contentOffset.y > coffset-30 && coffset>0 && flag>0 && !loadingMoreView.isAnimating) {
        [loadingMoreView startAnimating];
        [self getScrathlist];
    }
    oldOffsetY=scrollView.contentOffset.y;
}
-(void)loadMore
{
    NSMutableArray *more;
    more=[[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<10; i++) {
        [more addObject:[NSString stringWithFormat:@"cell ++%i",i]];
    }
    //加载你的数据
    [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:more waitUntilDone:NO];
}
-(void) appendTableWith:(NSMutableArray *)data
{
    for (int i=0;i<[data count];i++) {
        [tableDataList addObject:[data objectAtIndex:i]];
    }
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
    for (int ind = 0; ind < [data count]; ind++) {
        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow:[tableDataList indexOfObject:[data objectAtIndex:ind]] inSection:0];
        [insertIndexPaths addObject:newPath];
    }
    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row==0) {
//        
//    }else{
//        [self getScrathgetAward];
//    }
//}
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
    if ([[segue identifier]isEqualToString:@"CardAnimationPush"]) {
        
        HBCardAnimationShowViewController * cardShowVC=[segue destinationViewController];
        cardShowVC.cardInfoDic=selectInfoDic;
        cardShowVC.title=[selectInfoDic objectForKey:@"scratchName"];
    }
}
#pragma mark -- httpService
-(void)getScrathlist{
    AppDelegate * app=APP;
    
    [app.window makeToastActivity];
    NSDictionary * paramDic=@{@"pageStart": [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:tableDataList.count]],@"pageSize":@"8"};
    [HBHTTPService requestPostMethod:@"ImplScrathlist.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
        [tableDataList addObjectsFromArray:service.allLists];
        [self.tableView reloadData];
        
        [app.window hideToastActivity];
        [loadingMoreView stopAnimating];
    }andServiceFailBlock:^(void){
        [app.window hideToastActivity];
        [loadingMoreView stopAnimating];
    }];
}
//-(void)getScrathgetAward{
//    NSDictionary * paramDic=@{@"scratchId": @"1",@"userId": @"1",@"probability":@"0"};
//    [HBHTTPService requestGetMethod:@"ImplScrathgetAward.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
//    }andServiceFailBlock:^(void){
//        
//    }];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UPDATA_NEW_BEANS" object:nil];
}
@end
