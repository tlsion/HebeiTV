//
//  HBLogAndResignViewController.h
//  HebeiTV
//
//  Created by Pro on 5/19/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBCustomerTextField.h"
@interface HBLogViewController : UIViewController
@property (strong, nonatomic) IBOutlet HBCustomerTextField *phoneNumber;
@property (strong, nonatomic) IBOutlet HBCustomerTextField *passWord;

@end
