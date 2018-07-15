//
//  KNNotificationTool.m
//  2018wxrobot
//
//  Created by devzkn on 20/06/2018.
//  Copyright © 2018 devzkn. All rights reserved.
//

#import "KNNotificationTool.h"

@implementation KNNotificationTool



+ (void)setupKsetuptitleNotificationjsonKey:(id)tilte{
    NSMutableDictionary * userInfo = [NSMutableDictionary dictionaryWithObject:tilte forKey:kRESPONSE_TYPENotificationjsonKey];//respType 传送json
    [[NSNotificationCenter defaultCenter] postNotificationName:KsetuptitleNotificationjsonKey object:self userInfo:userInfo];
}

@end
