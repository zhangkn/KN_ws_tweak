//
//  Const.m  定义const 全局常量  ,保证只在一处定义，多处进行引用
//  HWeibo
//
//  Created by devzkn on 05/10/2016.
//  Copyright © 2016 hisun. All rights reserved.
NSString *const PRODUCTIONBaseURL = @"ws://kunnan.github.io:10441/master?device=%@";
/** /UAT测试环境 */
NSString *const UATBaseURL=  @"ws://kunnan.github.io:10441/master?device=%@";
#pragma mark - ******** 消息通知相关的key
NSString * const kRESPONSE_TYPENotification = @"kRESPONSE_TYPENotification";
NSString * const kRESPONSE_TYPERESPONSE_TYPE_NOTIFYNotification = @"kRESPONSE_TYPERESPONSE_TYPE_NOTIFYNotification";
NSString * const kRESPONSE_TYPENotificationUserInforespTypeKey = @"respType";
NSString * const kRESPONSE_TYPENotificationjsonKey = @"json";
NSString * const KsetuptitleNotificationjsonKey = @"KsetuptitleNotificationjsonKey";
