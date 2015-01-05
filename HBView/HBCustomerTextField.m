//
//  HBCustomerTextField.m
//  HebeiTV
//
//  Created by Pro on 5/19/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "HBCustomerTextField.h"

@implementation HBCustomerTextField
{
    UILabel * leftLabel;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        leftLabel.font=FONT_BIG;
        leftLabel.textAlignment=NSTextAlignmentCenter;
        leftLabel.backgroundColor=CLEAR;
        self.leftView=leftLabel;
        self.leftViewMode=3;
        
        
        self.backgroundColor=[UIColor whiteColor];
        self.borderStyle=0;
        self.font=FONT_BIG;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        leftLabel.font=FONT_BIG;
        leftLabel.backgroundColor=CLEAR;
        self.leftView=leftLabel;
        self.leftViewMode=3;
        
        
        self.backgroundColor=[UIColor clearColor];
        self.borderStyle=0;
        self.font=FONT_BIG;
    }
    return self;
}
-(void)setTextTitle:(NSString *)textTitle{
    if (textTitle) {
        leftLabel.text=[NSString stringWithFormat:@"%@:",textTitle];
        leftLabel.frame=CGRectMake(0, 0, textTitle.length*12+30, 40);
    }
}
//- (CGRect)editingRectForBounds:(CGRect)bounds
//{
//    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7)
//    {
//        bounds.origin.x=bounds.origin.x+24;
//        return bounds;
//        
//    }
//    else{
//        return CGRectMake(24, 2, 175, 20);
//    }
//}
//- (CGRect)textRectForBounds:(CGRect)bounds
//{
//    return CGRectMake(CGRectGetMaxX(leftLabel.frame), 2, CGRectGetWidth(self.frame)-CGRectGetMaxX(leftLabel.frame), 20);
////    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7)
////    {
////        bounds.origin.x=bounds.origin.x+24;
////        return bounds;
////    }
////    else{
////        return CGRectMake(CGRectGetMaxX(leftLabel.frame), 2, CGRectGetWidth(self.frame)-CGRectGetMaxX(leftLabel.frame), 20);
////    }
//}
//- (CGRect)placeholderRectForBounds:(CGRect)bounds
//{
//    return CGRectMake(CGRectGetMaxX(leftLabel.frame), 2, CGRectGetWidth(self.frame)-CGRectGetMaxX(leftLabel.frame), 20);
////    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7)
////    {
////        bounds.origin.x=bounds.origin.x+24;
////        
////        return bounds;
////    }
////    else{
////        return CGRectMake(24, 2, 175, 20);
////    }
//    
//}
////- (CGRect)rightViewRectForBounds:(CGRect)bounds
////{
////    return CGRectMake(196, 0, 24, 24);
////}
//-(CGRect)leftViewRectForBounds:(CGRect)bounds
//{
//    return CGRectMake(0, 0, CGRectGetWidth(leftLabel.frame), CGRectGetHeight(leftLabel.frame));
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
