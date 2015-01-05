//
//  HBBannerDetailViewController.m
//  HebeiTV
//
//  Created by 智美合 on 14-5-30.
//  Copyright (c) 2014年 MyOrganization. All rights reserved.
//

#import "HBBannerDetailViewController.h"

@interface HBBannerDetailViewController ()
{
    float  viewHeight;
    NSMutableDictionary *mutableAttributes;
}
@property (strong, nonatomic) IBOutlet UIImageView *BannerImageView;
@property (strong, nonatomic)  UIWebView *BannerDetailText;
@property (strong, nonatomic) IBOutlet UIScrollView *mainscrollView;
@end

@implementation HBBannerDetailViewController

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
    
    self.title=@"详情";
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7)
    {
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    
    self.BannerImageView.image=[UIImage imageNamed:@"左右滑动广告B"];
    
    NSString *content=@"hshhhsh误工费把什么阿布啊放假哈歌词van没回擦vajbmca时间和吃饭噶阿布擦汗时聚餐呢血债血偿V字 阿娇深VCAE聚餐吧技术工程部拿出VBS保存数据财政部吧就急急急急急急急急急急急急急急急急急急哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈将建军节建军节快快快快快快快快哈哈哈哈哈哈发反反复复\r\n反反复复反反复复天天天天天天天天天天天天天灌灌灌灌灌刚刚回家看看看还不回家看看他预计哈哈哈jdjijjj计算机接口接口接口将建军节建军节斤斤计较将建军节建军节舅舅家看空间看见就看hh见jkhsfbesgukhfjsdbcmjjj看到数据库哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈急急急急急急急急急将建军节建军节和哈哈哈哈哈哈哈哈哈哈哈看见就看见看见就几节课解决哈哈哈哈哈哈快女才放假吗看美j女";
    
    viewHeight=[self getDetailHightWithString:content];
    self.BannerDetailText.userInteractionEnabled = YES;
    self.BannerDetailText=[[UIWebView alloc]initWithFrame:CGRectMake(20, 250, 280, viewHeight)];
    self.BannerDetailText.backgroundColor=[UIColor clearColor];
    NSString *str = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    NSString *webviewText = @"<style>body{margin:0;background-color:transparent;font:14px/30px Custom-Font-Name}</style>";
    NSString * str2=[webviewText stringByAppendingFormat:@"%@",str];
    [self.BannerDetailText loadHTMLString:str2 baseURL:nil];
    [self webViewDetailnewsHight:self.BannerDetailText];
    self.BannerDetailText.scrollView.showsVerticalScrollIndicator=NO;
    self.BannerDetailText.userInteractionEnabled=NO;
    
    [self.mainscrollView addSubview:self.BannerDetailText];
    
//    self.BannerDetailText.font=FONTBOLD(14);
//    [self.BannerDetailText setNumberOfLines:0];
//    [self.BannerDetailText sizeToFit];
//    self.BannerDetailText.lineBreakMode = NSLineBreakByWordWrapping;
//    [self.mainscrollView addSubview:self.BannerDetailText];
//    self.BannerDetailText.text=content;
    
//    UIFont *font = [UIFont systemFontOfSize:14];
//    CGSize size = CGSizeMake(280,200000);
//    CGSize labelsize = [content sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
//    self.BannerDetailText.frame = CGRectMake(self.BannerDetailText.frame.origin.x, self.BannerDetailText.frame.origin.y, labelsize.width, labelsize.height );
//    lableHeight=labelsize.height;
    
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

    self.mainscrollView.contentSize=CGSizeMake(320, 250+viewHeight);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDetailnewsHight:(UIWebView *)webView
{
    
    if (webView.subviews.count > 0)
    {
        UIView *scrollerView = [webView.subviews objectAtIndex:0];//为什么要取第一个？
        if (scrollerView.subviews.count > 0)
        {
            UIView *webDocView = scrollerView.subviews.lastObject;
            if ([webDocView isKindOfClass:[NSClassFromString(@"UIWebDocumentView") class]])
            {
                float height = webDocView.frame.size.height;//获取文档的高度
                
                //webView.frame= webDocView.frame; //更新UIWebView 的高度
                self.BannerDetailText.frame=CGRectMake(20, 250, 280, height);
                
                self.mainscrollView.contentSize=CGSizeMake(320, 250+height);
            }
        }
    }
}

//获取详细信息的高度。
-(CGFloat)getDetailHightWithString:(NSString*)str
{
    int words=[self textLength:str];
    
    int row=[self calculateRowsByWords:words];
    
    return 30*row;
    
}

//计算行数
-(int)calculateRowsByWords:(int)words
{
    float remainder=words%20;
    int dealer=words/20;
    if (remainder!=0) {
        dealer=dealer+1;
    }
    return dealer;
}

//计算字符串的长度
- (int)textLength:(NSString *)text//计算字符串长度
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            number++;
        }
        else
        {
            number = number + 0.5;
        }
    }
    return ceil(number);
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
