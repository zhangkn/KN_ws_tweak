//
//  KNConstTool.m
//  weixinDylib
//
//  Created by devzkn on 05/07/2018.
//  Copyright © 2018 devzkn. All rights reserved.
//

#import "KNConstTool.h"

@implementation KNConstTool

+(void)load
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        // initialize all class static objects,
        // which are common for ALL JSONModel subclasses
      
        _objdic = [NSMutableDictionary dictionary];
        _objdic[@"text"] = @0;
        _objdic[@"image"] = @1;
        _objdic[@"publish"] = @2;
        _objdic[@"send"] = @3;
        _objdic[@"create"] = @4;
        _objdic[@"new_member"] = @5;
        //2、event 事件 字符串枚举值的设置
        _eventobjdic = [NSMutableDictionary dictionary];
        _eventobjdic[@"report"] = @0;
        _objdic[@"changerobot"] = @1;
        //ping
        // 获取硬件信息
    });
    
}
// 字符串key对应的int 型value
static NSMutableDictionary *_objdic ;// 子类型 是预留变量
static NSMutableDictionary *_eventobjdic ;
+ (NSNumber*)typeEnumwithtyoekey:(NSString*)key{
    if (key) {
        return _objdic[key];
    }
    return nil;
}
+ (NSNumber*)typeEnumwithevenkey:(NSString*)key{
    if (key) {
        return _eventobjdic[key];
    }
    return nil;
}
@end
