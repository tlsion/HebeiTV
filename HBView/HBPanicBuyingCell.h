//
//  HBPanicBuyingCell.h
//  HebeiTV
//
//  Created by Pro on 5/27/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface HBPanicBuyingCell : UITableViewCell
@property (strong, nonatomic) IBOutlet EGOImageView *mainImageView;
@property (strong, nonatomic) IBOutlet UILabel *mainTitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *countPromptLabel;

@property (strong, nonatomic) IBOutlet UILabel *panicPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *OriginalPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *promptLabel;

@end
