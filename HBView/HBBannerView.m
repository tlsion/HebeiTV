//
//  HomeAdView.m
//  Aite
//
//  Created by EDITOR on 13-11-8.
//  Copyright (c) 2013年 王庭协. All rights reserved.
//

#import "HBBannerView.h"

@implementation HBBannerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _bannerBtn=[[EGOImageButton alloc]initWithFrame:CGRectMake(0, 0, 320, BannerHeight)];
        _bannerBtn.placeholderImage=[UIImage imageNamed:@"置顶广告图"];
//            [_adBtn addTarget:self action:@selector(enterAdStoreDetail:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bannerBtn];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
