//
//  SJAvatarBrowser.m
//  zhitu
//
//  Created by 陈少杰 on 13-11-1.
//  Copyright (c) 2013年 聆创科技有限公司. All rights reserved.
//

static CGRect oldframe;
static UIWindow * window;
static UIImageView *imageView;
static UIView *backgroundView;
static UILabel * _prizeNameLabel;
#import "SJAvatarBrowser.h"
@implementation SJAvatarBrowser
-(void)showImage:(UIImageView *)avatarImageView andPrizeName:(NSString *)prizeName andDelegate:(id)delegate{
    
    CGFloat imageWidth=160 * 1.5;
    CGFloat imageHeight=280 * 1.5;
    UIImage *image=[UIImage imageNamed:@"刮刮卡(带字)"];
    window=[UIApplication sharedApplication].keyWindow;
    backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    
    
    [window addSubview:backgroundView];
    imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.userInteractionEnabled=YES;
    imageView.image=image;
    imageView.tag=1;
    [window addSubview:imageView];
    
//    UILabel * _dollarsAmount=[[UILabel alloc]initWithFrame:CGRectMake(100, 330, 120, 40)];
//    
//    [_dollarsAmount setText:@"谢谢参与"];
//    [imageView addSubview:_dollarsAmount];
    
//    STScratchView * _scratchView=[[STScratchView alloc]initWithFrame:CGRectMake(10, imageHeight-63, imageWidth-20, 50)];
//    
//    [_scratchView setSizeBrush:50.0];
//    [imageView addSubview:_scratchView];
//    // Create a (child) UIView
//    UIImageView *ball = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(_scratchView.frame), CGRectGetHeight(_scratchView.frame))];
////    [ball setImage:[UIImage imageNamed:@"灰条.png"]];
//    ball.backgroundColor=GRAY;
//    // Define the hide view
//    [_scratchView setHideView:ball];
    
    // Edit randomly the UILabel
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(SCREEN_MAX_WIDTH/2-imageWidth/2, SCREEN_MAX_HEIGHT/2-imageHeight/2, imageWidth, imageHeight);
        backgroundView.alpha=0.7;
        
        
    } completion:^(BOOL finished) {
        imageView.image=[UIImage imageNamed:@"刮刮卡"];
        CGRect dallFrame=CGRectMake(15, imageHeight-61, imageWidth-30, 47);
        _prizeNameLabel=[[UILabel alloc]initWithFrame:dallFrame];
        _prizeNameLabel.textAlignment=NSTextAlignmentCenter;
        _prizeNameLabel.textColor=YAHEI;
        _prizeNameLabel.font=FONTBOLD(20);
        if (prizeName) {
            [_prizeNameLabel setText:prizeName];
        }else{
            [_prizeNameLabel setText:@"谢谢参与"];
        }
        [imageView addSubview:_prizeNameLabel];
        
        STScratchView * _scratchView=[[STScratchView alloc]initWithFrame:dallFrame];
        _scratchView.delegate = delegate;
        [_scratchView setSizeBrush:50.0];
        [imageView addSubview:_scratchView];
        // Create a (child) UIView
        UIImageView *ball = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(_scratchView.frame), CGRectGetHeight(_scratchView.frame))];
        [ball setImage:[UIImage imageNamed:@"灰条(带字).png"]];
//        ball.backgroundColor=[UIColor yellowColor];
        
//        ball.backgroundColor=[UIColor blueColor];
        // Define the hide view
        [_scratchView setHideView:ball];
        
        
        UITapGestureRecognizer *hiddenTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
        [window addGestureRecognizer: hiddenTap];

        
    }];
//    UIView * removeBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(imageView.frame), CGRectGetHeight(imageView.frame)-60)];
//    
//    removeBgView.backgroundColor=[UIColor yellowColor];
//    removeBgView.alpha=0.5;
//    [window addSubview:removeBgView];
}
-(void)removeAllView{
    imageView.image=[UIImage imageNamed:@"刮刮卡(带字)"];
    for (UIView * subView in imageView.subviews) {
        [subView removeFromSuperview];
    }
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        [imageView removeFromSuperview];
//        [tap.view removeGestureRecognizer:tap];
//        [tap.view removeFromSuperview];
    }];

}
-(void)hideImage:(UITapGestureRecognizer*)tap{
//    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
//    imageView.image=[UIImage imageNamed:@"刮刮卡(带字)"];
//    for (UIView * subView in imageView.subviews) {
//        [subView removeFromSuperview];
//    }
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        [imageView removeFromSuperview];
//        [window removeGestureRecognizer:tap];
//        [tap.view removeFromSuperview];
    }];
}
@end
