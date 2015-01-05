//
//  HomeAdView.h
//  Aite
//
//  Created by EDITOR on 13-11-8.
//  Copyright (c) 2013年 王庭协. All rights reserved.
//

#define BannerHeight 123
#define BannerCount 3
#define BannerTimer 5
#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
@interface HBBannerView : UIView
@property (strong,nonatomic) EGOImageButton * bannerBtn;
@property (strong,nonatomic) NSDictionary * bannerDic;

@end
