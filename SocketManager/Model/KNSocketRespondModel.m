//
//  KNSocketRespondModel.m
//
//  Created by devzkn on 20/06/2018.
//  Copyright © 2018 devzkn. All rights reserved.
//
#import "KNconvertHexStrToString.h"
#import "KNSocketRespondModel.h"
#import "KNConst.h"
#import "KNConstTool.h"
//响应协议
//请求数据格式为：
//其中
//event: 当前事件，如消息则为:message，必选
//type：当前事件分类，如纯文字消息为:text，可选
//data：当前事件扩展内容，用于各项事件的进一步处理，可选
@implementation KNSocketRespondModel

- (instancetype)initbyKVCWithjsonstr:(NSString *)str{
    NSDictionary *tmp = [KNconvertHexStrToString dicWithJsonstr:str];
    if (tmp) {
        return [self initWithDictionarybyKVC:tmp];
    }
    return  nil;
}
- (instancetype)initWithDictionarybysetValueforKey:(NSDictionary *)dict{
    //KVC
    self = [super init];//初始化父类属性
    if (self) {
        //初始化自身属性
        [self setValue:dict[@"event"] forKey:@"event"];
        [self setValue:dict[@"type"] forKey:@"type"];
        [self setValue:dict[@"data"] forKey:@"data"];
    }
    return self;
}
- (instancetype)initWithDictionarybyKVC:(NSDictionary *)dict{
    //KVC
    self = [super init];//初始化父类属性
    if (self) {
        //初始化自身属性
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
//
- (void)setEvent:(NSString<Optional> *)event{
    NSLog(@"setEvent %@",event);
    _event = event;
    // 方式一： 使用宏，根据对象取数组的下表
    //NSInteger knrespType = eventTypeEnum(self.event);// 实在不行就弄个工具类，不一定用数组，可以考虑使用字典
    //_respType = [NSNumber numberWithInt:knrespType];
    // 方式二： 根据key,从字段获取value
    id  tmp_event = [KNConstTool typeEnumwithevenkey:event];//nsnumber, 从字典获取value
    if(tmp_event == nil){
        _respType = [NSNumber numberWithInt:99999];// 不做处理
    }
    _respType = tmp_event;
    NSLog(@"setEvent _respType %@",_respType);
}
//- (event_TYPEenum )respType{
//    NSInteger knrespType = eventTypeEnum(self.event);
//    return  [NSNumber numberWithInt:knrespType];
//}
- (void)setType:(NSString<Optional> *)type{
    _type = type;
    
   id  tmp_respTypetype = [KNConstTool typeEnumwithtyoekey:type];
    if(tmp_respTypetype == nil){
        _respTypetype = [NSNumber numberWithInt:99999];// 不做处理
    }
    _respTypetype = tmp_respTypetype;
}

//- (type_TYPEenum)respTypetype{
//    NSInteger knrespType = typeEnum(self.type);
//    return [NSNumber numberWithInt:knrespType];
//}

-(instancetype)initWithDictionary:(NSDictionary*)json{
    NSError *jsonError = nil;

     KNSocketRespondModel *tmp = [self initWithDictionary:json error:&jsonError];
    
    
    if (jsonError) {
        //        [self.socketManager socketBeginReadData];
        NSLog(@"json 转model错误: --- error %@", jsonError);
        return nil;
    }
    NSLog(@"socket - receive model %@ data:%@ event:%@", tmp,tmp.data,tmp.event);//
    return tmp;
}

- (NSString *)description{
    return [NSString stringWithFormat:@" data:%@ event:%@ type:%@ wxid:%@  wxnick:%@",self.data,self.event,self.type,self.wxid,self.wxnick];
}
// 目前使用的方法
#pragma mark - ******** json str 转为model对象
+ (instancetype) initWithNSString:(NSString*)tmpstr{
    // 方式二
//    直接使用JSONModel的方法即可
    NSLog(@"tmpstr:%@",tmpstr);
    NSError *jsonError = nil;
    KNSocketRespondModel *kntmp =[[KNSocketRespondModel alloc]initWithString:tmpstr error:&jsonError];
    if (jsonError) {
        NSLog(@"json 转model错误: --- error %@", jsonError);
    }else{

    }
    kntmp.dataDic = [KNconvertHexStrToString dicWithJsonstr:kntmp.data];
    return kntmp;
    // 方式一
    NSDictionary *tmp = [KNconvertHexStrToString dicWithJsonstr:tmpstr];
    if (tmp) {
        
        return [self initWithDictionary:tmp];
    }
    return  nil;
}
+ (instancetype) initWithDictionary:(NSDictionary*)json{
    KNSocketRespondModel *tmp = [[KNSocketRespondModel alloc]initWithDictionary:json];
    return tmp;
}
@end
