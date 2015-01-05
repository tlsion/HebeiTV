//
//  BCActionSheet.m
//  cycling
//
//  Created by 智美合 on 14-3-25.
//  Copyright (c) 2014年 王庭协. All rights reserved.
//

#import "BCActionSheet.h"

@implementation BCActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
    }
    return self;
}
-(id)initWithViewHeight:(float)height andIsShowNavigationBar:(BOOL)show{
    self = [super init];
    if (self) {
        self.height=height;
        self.show=show;
        self.customView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_MAX_HEIGHT-NAV_HEI_64-height, 320, height)];
    }
    
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.show) {
        UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, SCREEN_MAX_HEIGHT - self.height -40-NAV_HEI_64-1, 320, 40)];
        navBar.barStyle = UIBarStyleDefault;
        navBar.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"大按钮.png"]];
        navBar.tintColor=YAHEI;
        UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"分享"];
        
        UIButton * cancleButton=[UIButton buttonWithType:UIButtonTypeCustom];
        cancleButton.frame=CGRectMake(0, 0, 60, 40);
        [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancleButton setTitleColor:YAHEI forState:UIControlStateNormal];
        [cancleButton addTarget:self action:@selector(docancel) forControlEvents:UIControlEventTouchUpInside];
        cancleButton.titleLabel.font=[UIFont boldSystemFontOfSize:16];
        cancleButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:cancleButton];
        navItem.rightBarButtonItem = rightButton;
        NSArray *array = [[NSArray alloc] initWithObjects:navItem, nil];
        [navBar setItems:array];
        
        [self.superview addSubview:navBar];
    }
    
    [self.superview addSubview:self.customView];
}

- (void) docancel{
    [self dismissWithClickedButtonIndex:1 animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
