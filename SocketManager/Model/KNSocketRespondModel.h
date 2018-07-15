//
//  KNSocketRespondModel.h
//  2018wxrobot
//
//  Created by devzkn on 20/06/2018.
//  Copyright © 2018 devzkn. All rights reserved.
//
#import <JSONModel/JSONModel.h>
#import <Foundation/Foundation.h>
@interface KNSocketRespondModel : JSONModel
//响应协议
//请求数据格式为：
//其中
//event: 当前事件，如消息则为:message，必选
//type：当前事件分类，如纯文字消息为:text，可选
//data：当前事件扩展内容，用于各项事件的进一步处理，可选
@property (nonatomic, copy) NSString<Optional> *wxid;
@property (nonatomic, copy) NSString<Optional> *wxnick;
@property (nonatomic, copy) NSString<Optional> *event;
@property (nonatomic, strong) NSString<Optional> *data;
@property (nonatomic, strong) NSDictionary<Optional> *dataDic;
//@property (nonatomic, copy) NSString<Optional> *data;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, assign) NSNumber<Optional> *respType;// 对应event的枚举
@property (nonatomic, assign) NSNumber<Optional> *respTypetype;
-(instancetype)initWithDictionary:(NSDictionary*)dict;
+ (instancetype) initWithNSString:(NSString*)tmpstr;
- (instancetype)initbyKVCWithjsonstr:(NSString *)str;
@end
