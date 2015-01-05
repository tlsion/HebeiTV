//
//  HBHomeAdCell.h
//  HebeiTV
//
//  Created by Pro on 5/14/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface HBHomeAdCell : UITableViewCell
@property (strong, nonatomic) IBOutlet EGOImageView *mainImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end
