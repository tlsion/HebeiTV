//
//  HBHomeAdCell.m
//  HebeiTV
//
//  Created by Pro on 5/14/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "HBHomeAdCell.h"

@implementation HBHomeAdCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _mainImageView.backgroundColor=YAHEI;
        _mainImageView.userInteractionEnabled=YES;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
