//
//  HBScratchCardsGoodsCell.m
//  HebeiTV
//
//  Created by Pro on 5/20/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "HBScratchCardsGoodsCell.h"

@implementation HBScratchCardsGoodsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.mainImageView.placeholderImage=[UIImage imageNamed:@"刮刮卡大图（例子）"];
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
