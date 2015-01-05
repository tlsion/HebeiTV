//
//  ILSMLAlertView.m
//  MoreLikers
//
//  Created by xiekw on 13-9-9.
//  Copyright (c) 2013年 谢凯伟. All rights reserved.
//

#import "HBAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "EGOImageView.h"
#define kAlertWidth 240.0f
#define kAlertHeight 160.0f
#define mAlertHeight 271.5f

#define kSingleButtonWidth 160.0f
#define kCoupleButtonWidth 120.0f
#define kButtonHeight 40.0f
#define kButtonBottomOffset 0.0f
@interface HBAlertView ()
{
    BOOL _leftLeave;
    
    BOOL _isHeight;
}

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertContentLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *backImageView;@end

@implementation HBAlertView

+ (CGFloat)alertWidth
{
    return kAlertWidth;
}

+ (CGFloat)alertHeight
{
    return kAlertHeight;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define kTitleYOffset 5.0f
#define kTitleHeight 25.0f

#define kContentOffset 30.0f
#define kBetweenLabelOffset 20.0f

- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle
{
    if (self = [super init]) {
//        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"弹窗"]];
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kTitleYOffset, kAlertWidth-15, kTitleHeight)];
        self.alertTitleLabel.textAlignment = NSTextAlignmentLeft;
        self.alertTitleLabel.font = FONT_BIG;//[UIFont boldSystemFontOfSize:15.0f];
        self.alertTitleLabel.textColor = GRAY;//[UIColor colorWithRed:56.0/255.0 green:64.0/255.0 blue:71.0/255.0 alpha:1];
        self.alertTitleLabel.text=@"提示";
        self.alertTitleLabel.backgroundColor=CLEAR;
        [self addSubview:self.alertTitleLabel];
        
        CGFloat contentLabelWidth = kAlertWidth - 16;
        
        self.alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake((kAlertWidth - contentLabelWidth) * 0.5, CGRectGetMaxY(self.alertTitleLabel.frame)+10, contentLabelWidth, 60)];
        self.alertContentLabel.backgroundColor=CLEAR;
        self.alertContentLabel.numberOfLines = 0;
        self.alertContentLabel.textAlignment = NSTextAlignmentCenter;
        self.alertContentLabel.textColor = YAHEI;
        self.alertContentLabel.font = FONT_BIG;
        
        [self addSubview:self.alertContentLabel];
        
        CGRect leftBtnFrame;
        CGRect rightBtnFrame;
        if (!leftTitle) {
            rightBtnFrame = CGRectMake(0, kAlertHeight - kButtonBottomOffset - kButtonHeight, kAlertWidth, kButtonHeight);
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn.frame = rightBtnFrame;
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"弹窗底部按钮（点击效果）@2x.png"] forState:UIControlStateHighlighted];
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"弹窗底部按钮@2x.png"] forState:UIControlStateNormal];
        }else {
            leftBtnFrame = CGRectMake((kAlertWidth - 2 * kCoupleButtonWidth - kButtonBottomOffset) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + kButtonBottomOffset, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftBtn.frame = leftBtnFrame;
            self.rightBtn.frame = rightBtnFrame;
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"弹窗按钮B（按下）.png"] forState:UIControlStateHighlighted];
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"弹窗按钮B.png"] forState:UIControlStateNormal];
            [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"弹窗按钮A（按下）.png"] forState:UIControlStateHighlighted];
            [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"弹窗按钮A.png"] forState:UIControlStateNormal];
            
        }
        [self.rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.leftBtn setTitleColor:YAHEI forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
//        self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        
//        self.alertTitleLabel.text = title;
        self.alertContentLabel.text = content;
        
//        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [xButton setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
//        [xButton setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
//        xButton.frame = CGRectMake(kAlertWidth - 32, 0, 32, 32);
//        [self addSubview:xButton];
//        [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

- (id)initWithDuoDuoDouCount:(int)count leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle{
    if (self = [super init]) {
        //        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"弹窗"]];
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenTextKeyboard)];
        [self addGestureRecognizer:tap];
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kTitleYOffset, kAlertWidth-15, kTitleHeight)];
        self.alertTitleLabel.textAlignment = NSTextAlignmentLeft;
        self.alertTitleLabel.font = FONT_BIG;//[UIFont boldSystemFontOfSize:15.0f];
        self.alertTitleLabel.textColor = GRAY;
        self.alertTitleLabel.text=@"提示";
        self.alertTitleLabel.backgroundColor=CLEAR;
//        self.alertTitleLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:64.0/255.0 blue:71.0/255.0 alpha:1];
        [self addSubview:self.alertTitleLabel];
        
//        CGFloat contentLabelWidth = kAlertWidth - 16;
        
        UIImageView * duoduodouImageView=[[UIImageView alloc]initWithFrame:CGRectMake(110, 40, 28, 28)];
        duoduodouImageView.image=[UIImage imageNamed:@"多多豆图示"];
        [self addSubview:duoduodouImageView];
        
        UILabel * contentLabel1=[[UILabel alloc]initWithFrame:CGRectMake(35, 85, 80, 20)];
        contentLabel1.text=@"恭喜! 您获得了";
        contentLabel1.textColor=YAHEI;
        contentLabel1.font=FONT_BIG;
        contentLabel1.backgroundColor=CLEAR;
        [self addSubview:contentLabel1];
        
        UILabel * duoduodouCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(contentLabel1.frame), 85, 50, 20)];
        duoduodouCountLabel.text=[NSString stringWithFormat:@"%d",count];
        duoduodouCountLabel.textAlignment=NSTextAlignmentCenter;
        duoduodouCountLabel.backgroundColor=CLEAR;
        duoduodouCountLabel.textColor=[UIColor orangeColor];
        duoduodouCountLabel.font=FONTBOLD(16);
//        duoduodouCountLabel.backgroundColor=[UIColor blueColor];
        [self addSubview:duoduodouCountLabel];
        
        UILabel * contentLabel2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(duoduodouCountLabel.frame), 85, 40, 20)];
        contentLabel2.text=@"多多豆";
        contentLabel2.backgroundColor=CLEAR;
        contentLabel2.textColor=YAHEI;
        contentLabel2.font=FONT_BIG;
//        contentLabel2.backgroundColor=[UIColor yellowColor];
        [self addSubview:contentLabel2];
        
        CGRect leftBtnFrame;
        CGRect rightBtnFrame;
        
        if (!leftTitle) {
            rightBtnFrame = CGRectMake(0, kAlertHeight - kButtonBottomOffset - kButtonHeight, kAlertWidth, kButtonHeight);
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn.frame = rightBtnFrame;
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"弹窗底部按钮（点击效果）@2x.png"] forState:UIControlStateHighlighted];
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"弹窗底部按钮@2x.png"] forState:UIControlStateNormal];
        }else {
            leftBtnFrame = CGRectMake((kAlertWidth - 2 * kCoupleButtonWidth - kButtonBottomOffset) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + kButtonBottomOffset, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftBtn.frame = leftBtnFrame;
            self.rightBtn.frame = rightBtnFrame;
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"弹窗按钮B（按下）.png"] forState:UIControlStateHighlighted];
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"弹窗按钮B.png"] forState:UIControlStateNormal];
            [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"弹窗按钮A（按下）.png"] forState:UIControlStateHighlighted];
            [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"弹窗按钮A.png"] forState:UIControlStateNormal];
            
        }
        [self.rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.leftBtn setTitleColor:YAHEI forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        //        self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
        //        self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        
        //        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [xButton setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
        //        [xButton setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
        //        xButton.frame = CGRectMake(kAlertWidth - 32, 0, 32, 32);
        //        [self addSubview:xButton];
        //        [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}
-(id)initWithMessage:(NSString *)message{
    if (self = [super init]) {
        //        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"弹窗"]];
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenTextKeyboard)];
        [self addGestureRecognizer:tap];
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kTitleYOffset, kAlertWidth-15, kTitleHeight)];
        self.alertTitleLabel.textAlignment = NSTextAlignmentLeft;
        self.alertTitleLabel.font = FONT_BIG;//[UIFont boldSystemFontOfSize:15.0f];
        self.alertTitleLabel.textColor = GRAY;
        self.alertTitleLabel.text=@"提示";
        self.alertTitleLabel.backgroundColor=CLEAR;
        //        self.alertTitleLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:64.0/255.0 blue:71.0/255.0 alpha:1];
        [self addSubview:self.alertTitleLabel];
        
        self.alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.alertTitleLabel.frame)+10, 200, 60)];
        self.alertContentLabel.backgroundColor=CLEAR;
        self.alertContentLabel.numberOfLines = 0;
        self.alertContentLabel.textAlignment = NSTextAlignmentCenter;
        self.alertContentLabel.text=message;
        self.alertContentLabel.textColor = YAHEI;
        self.alertContentLabel.font = FONT_BIG;
        
        [self addSubview:self.alertContentLabel];

        
        
        //        CGFloat contentLabelWidth = kAlertWidth - 16;
        CGRect rightBtnFrame;
        rightBtnFrame = CGRectMake(0, kAlertHeight - kButtonBottomOffset - kButtonHeight, kAlertWidth, kButtonHeight);
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn.frame = rightBtnFrame;
        
        [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"弹窗底部按钮（点击效果）@2x.png"] forState:UIControlStateHighlighted];
        [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"弹窗底部按钮@2x.png"] forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rightBtn];
        
        //        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [xButton setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
        //        [xButton setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
        //        xButton.frame = CGRectMake(kAlertWidth - 32, 0, 32, 32);
        //        [self addSubview:xButton];
        //        [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}
- (id)initWithDuoDuoDouPrompt:(NSString *)prompt contentText:(NSString *)content leftButtonTitle:(NSString *)leftTitle rightButtonTitle:(NSString *)rigthTitle{
    if (self = [super init]) {
        //        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"弹窗"]];
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenTextKeyboard)];
        [self addGestureRecognizer:tap];
        self.center=CGPointMake(SCREEN_MAX_WIDTH/2, SCREEN_MAX_HEIGHT/2);
        
        
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kTitleYOffset, kAlertWidth-15, kTitleHeight)];
        self.alertTitleLabel.textAlignment = NSTextAlignmentLeft;
        self.alertTitleLabel.font = FONT_BIG;//[UIFont boldSystemFontOfSize:15.0f];
        self.alertTitleLabel.textColor = GRAY;
        self.alertTitleLabel.text=@"提示";
        self.alertTitleLabel.backgroundColor=CLEAR;
        //        self.alertTitleLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:64.0/255.0 blue:71.0/255.0 alpha:1];
        [self addSubview:self.alertTitleLabel];
        
        //        CGFloat contentLabelWidth = kAlertWidth - 16;
        
        UIImageView * duoduodouImageView=[[UIImageView alloc]initWithFrame:CGRectMake(80, kTitleYOffset+20, 28, 28)];
        duoduodouImageView.image=[UIImage imageNamed:@"多多豆图示"];
        [self addSubview:duoduodouImageView];
        
        _beansTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(duoduodouImageView.frame)+10, CGRectGetMinY(duoduodouImageView.frame)+4, 100, 20)];
        _beansTitleLabel.text=prompt;
        _beansTitleLabel.textColor=YAHEI;
        _beansTitleLabel.font=FONT_BIG;
        _beansTitleLabel.backgroundColor=CLEAR;
        [self addSubview:_beansTitleLabel];
        
        self.alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(duoduodouImageView.frame)+5, 200, 48)];
        self.alertContentLabel.backgroundColor=CLEAR;
        self.alertContentLabel.numberOfLines = 0;
        self.alertContentLabel.textAlignment = NSTextAlignmentCenter;
        self.alertContentLabel.textColor = YAHEI;
        self.alertContentLabel.font = FONT_BIG;
        self.alertContentLabel.text=content;
        [self addSubview:self.alertContentLabel];
        
        
        CGRect leftBtnFrame;
        CGRect rightBtnFrame;
        
        if (!leftTitle) {
            rightBtnFrame = CGRectMake(0, kAlertHeight - kButtonBottomOffset - kButtonHeight, kAlertWidth, kButtonHeight);
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn.frame = rightBtnFrame;
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"弹窗底部按钮（点击效果）@2x.png"] forState:UIControlStateHighlighted];
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"弹窗底部按钮@2x.png"] forState:UIControlStateNormal];
        }else {
            leftBtnFrame = CGRectMake((kAlertWidth - 2 * kCoupleButtonWidth - kButtonBottomOffset) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + kButtonBottomOffset, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftBtn.frame = leftBtnFrame;
            self.rightBtn.frame = rightBtnFrame;
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"弹窗按钮B（按下）.png"] forState:UIControlStateHighlighted];
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"弹窗按钮B.png"] forState:UIControlStateNormal];
            [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"弹窗按钮A（按下）.png"] forState:UIControlStateHighlighted];
            [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"弹窗按钮A.png"] forState:UIControlStateNormal];
            
        }
        [self.rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.leftBtn setTitleColor:YAHEI forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        //        self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
        //        self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        
        //        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [xButton setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
        //        [xButton setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
        //        xButton.frame = CGRectMake(kAlertWidth - 32, 0, 32, 32);
        //        [self addSubview:xButton];
        //        [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}
- (id)initWithImageURL:(NSURL *)url
             titleText:(NSString *)title
           contentText:(NSString *)content
       leftButtonTitle:(NSString *)leftTitle
      rightButtonTitle:(NSString *)rigthTitle{
    if (self = [super init]) {
        _isHeight=YES;
        
        //        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"弹窗底（上下圆角）.png"]];
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenTextKeyboard)];
        [self addGestureRecognizer:tap];
        self.alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kTitleYOffset, kAlertWidth-15, kTitleHeight)];
        self.alertTitleLabel.textAlignment = NSTextAlignmentLeft;
        self.alertTitleLabel.font = FONT_BIG;//[UIFont boldSystemFontOfSize:15.0f];
        self.alertTitleLabel.textColor = GRAY;
        self.alertTitleLabel.text=@"提示";
        self.alertTitleLabel.backgroundColor=CLEAR;
        //        self.alertTitleLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:64.0/255.0 blue:71.0/255.0 alpha:1];
        [self addSubview:self.alertTitleLabel];
        
        //        CGFloat contentLabelWidth = kAlertWidth - 16;
        
        EGOImageView * duoduodouImageView=[[EGOImageView alloc]initWithFrame:CGRectMake(70, kTitleYOffset+20, 100, 100)];
//        duoduodouImageView.image=[UIImage imageNamed:@"例图1B"];
        duoduodouImageView.imageURL=url;
        [self addSubview:duoduodouImageView];
        
        UILabel * contentLabel1=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(duoduodouImageView.frame)+5, 200, 40)];
        contentLabel1.text=title;
        contentLabel1.numberOfLines=0;
        contentLabel1.textAlignment=NSTextAlignmentCenter;
        contentLabel1.textColor=YAHEI;
        contentLabel1.font=[UIFont boldSystemFontOfSize:14];
        contentLabel1.backgroundColor=CLEAR;
        [self addSubview:contentLabel1];
        
        self.alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(contentLabel1.frame), 200, 48)];
        self.alertContentLabel.backgroundColor=CLEAR;
        self.alertContentLabel.numberOfLines = 0;
        self.alertContentLabel.textAlignment = NSTextAlignmentCenter;
        self.alertContentLabel.textColor = YAHEI;
        self.alertContentLabel.font = FONT_BIG;
        self.alertContentLabel.text=content;
        [self addSubview:self.alertContentLabel];
        
        
        CGRect leftBtnFrame;
        CGRect rightBtnFrame;
        
        if (!leftTitle) {
            rightBtnFrame = CGRectMake(0, mAlertHeight - kButtonBottomOffset - kButtonHeight, kAlertWidth, kButtonHeight);
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn.frame = rightBtnFrame;
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"弹窗底部按钮（点击效果）@2x.png"] forState:UIControlStateHighlighted];
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"弹窗底部按钮@2x.png"] forState:UIControlStateNormal];
        }else {
            leftBtnFrame = CGRectMake((kAlertWidth - 2 * kCoupleButtonWidth - kButtonBottomOffset) * 0.5, mAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + kButtonBottomOffset, mAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.leftBtn.frame = leftBtnFrame;
            self.rightBtn.frame = rightBtnFrame;
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"弹窗按钮B（按下）.png"] forState:UIControlStateHighlighted];
            [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"弹窗按钮B.png"] forState:UIControlStateNormal];
            [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"弹窗按钮A（按下）.png"] forState:UIControlStateHighlighted];
            [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"弹窗按钮A.png"] forState:UIControlStateNormal];
            
        }
        [self.rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        [self.leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        self.leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.leftBtn setTitleColor:YAHEI forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        //        self.leftBtn.layer.masksToBounds = self.rightBtn.layer.masksToBounds = YES;
        //        self.leftBtn.layer.cornerRadius = self.rightBtn.layer.cornerRadius = 3.0;
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        
        //        UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [xButton setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
        //        [xButton setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
        //        xButton.frame = CGRectMake(kAlertWidth - 32, 0, 32, 32);
        //        [self addSubview:xButton];
        //        [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

-(void)hiddenTextKeyboard{
    [self.contentTxt resignFirstResponder];
}
- (void)leftBtnClicked:(id)sender
{
    _leftLeave = YES;
    [self dismissAlert];
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)rightBtnClicked:(id)sender
{
    _leftLeave = NO;
    [self dismissAlert];
    if (self.rightBlock) {
        self.rightBlock();
    }
}

- (void)show
{
    UIViewController *topVC = [self appRootViewController];
//    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, - kAlertHeight - 30, kAlertWidth, kAlertHeight);
    self.frame =  CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, CGRectGetHeight(topVC.view.bounds), kAlertWidth, _isHeight?mAlertHeight:kAlertHeight);
    [topVC.view addSubview:self];
}

- (void)dismissAlert
{
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview
{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    [self appRootViewController];
//    UIViewController *topVC = [self appRootViewController];
//    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, CGRectGetHeight(topVC.view.bounds), kAlertWidth, kAlertHeight);
//    [UIView animateWithDuration:0.1 animations:^{
//        self.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.15 animations:^{
//            self.layer.transform = CATransform3DIdentity;
//            self.alpha = 0.0f;
//        } completion:^(BOOL finished) {
//            [super removeFromSuperview];
//            [self cleanup];
//            if (completion)
//                completion();
//        }];
//    }];
    [UIView animateWithDuration:1.0/7.5 animations:^{
		self.transform = CGAffineTransformMakeScale(0.9, 0.9);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:1.0/15.0 animations:^{
			self.transform = CGAffineTransformMakeScale(1.1, 1.1);
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:0.3 animations:^{
				self.transform = CGAffineTransformMakeScale(0.01, 0.01);
                self.alpha = 0.0f;
			} completion:^(BOOL finished){
//                [self cleanup];
				// table alert not shown anymore
//				[self removeFromSuperview];
			}];
		}];
	}];
//    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.frame = afterFrame;
////        if (_leftLeave) {
////            self.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
////        }else {
////            self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
////        }
//    } completion:^(BOOL finished) {
//        [super removeFromSuperview];
//    }];
}
- (void)cleanup {
	self.layer.transform = CATransform3DIdentity;
	self.transform = CGAffineTransformIdentity;
	self.alpha = 0.0f;
//	self.window = nil;
	// rekey main AppDelegate window
	[[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];

    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.6f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    [topVC.view addSubview:self.backImageView];
//    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - (_isHeight?mAlertHeight:kAlertHeight)) * 0.5, kAlertWidth, _isHeight?mAlertHeight:kAlertHeight);
    
    self.frame = afterFrame;
//    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
////        self.transform = CGAffineTransformMakeRotation(0);
//        self.frame = afterFrame;
//    } completion:^(BOOL finished) {
//    }];
    self.transform = CGAffineTransformMakeScale(0.6, 0.6);
	[UIView animateWithDuration:0.2 animations:^{
		self.transform = CGAffineTransformMakeScale(1.1, 1.1);
	} completion:^(BOOL finished){
		[UIView animateWithDuration:1.0/15.0 animations:^{
			self.transform = CGAffineTransformMakeScale(0.9, 0.9);
		} completion:^(BOOL finished){
			[UIView animateWithDuration:1.0/7.5 animations:^{
				self.transform = CGAffineTransformIdentity;
			}];
		}];
	}];
    
//    [UIView animateWithDuration:0.17 animations:^{
//        self.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1.0);
//        self.alpha = 1.0f;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.12 animations:^{
//            self.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1.0);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.1 animations:^{
//                self.layer.transform = CATransform3DIdentity;
//            } completion:^(BOOL finished) {
//                
//                //                if (completion)
//                //                    completion();
//            }];
//        }];
//    }];

    [super willMoveToSuperview:newSuperview];
}

@end

@implementation UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
//    return [UIImage imageNamed:@"弹窗.png"];
}

@end
