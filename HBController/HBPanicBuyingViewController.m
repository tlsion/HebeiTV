//
//  HBPanicBuyingViewController.m
//  HebeiTV
//
//  Created by Pro on 5/27/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "HBPanicBuyingViewController.h"
#import "HBPanicBuyingCell.h"
#import "UIView+Action.h"
#import "MJRefresh.h"
#import "HBPanicBuyingDetailViewController.h"
#import "HBAlertView.h"
@interface HBPanicBuyingViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MJRefreshBaseViewDelegate>
{
    
    IBOutlet UIView *selectBgView;
    IBOutlet UIButton *selectButton1;
    IBOutlet UIButton *selectButton2;
    IBOutlet UIButton *selectButton3;
    UIScrollView *mainScrollView;
    
    UITableView *selectTableView1;
    
    UITableView *selectTableView2;
    
    UITableView *selectTableView3;
    
    NSMutableArray * selectDatas1;
    NSMutableArray * selectDatas2;
    NSMutableArray * selectDatas3;
    
    UIActivityIndicatorView * loadingMoreView1;
    UIActivityIndicatorView * loadingMoreView2;
    UIActivityIndicatorView * loadingMoreView3;
    
    MJRefreshFooterView * selectFooter1;
    MJRefreshFooterView * selectFooter2;
    MJRefreshFooterView * selectFooter3;
    
    NSInteger selectInteger1;
}
@end

@implementation HBPanicBuyingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    selectBgView.frame=CGRectMake(0, 0, 320, 35);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7)
//    {
//        self.automaticallyAdjustsScrollViewInsets=NO;
//    }
    // Do any additional setup after loading the view.
//    UIView * selectLanBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 35)];
//    selectLanBgView.backgroundColor=[UIColor blueColor];
//    [self.view addSubview:selectLanBgView];
    
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_MAX_WIDTH, SCREEN_MAX_HEIGHT-35-64)];
    mainScrollView.showsVerticalScrollIndicator=NO;
    mainScrollView.showsHorizontalScrollIndicator=NO;
    mainScrollView.delegate=self;
    mainScrollView.pagingEnabled=YES;
    mainScrollView.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
    mainScrollView.contentSize=CGSizeMake(SCREEN_MAX_WIDTH*3, CGRectGetHeight(mainScrollView.frame));
    [self.view addSubview:mainScrollView];
    
    selectTableView1=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_MAX_WIDTH, mainScrollView.frame.size.height) style:UITableViewStylePlain];
    selectTableView1.dataSource=self;
    selectTableView1.delegate=self;
    selectTableView1.separatorStyle=UITableViewCellSeparatorStyleNone;
    selectTableView1.backgroundColor=CLEAR;
    [mainScrollView addSubview:selectTableView1];
    selectDatas1=[[NSMutableArray alloc]init];
    UIView * footView1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    loadingMoreView1=[[UIActivityIndicatorView  alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    loadingMoreView1.center=CGPointMake(160, 20);
    loadingMoreView1.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [footView1 addSubview:loadingMoreView1];
    selectTableView1.tableFooterView=footView1;
//    selectFooter1=[[MJRefreshFooterView alloc]initWithScrollView:selectTableView1];
//    selectFooter1.delegate=self;
    
    selectTableView2=[[UITableView alloc]initWithFrame:CGRectMake(320, 0, SCREEN_MAX_WIDTH, mainScrollView.frame.size.height) style:UITableViewStylePlain];
    selectTableView2.dataSource=self;
    selectTableView2.delegate=self;
    selectTableView2.separatorStyle=UITableViewCellSeparatorStyleNone;
    selectTableView2.backgroundColor=CLEAR;
    [mainScrollView addSubview:selectTableView2];
    selectDatas2=[[NSMutableArray alloc]init];
//    selectFooter2=[[MJRefreshFooterView alloc]initWithScrollView:selectTableView2];
//    selectFooter2.delegate=self;
    UIView * footView2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    loadingMoreView2=[[UIActivityIndicatorView  alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    loadingMoreView2.center=CGPointMake(160, 20);
    loadingMoreView2.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [footView2 addSubview:loadingMoreView2];
    selectTableView2.tableFooterView=footView2;
    
    
    selectTableView3=[[UITableView alloc]initWithFrame:CGRectMake(640, 0, SCREEN_MAX_WIDTH, mainScrollView.frame.size.height) style:UITableViewStylePlain];
    selectTableView3.dataSource=self;
    selectTableView3.delegate=self;
    selectTableView3.separatorStyle=UITableViewCellSeparatorStyleNone;
    selectTableView3.backgroundColor=CLEAR;
    [mainScrollView addSubview:selectTableView3];
    selectDatas3=[[NSMutableArray alloc]init];
//    selectFooter3=[[MJRefreshFooterView alloc]initWithScrollView:selectTableView3];
//    selectFooter3.delegate=self;
    UIView * footView3=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    loadingMoreView3=[[UIActivityIndicatorView  alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    loadingMoreView3.center=CGPointMake(160, 20);
    loadingMoreView3.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [footView3 addSubview:loadingMoreView3];
    selectTableView3.tableFooterView=footView3;
    
    if (_selectIndex==1) {
        selectButton1.selected=YES;
        [self getSelect1Activitylist:8];
    }
    [self selectTableViewIndex:_selectIndex];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (selectFooter1==refreshView) {
        [self getSelect1Activitylist:8];
    }
    else if (selectFooter2==refreshView) {
        [self getSelect2Activitylist];
    }
    else if (selectFooter3==refreshView) {
        [self getSelect3Activitylist];
    }
}
- (IBAction)SelectTheItemAction:(UIButton *)sender{
    [self selectTableViewIndex:sender.tag];
}
-(void)selectTableViewIndex:(NSInteger)index{
    [mainScrollView setContentOffset:CGPointMake((index-1)*320, 0) animated:YES];
}
static int oldOffsetY=0;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float coffset=((scrollView.contentSize.height - scrollView.frame.size.height));
    int flag=scrollView.contentOffset.y-oldOffsetY;
    if (scrollView==mainScrollView) {
        if (scrollView.contentOffset.x==0) {
            
            selectButton1.selected=YES;
            selectButton2.selected=NO;
            selectButton3.selected=NO;
            if (selectDatas1.count==0) {
                [self getSelect1Activitylist:8];
            }
        }
        else if (scrollView.contentOffset.x==320) {
            
            selectButton1.selected=NO;
            selectButton2.selected=YES;
            selectButton3.selected=NO;
            if (selectDatas2.count==0) {
                [self getSelect2Activitylist];
            }
        }
        else if (scrollView.contentOffset.x==640) {
            
            selectButton1.selected=NO;
            selectButton2.selected=NO;
            selectButton3.selected=YES;
            if (selectDatas3.count==0) {
                [self getSelect3Activitylist];
            }
        }
    }
    else if (selectTableView1 == scrollView){
        if (scrollView.contentOffset.y > coffset-30 &&coffset > 0 && flag>0 && !loadingMoreView1.isAnimating) {
            [loadingMoreView1 startAnimating];
            [self getSelect1Activitylist:8];
        }
    }
    else if (selectTableView2 == scrollView){
        if (scrollView.contentOffset.y > coffset-30 &&coffset > 0 && flag>0 && !loadingMoreView2.isAnimating) {
            [loadingMoreView2 startAnimating];
            [self getSelect2Activitylist];
        }
    }
    else if (selectTableView3 == scrollView){
        if (scrollView.contentOffset.y > coffset-30 &&coffset > 0 && flag>0 && !loadingMoreView3.isAnimating) {
            [loadingMoreView3 startAnimating];
            [self getSelect3Activitylist];
        }
    }
    oldOffsetY=scrollView.contentOffset.y;
}
#pragma mark -- tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==selectTableView1) {
        return selectDatas1.count;
    }else if (tableView==selectTableView2) {
        return selectDatas2.count;
    }
    else if (tableView==selectTableView3) {
        return selectDatas3.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath   {
    if (tableView==selectTableView1) {
        NSString * indentifierName=@"HBSelectCell1";
        HBPanicBuyingCell * cell=[tableView dequeueReusableCellWithIdentifier:indentifierName];
        
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"HBPanicBuyingCell" owner:nil options:nil];
            cell = [nibs lastObject];
            UIColor * pinkColor=[UIColor colorWithRed:248.0/255.0 green:84.0/255.0 blue:115.0/255.0 alpha:1];
            cell.panicPriceLabel.textColor=pinkColor;
            cell.countLabel.textColor=pinkColor;
            cell.countPromptLabel.textColor=pinkColor;
        }
        NSDictionary * dic=[selectDatas1 objectAtIndex:indexPath.row];
//        cell.mainImageView.image=[UIImage imageNamed:@"同城抢购-商品（大例）.png"];
//        cell.mainTitleLabel.text=@"春季新款CITYLIFE城市生活粉红色单肩手提女包甜美肩挎";
        cell.mainImageView.imageURL=IMG_URL([dic objectForKey:@"image"]);
        cell.mainTitleLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"activityName"]];
        cell.countLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"minus"]];
        cell.panicPriceLabel.text=[NSString stringWithFormat:@"抢购价￥%.2f",[[dic objectForKey:@"price"] floatValue]];
        cell.OriginalPriceLabel.text=[NSString stringWithFormat:@"原价￥%.2f",[[dic objectForKey:@"costPrice"] floatValue]];
        int allCount=[[dic objectForKey:@"many2"] intValue];
        int residueCount=[[dic objectForKey:@"many"] intValue];
        NSLog(@"%d////%d",allCount,residueCount);
        int personalCount=allCount-residueCount;
        if (personalCount<0) {
            personalCount=0;
        }
        cell.promptLabel.text=[NSString stringWithFormat:@"已有 %d 人成功抢购",personalCount];
        return cell;
    }else if (tableView==selectTableView2) {
        NSString * indentifierName=@"HBSelectCell2";
        HBPanicBuyingCell * cell=[tableView dequeueReusableCellWithIdentifier:indentifierName];
        
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"HBPanicBuyingCell" owner:nil options:nil];
            cell = [nibs lastObject];
            UIColor * pinkColor=[UIColor colorWithRed:82.0/255.0 green:152.0/255.0 blue:252.0/255.0 alpha:1];
            cell.panicPriceLabel.textColor=pinkColor;
            cell.countLabel.textColor=pinkColor;
            cell.countPromptLabel.textColor=pinkColor;
        }
        NSDictionary * dic=[selectDatas2 objectAtIndex:indexPath.row];
        //        cell.mainImageView.image=[UIImage imageNamed:@"同城抢购-商品（大例）.png"];
        //        cell.mainTitleLabel.text=@"春季新款CITYLIFE城市生活粉红色单肩手提女包甜美肩挎";
        cell.mainImageView.imageURL=IMG_URL([dic objectForKey:@"image"]);
        cell.mainTitleLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"activityName"]];
        cell.countLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"minus"]];
        cell.panicPriceLabel.text=[NSString stringWithFormat:@"抢购价 ￥%.2f",[[dic objectForKey:@"price"] floatValue]];
        cell.OriginalPriceLabel.text=[NSString stringWithFormat:@"原价 ￥%.2f",[[dic objectForKey:@"costPrice"] floatValue]];
        cell.promptLabel.text=[NSString stringWithFormat:@"%@ 准时开抢",[dic objectForKey:@"beginTime"]];
        return cell;
    }
    else if (tableView==selectTableView3) {
        NSString * indentifierName=@"HBSelectCell3";
        HBPanicBuyingCell * cell=[tableView dequeueReusableCellWithIdentifier:indentifierName];
        
        if (!cell) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"HBPanicBuyingCell" owner:nil options:nil];
            cell = [nibs lastObject];
            UIColor * pinkColor=[UIColor colorWithRed:248.0/255.0 green:115.0/255.0 blue:66.0/255.0 alpha:1];
            cell.panicPriceLabel.textColor=pinkColor;
            cell.countLabel.textColor=pinkColor;
            cell.countPromptLabel.textColor=pinkColor;
        }
        NSDictionary * dic=[selectDatas3 objectAtIndex:indexPath.row];
        //        cell.mainImageView.image=[UIImage imageNamed:@"同城抢购-商品（大例）.png"];
        //        cell.mainTitleLabel.text=@"春季新款CITYLIFE城市生活粉红色单肩手提女包甜美肩挎";
        cell.mainImageView.imageURL=IMG_URL([dic objectForKey:@"image"]);
        cell.mainTitleLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"activityName"]];
        cell.countLabel.text=[NSString stringWithFormat:@"%@",[dic objectForKey:@"minus"]];
        cell.panicPriceLabel.text=[NSString stringWithFormat:@"抢购价 ￥%.2f",[[dic objectForKey:@"price"] floatValue]];
        cell.OriginalPriceLabel.text=[NSString stringWithFormat:@"原价 ￥%.2f",[[dic objectForKey:@"costPrice"] floatValue]];
        cell.promptLabel.text=[NSString stringWithFormat:@"抢购结束"];
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSInteger beansCount=[[[NSUserDefaults standardUserDefaults] objectForKey:@"beanscount"] integerValue];
    NSDictionary * dic;
    if (tableView==selectTableView1) {
        selectInteger1=indexPath.row;
        dic=[selectDatas1 objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"PanicBuyingDetailPush" sender:self];
    }
    
    
    
//    else if (tableView==selectTableView2) {
//        dic=[selectDatas2 objectAtIndex:indexPath.row];
//        NSInteger needBeansCount=[[dic objectForKey:@"minus"] integerValue];
//        if (beansCount>=needBeansCount) {
//            
//        }
//        else{
//            [self.view makeToast:@"您的豆豆数不足!"];
//        }
//    }
//    else if (tableView==selectTableView3) {
//        dic=[selectDatas3 objectAtIndex:indexPath.row];
//        NSInteger needBeansCount=[[dic objectForKey:@"minus"] integerValue];
//        if (beansCount>=needBeansCount) {
//            
//        }
//        else{
//            [self.view makeToast:@"您的豆豆数不足!"];
//        }
//    }
}


#pragma mark -- httpService
-(void)updatePanicBuyingGoodsIndex:(int) index{
    if (index==0) {
        int allCount=selectDatas1.count;
        [selectDatas1 removeAllObjects];
        
        [self getSelect1Activitylist:allCount];
    }
    
}
-(void)getSelect1Activitylist:(int)PageSize{
    [self.view makeToastActivity];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * currentDate = [formatter stringFromDate:[NSDate date]];
    
    NSDictionary * paramDic=@{@"pageStart":[NSString stringWithFormat:@"%d",selectDatas1.count],@"pageSize":[NSString stringWithFormat:@"%d",PageSize],@"Q_beginTime_S_LE":currentDate,@"Q_endTime_S_GE":currentDate};
    [HBHTTPService requestPostMethod:@"ImplActivitylist.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
        if (service.status==1) {
            [selectDatas1 addObjectsFromArray:service.allLists];
            [selectTableView1 reloadData];
        }
        [self.view hideToastActivity];
        [loadingMoreView1 stopAnimating];
    }andServiceFailBlock:^(void){
        [self.view hideToastActivity];
        [loadingMoreView1 stopAnimating];
    }];
}
-(void)getSelect2Activitylist{
    [self.view makeToastActivity];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * currentDate = [formatter stringFromDate:[NSDate date]];
    
    NSDictionary * paramDic=@{@"pageStart":[NSString stringWithFormat:@"%d",selectDatas2.count],@"pageSize":@"8",@"Q_beginTime_S_GT":currentDate};
    [HBHTTPService requestPostMethod:@"ImplActivitylist.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
        if (service.status==1) {
            [selectDatas2 addObjectsFromArray:service.allLists];
            [selectTableView2 reloadData];
        }
        [self.view hideToastActivity];
        [loadingMoreView2 stopAnimating];
    }andServiceFailBlock:^(void){
        [self.view hideToastActivity];
        [loadingMoreView2 stopAnimating];
    }];
}
-(void)getSelect3Activitylist{
    [self.view makeToastActivity];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * currentDate = [formatter stringFromDate:[NSDate date]];
    
    NSDictionary * paramDic=@{@"pageStart":[NSString stringWithFormat:@"%d",selectDatas3.count],@"pageSize":@"8",@"Q_endTime_S_LT":currentDate};
    [HBHTTPService requestPostMethod:@"ImplActivitylist.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
        if (service.status==1) {
            [selectDatas3 addObjectsFromArray:service.allLists];
            [selectTableView3 reloadData];
        }
        [self.view hideToastActivity];
        [loadingMoreView3 stopAnimating];
    }andServiceFailBlock:^(void){
        [self.view hideToastActivity];
        [loadingMoreView3 stopAnimating];
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"PanicBuyingDetailPush"]) {
        HBPanicBuyingDetailViewController * pbdVC=[segue destinationViewController];
        pbdVC.delegate=self;
        NSDictionary * dic=[selectDatas1 objectAtIndex:selectInteger1];
        pbdVC.activityId=[dic objectForKey:@"activityId"];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
