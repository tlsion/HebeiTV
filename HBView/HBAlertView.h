//
//  ILSMLAlertView.h
//  MoreLikers
//
//  Created by xiekw on 13-9-9.
//  Copyright (c) 2013年 谢凯伟. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef void (^TXAlertRightBlock)(void);
@interface HBAlertView : UIView

- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle;
//- (id)initWithTitle:(NSString *)title
//   contentTextPlaceholder:(NSString *)placeholder
//    leftButtonTitle:(NSString *)leftTitle
//   rightButtonTitle:(NSString *)rigthTitle;

- (id)initWithDuoDuoDouCount:(int)count
             leftButtonTitle:(NSString *)leftTitle
            rightButtonTitle:(NSString *)rigthTitle;

-(id)initWithMessage:(NSString *)message;

- (id)initWithDuoDuoDouPrompt:(NSString *)prompt
                  contentText:(NSString *)content
             leftButtonTitle:(NSString *)leftTitle
            rightButtonTitle:(NSString *)rigthTitle;

- (id)initWithImageURL:(NSURL *)url
             titleText:(NSString *)title
           contentText:(NSString *)content
       leftButtonTitle:(NSString *)leftTitle
      rightButtonTitle:(NSString *)rigthTitle;

- (void)show;

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, strong) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;
@property (nonatomic, strong) UITextField * contentTxt;

@property (nonatomic, strong) UILabel * beansTitleLabel;

@end

@interface UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end