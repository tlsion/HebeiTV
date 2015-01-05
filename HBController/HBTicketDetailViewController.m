//
//  HBTicketDetailViewController.m
//  HebeiTV
//
//  Created by Pro on 6/5/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "HBTicketDetailViewController.h"
#import "EGOImageView.h"
@interface HBTicketDetailViewController ()
{
    IBOutlet UIScrollView *mainScrollView;
    
    IBOutlet UILabel *explainLabel;

    IBOutlet UILabel *VoucherCodeLabel;
    IBOutlet UIView *scartchCardBgView;

    IBOutlet EGOImageView *scartchImageView;
    IBOutlet UIView *panicBuyingBgView;
    
    IBOutlet EGOImageView *panicBuyingImageView;
    
    IBOutlet UILabel *panicBuyingNameLabel;
    
    IBOutlet UILabel *panicBuyingPriceLabel;
    
    IBOutlet UILabel *originPriceLabel;
    
    IBOutlet UILabel *explainLTitleLabel;
    IBOutlet UITextView *htmlTextView;
    
    IBOutlet UIView *htmlShowBgView;
}
@end

@implementation HBTicketDetailViewController

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
    mainScrollView.frame=CGRectMake(0, 0, SCREEN_MAX_WIDTH, SCREEN_MAX_HEIGHT-NAV_HEI_64);
    [self updateTicketDetailInfoDic:self.ticketInfoDic];
}
-(void)updateTicketDetailInfoDic:(NSDictionary *)ticketDic{
    NSDictionary * activityDic=[ticketDic objectForKey:@"activity"];
    NSDictionary * scrathDic=[ticketDic objectForKey:@"scrath"];
    VoucherCodeLabel.text=[ticketDic objectForKey:@"code"];
    if (![activityDic isEqual:[NSNull null]]) {
        scartchCardBgView.hidden=YES;
        explainLabel.text=@"恭喜您在【同城抢购】中获得抢购机会，请查收您的抢购凭证码，您可以使用该凭证码到置顶地点购买特价商品。";
        NSString * imageUrl=[NSString stringWithFormat:@"%@",[activityDic objectForKey:@"image"]];
        panicBuyingImageView.imageURL=IMG_URL(imageUrl);
        panicBuyingNameLabel.text=[NSString stringWithFormat:@"%@",[activityDic objectForKey:@"activityName"]];
        panicBuyingPriceLabel.text=[NSString stringWithFormat:@"抢购价 ￥%.2f",[[activityDic objectForKey:@"price"]floatValue]];
        originPriceLabel.text=[NSString stringWithFormat:@"原价 ￥%.2f",[[activityDic objectForKey:@"costPrice"]floatValue]];
        
        
        explainLTitleLabel.text=@"抢购说明";
        NSString * htmlString=[NSString stringWithFormat:@"%@",[activityDic objectForKey:@"content"]];
        //    NSString *htmlString = @"<h1>Header</h1><h2>Subheader</h2><p>Some <em>text</em></p><img src='http://blogs.babble.com/famecrawler/files/2010/11/mickey_mouse-1097.jpg' width=70 height=100 />";
        
        if (SystemVersion<7) {
            NSRange range;
            while ((range = [htmlString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
                htmlString=[htmlString stringByReplacingCharactersInRange:range withString:@""];
            }
            htmlTextView.text=htmlString;
        }
        else{
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            htmlTextView.attributedText = attributedString;
        }
        
    }
    else if (![scrathDic isEqual:[NSNull null]]) {
        panicBuyingBgView.hidden=YES;
        explainLabel.text=@"恭喜您在【刮刮卡】活动中获得幸运奖品一份!\n您可以是哦那个该凭证码到置顶地点领取奖品；\n活动方保留一切解释权。";
        NSString * imageUrl=[NSString stringWithFormat:@"%@",[scrathDic objectForKey:@"image"]];
        scartchImageView.imageURL=IMG_URL(imageUrl);
        
        
        explainLTitleLabel.text=@"兑奖说明";
        NSString * htmlString=[NSString stringWithFormat:@"%@",[scrathDic objectForKey:@"content"]];
        //    NSString *htmlString = @"<h1>Header</h1><h2>Subheader</h2><p>Some <em>text</em></p><img src='http://blogs.babble.com/famecrawler/files/2010/11/mickey_mouse-1097.jpg' width=70 height=100 />";
        
        if (SystemVersion<7) {
            NSRange range;
            while ((range = [htmlString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
                htmlString=[htmlString stringByReplacingCharactersInRange:range withString:@""];
            }
            htmlTextView.text=htmlString;
        }
        else{
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            htmlTextView.attributedText = attributedString;
        }
        
    }
     [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setHtmlTextViewContentSize) userInfo:nil repeats:NO];
}
-(void)setHtmlTextViewContentSize{
    CGRect nFrame=htmlTextView.frame;
    nFrame.size.height=htmlTextView.contentSize.height;
    htmlTextView.frame=nFrame;
    
    CGRect htmlBgFrame=htmlShowBgView.frame;
    htmlBgFrame.origin.y=CGRectGetMaxY(scartchCardBgView.hidden?panicBuyingBgView.frame:scartchCardBgView.frame)+8;
    htmlBgFrame.size.height=nFrame.size.height+50;
    htmlShowBgView.frame=htmlBgFrame;
    
    mainScrollView.contentSize=CGSizeMake(SCREEN_MAX_WIDTH, CGRectGetMaxY(htmlShowBgView.frame)+8);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
