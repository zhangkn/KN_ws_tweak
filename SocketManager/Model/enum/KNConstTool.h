//
//  KNConstTool.h
//  weixinDylib
//
//  Created by devzkn on 05/07/2018.
//  Copyright © 2018 devzkn. All rights reserved.
//
#import <Foundation/Foundation.h>
typedef enum {
    event_TYPE_report = 0,
    event_TYPEenum_changerobot,
}event_TYPEenum;
// 子类型，有些情况不存在
typedef enum {// 保证唯一性
    type_TYPEenumtext = 0,
    type_TYPEenumimage,
    type_TYPEenumpublish,
    type_TYPEenumsend,
    type_TYPEenumcreate,
    type_TYPEenumnew_member,
}type_TYPEenum;
@interface KNConstTool : NSObject
+ (NSNumber*)typeEnumwithtyoekey:(NSString*)key;// type 子类型
+ (NSNumber*)typeEnumwithevenkey:(NSString*)key;// event  大类型
@end
