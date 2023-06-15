//
//  NSString+Data.m
//  MeMe
//
//  Created by admin on 2019/11/19.
//  Copyright © 2019 sip. All rights reserved.
//

#import "NSArray+Data.h"

@implementation NSArray (data)
-(NSString*)toJsonString:(NSJSONWritingOptions)opt {
    NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:opt error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;

}

@end
