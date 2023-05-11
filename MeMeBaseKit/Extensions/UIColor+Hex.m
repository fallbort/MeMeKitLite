//
//  UIColor+Hex.m
//  imoffice
//
//  Created by zhanghao on 14-9-11.
//  Copyright (c) 2014年 IMO. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (nullable UIColor *)hexStringToColor:(NSString *)stringToConvert {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    if ([cString length] < 6)
        return nil;
    
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    if (!([cString length] == 6 ||[cString length] == 8))
        return nil;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = @"";
    NSString *gString = @"";
    NSString *bString = @"";
    NSString *aString = @"";
    
    if ([cString length] == 6) {
        rString = [cString substringWithRange:range];
        range.location = 2;
        
        gString = [cString substringWithRange:range];
        range.location = 4;
        
        bString = [cString substringWithRange:range];
    }else{
        aString = [cString substringWithRange:range];
        range.location = 2;
        
        rString = [cString substringWithRange:range];
        range.location = 4;
        
        gString = [cString substringWithRange:range];
        range.location = 6;
        
        bString = [cString substringWithRange:range];
    }
    
    

    unsigned int r, g, b,a;
    
    BOOL ret = [[NSScanner scannerWithString:rString] scanHexInt:&r];
    if(ret == false) {return nil;}
    ret = [[NSScanner scannerWithString:gString] scanHexInt:&g];
    if(ret == false) {return nil;}
    ret = [[NSScanner scannerWithString:bString] scanHexInt:&b];
    if(ret == false) {return nil;}
    if ([cString length] == 6) {
        return [UIColor colorWithRed:((float) r / 255.0f)
        green:((float) g / 255.0f)
         blue:((float) b / 255.0f)
        alpha:1.0f];
    }else{
        ret = [[NSScanner scannerWithString:aString] scanHexInt:&a];
        if(ret == false) {return nil;}
        return [UIColor colorWithRed:((float) r / 255.0f)
        green:((float) g / 255.0f)
         blue:((float) b / 255.0f)
        alpha:a/255.0f];
    }
}

+ (UIColor *)colorWithHexNumber:(NSUInteger)hexColor {
    float r = ((hexColor>>16) & 0xFF) / 255.0f;
    float g = ((hexColor>>8) & 0xFF) / 255.0f;
    float b = (hexColor & 0xFF) / 255.0f;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
}

@end
