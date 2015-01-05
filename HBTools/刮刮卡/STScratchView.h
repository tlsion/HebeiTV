//
//  STScratchView.h
//  STScratchView
//
//  Created by Sebastien Thiebaud on 12/17/12.
//  Copyright (c) 2012 Sebastien Thiebaud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@protocol STScratchViewDelegate;
@interface STScratchView : UIView
{
    CGPoint previousTouchLocation;
    CGPoint currentTouchLocation;
    
    CGImageRef hideImage;
    CGImageRef scratchImage;

	CGContextRef contextMask;
    
    BOOL isTrigger;
}

@property (nonatomic, assign) float percentAccomplishment;
@property (nonatomic, assign) float sizeBrush;
//@property (nonatomic, strong) id
@property (nonatomic, strong) UIView *hideView;
@property (nonatomic, assign) id <STScratchViewDelegate>delegate;
- (void)setHideView:(UIView *)hideView;

@end

@protocol STScratchViewDelegate <NSObject>

-(void)scratchedTrigger;

@end
