//
//  HBScratchCardsGoodsCell.h
//  HebeiTV
//
//  Created by Pro on 5/20/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface HBScratchCardsGoodsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet EGOImageView *mainImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@end
