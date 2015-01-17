//
//  CustomEmptyView.m
//  PaixieMall
//
//  Created by guoliang chen on 13-3-28.
//  Copyright (c) 2013年 拍鞋网. All rights reserved.
//

#import "CustomEmptyView.h"

@implementation CustomEmptyView
@synthesize promotionlabel, promotion=_promotion;

- (id)init {
    return [self initFromNib:@"CustomEmptyView"];
}

- (id)initFromNib:(NSString *)nibName {
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:nibName
                                                   owner:self
                                                 options:nil];
    
    self = [array objectAtIndex:0];
//    [self initComponents];
    
    return self;
}

- (void)setPromotion:(NSString *)promotion {
    _promotion = promotion;
    promotionlabel.text = promotion;
}

@end
