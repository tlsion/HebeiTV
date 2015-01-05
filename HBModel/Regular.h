//
//  Regular.h
//  ivmi
//
//  Created by Pro on 4/3/14.
//  Copyright (c) 2014 PartisanTroops. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Regular : NSObject
+ (BOOL)parseString:(NSString *)urlString;
+ (BOOL)checkTel:(NSString *)number;
@end
