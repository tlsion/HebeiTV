//
//  BCActionSheet.h
//  cycling
//
//  Created by 智美合 on 14-3-25.
//  Copyright (c) 2014年 王庭协. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCActionSheet : UIActionSheet<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, assign) int height;
@property (nonatomic) BOOL show;

-(id)initWithViewHeight:(float)_height andIsShowNavigationBar:(BOOL)show;
-(void)docancel;
@end
