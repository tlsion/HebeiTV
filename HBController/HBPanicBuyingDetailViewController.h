//
//  HBPanicBuyingDetailViewController.h
//  HebeiTV
//
//  Created by Pro on 6/4/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBPanicBuyingViewController.h"
@interface HBPanicBuyingDetailViewController : UIViewController
@property (copy,nonatomic) NSString * activityId;
@property (nonatomic,strong) HBPanicBuyingViewController * delegate;
@end
