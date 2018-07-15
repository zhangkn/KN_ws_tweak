//
//  KNConst.h
//  2018wxrobot
//
//  Created by devzkn on 20/06/2018.
//  Copyright © 2018 devzkn. All rights reserved.
//
//响应协议 暂时废弃
#import <Foundation/Foundation.h>
const NSArray *_knevent_TYPE;
// 创建初始化函数。等于用宏创建一个getter函数
#define NetworkTypeGet (_knevent_TYPE == nil ? _knevent_TYPE = [[NSArray alloc] initWithObjects:\
@"message",\
@"timeline",\
@"hongbao",\
@"payment",@"group",@"wxapp",\
@"user_profile",\
@"friend",\
@"env",\
nil] : _knevent_TYPE)
// 枚举 to 字串
#define eventTypeString(type) ([NetworkTypeGet objectAtIndex:type])
// 字串 to 枚举
#define eventTypeEnum(string) ([NetworkTypeGet indexOfObject:string])
