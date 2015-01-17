//
//  HBTicketListViewController.m
//  HebeiTV
//
//  Created by Pro on 6/5/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "HBTicketListViewController.h"
#import "TicketMessage.h"
#import "HBTicketDetailViewController.h"
#import "UIView+Action.h"
#import "CustomEmptyView.h"

@interface HBTicketListViewController ()
{
    
    UIActivityIndicatorView *loadingMoreView;
    NSMutableArray * ticketMessages;
    NSInteger selectInteger;
    CustomEmptyView *customEmptyView;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation HBTicketListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    ticketMessages=[[NSMutableArray alloc]init];
    UIView * footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    loadingMoreView=[[UIActivityIndicatorView  alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
    loadingMoreView.center=CGPointMake(160, 14);
    loadingMoreView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [footView addSubview:loadingMoreView];
    self.tableView.tableFooterView=footView;
    
    [self initEmptyView];
    
    [self getWinlist];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return ticketMessages.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * reuseIdentifier=@"TicketListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary * ticketDic=[ticketMessages objectAtIndex:indexPath.row];
    NSDictionary * activityDic=[ticketDic objectForKey:@"activity"];
    NSDictionary * scrathDic=[ticketDic objectForKey:@"scrath"];
    if (![activityDic isEqual:[NSNull null]]) {
        cell.textLabel.text=@"【同城抢购】";
        cell.detailTextLabel.text=@"恭喜您在【同城抢购】中获得抢购机会，请查收您的兑奖信息";
    }
    else if (![scrathDic isEqual:[NSNull null]]) {
        cell.textLabel.text=@"【刮刮卡】";
        cell.detailTextLabel.text=@"恭喜您在【刮刮卡】中获得抢购机会，请查收您的兑奖信息";
    }
    // Configure the cell...
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectInteger=indexPath.row;
    [self performSegueWithIdentifier:@"TicketDetailPush" sender:self];
}


- (void)initEmptyView {
    
    customEmptyView = [[CustomEmptyView alloc] init];
    customEmptyView.center = self.tableView.center;
    customEmptyView.promotion = @"无相关兑奖信息!";
    customEmptyView.hidden = YES;
    [self.view addSubview:customEmptyView];
    

}



static int oldOffsetY=0;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float coffset=((scrollView.contentSize.height - scrollView.frame.size.height));
    int flag=scrollView.contentOffset.y-oldOffsetY;
    if (scrollView.contentOffset.y > coffset-30 && coffset>0 && flag>0 && !loadingMoreView.isAnimating) {
        [loadingMoreView startAnimating];
        [self getWinlist];
    }
    
    oldOffsetY=scrollView.contentOffset.y;
}

-(void)getWinlist{
    AppDelegate * app=APP;
    [app.window makeToastActivity];
    NSDictionary * paramDic=@{@"Q_userId_L_EQ":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],@"pageStart":[NSString stringWithFormat:@"%d",ticketMessages.count],@"pageSize":@"8"};
    [HBHTTPService requestGetMethod:@"ImplWinlist.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
        if (service.status==1) {
            [ticketMessages addObjectsFromArray:service.allLists];
            [self.tableView reloadData];
            
            if (ticketMessages.count == 0) {
                self.tableView.hidden = YES;
                customEmptyView.hidden = NO;
            }
            else{
                
                self.tableView.hidden = NO;
                customEmptyView.hidden = YES;
            }
        }
        [app.window hideToastActivity];
        [loadingMoreView stopAnimating];
    }andServiceFailBlock:^(void){
        [app.window hideToastActivity];
        [loadingMoreView stopAnimating];
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
    if ([[segue identifier]isEqualToString:@"TicketDetailPush"]) {
        HBTicketDetailViewController  * ticketDeatilVC=[segue destinationViewController];
        NSDictionary * ticketDic=[ticketMessages objectAtIndex:selectInteger];
        ticketDeatilVC.ticketInfoDic=ticketDic;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
