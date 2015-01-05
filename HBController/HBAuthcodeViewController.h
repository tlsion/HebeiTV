//
//  HBAuthcodeViewController.h
//  HebeiTV
//
//  Created by 智美合 on 14-5-19.
//  Copyright (c) 2014年 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HBAuthcodeViewController : UIViewController
@property(strong,nonatomic)NSString *phone,*number,*password;
@property (strong, nonatomic) IBOutlet HBCustomerTextField *Authcode;
@end
