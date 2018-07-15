#import "KNNotificationTool.h"
/**
 *
 *  socket状态
 */
typedef NS_ENUM(NSInteger,FLSocketStatus){
    FLSocketStatusConnected = 222222,// 已连接
    FLSocketStatusFailed,// 失败
    FLSocketStatusClosedByServer,// 系统关闭
    FLSocketStatusClosedByUser,// 用户关闭
    FLSocketStatusReceived// 接收消息
};
/**
 *
 *  消息类型
 */
typedef NS_ENUM(NSInteger,FLSocketReceiveType){
    FLSocketReceiveTypeForMessage,
    FLSocketReceiveTypeForPong
};
/**
 *
 *  连接成功回调
 */
typedef void(^FLSocketDidConnectBlock)();
/**
 *
 *  失败回调
 */
typedef void(^FLSocketDidFailBlock)(NSError *error);
/**
 *
 *  关闭回调
 */
typedef void(^FLSocketDidCloseBlock)(NSInteger code,NSString *reason,BOOL wasClean);
/**
 *
 *  消息接收回调
 */
typedef void(^FLSocketDidReceiveBlock)(id message ,FLSocketReceiveType type);

@interface FLSocketManager : NSObject
/**
 *
 *  连接回调
 */
@property (nonatomic,copy)FLSocketDidConnectBlock connect;
/**
 *
 *  接收消息回调
 */
@property (nonatomic,copy)FLSocketDidReceiveBlock receive;
/**
 *
 *  失败回调
 */
@property (nonatomic,copy)FLSocketDidFailBlock failure;
/**
 *
 *  关闭回调
 */
@property (nonatomic,copy)FLSocketDidCloseBlock close;
/**
 *
 *  当前的socket状态
 */
@property (nonatomic,assign,readonly)FLSocketStatus fl_socketStatus;
/**
 *
 *  超时重连时间，默认1秒
 */
@property (nonatomic,assign)NSTimeInterval overtime;
/**
 *
 *  重连次数,默认5次
 */
@property (nonatomic, assign)NSUInteger reconnectCount;
/**
 *
 *  单例调用
 */
+ (instancetype)shareManager;
/**
 *
 *  开启socket
 *
 *  @param urlStr  服务器地址
 *  @param connect 连接成功回调
 *  @param receive 接收消息回调
 *  @param failure 失败回调
 */
- (void)fl_open:(NSString *)urlStr connect:(FLSocketDidConnectBlock)connect receive:(FLSocketDidReceiveBlock)receive failure:(FLSocketDidFailBlock)failure;
/**
 *
 *  关闭socket
 *
 *  @param close 关闭回调
 */
- (void)fl_close:(FLSocketDidCloseBlock)close;
/**
 *
 *  发送消息，NSString 或者 NSData
 *
 *  @param data Send a UTF8 String or Data.
 */
- (void)fl_send:(id)data;
//  只是简单的用于维持心跳
- (void)fl_sendping:(id)data;
@end
