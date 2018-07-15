//
//  Const.h  ,只要引用此.h 文件，即可食用本头文件extern的全局变量//
//  Created by devzkn on 05/10/2016.
//  Copyright © 2016 hisun. All rights reserved.
// extern是计算机语言中的一个函数，可置于变量或者函数前，以表示变量或者函数的定义在别的文件中。提示编译器遇到此变量或函数时，在其它模块中寻找其定义
//声明需要全局常量，避免多处声明一样的全局常量
//
/** UIKIT_EXTERN NSNotificationName const UIKeyboardWillChangeFrameNotification  NS_AVAILABLE_IOS(5_0) __TVOS_PROHIBITED;   向系统底层API靠近
 UIKIT_EXTERN NSString *const UIKeyboardCenterBeginUserInfoKey   NS_DEPRECATED_IOS(2_0, 3_2) __TVOS_PROHIBITED;
*/
#import "GACConnectConfig.h"
#import "KNSocketRespondModel.h"
#import "HCPEnvrionmentalVariables.h"

#pragma mark - ********  ws url
extern NSString *const PRODUCTIONBaseURL ;
/** /UAT测试环境 */
extern NSString *const UATBaseURL;
#pragma mark - ******** 消息通知相关的key
//extern NSString * const kgroupsync_NOTIFYNotification;
extern NSString * const kRESPONSE_TYPENotification;
extern NSString * const kRESPONSE_TYPENotificationUserInforespTypeKey;
extern NSString * const kRESPONSE_TYPERESPONSE_TYPE_NOTIFYNotification ;
extern NSString * const kRESPONSE_TYPENotificationjsonKey ;


extern NSString * const KsetuptitleNotificationjsonKey;
