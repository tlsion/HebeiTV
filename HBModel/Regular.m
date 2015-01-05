//
//  Regular.m
//  ivmi
//
//  Created by Pro on 4/3/14.
//  Copyright (c) 2014 PartisanTroops. All rights reserved.
//

#import "Regular.h"

@implementation Regular
+(BOOL)parseString:(NSString *)urlString
{
    
    //组装一个字符串，需要把里面的网址解析出来
    
    
    //NSRegularExpression类里面调用表达的方法需要传递一个NSError的参数。下面定义一个
    
    NSError *error;
    
    //http+:[^\\s]* 这个表达式是检测一个网址的。
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http+:[^\\s]*" options:0 error:&error];
    
    if (regex != nil) {
        
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
        
        if (firstMatch) {
            
//            NSRange resultRange = [firstMatch rangeAtIndex:0]; //等同于 firstMatch.range --- 相匹配的范围
            
            //从urlString当中截取数据
            
//            NSString *result=[urlString substringWithRange:resultRange];
            
            //输出结果
            
            return YES;
        }
        else{
            return NO;
        }
        
        
        
    }
    else{
        return NO;
    }
    
}
+ (BOOL)checkTel:(NSString *)number
{
    NSString *phoneRegex = @"^((13[0-9])|(17[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:number];

}
@end
