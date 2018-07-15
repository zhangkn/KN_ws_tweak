//
//  KNSocketManagerTool.m
//  Created by devzkn on 13/06/2018.
//  Copyright © 2018 devzkn. All rights reserved.
//
#import <objc/message.h>
#import "KNSocketManagerTool.h"
//#import "FLSocketManager.h"
//#import "CContactMgr.h"
@interface KNSocketManagerTool ()
// 包含ws 连接的URL请求参数
@property (nonatomic, strong, nonnull) GACConnectConfig *connectConfig;//
@end
NSTimer * heartBeat;// 心跳时钟
NSTimer * firstconnecTimer;// 暂时空缺，缺省，用于扩张，处理定时任务
NSTimer * firstconnecTimerforfriend;// 目前是预留时钟
@implementation KNSocketManagerTool
HSSingletonM(SocketManagerTool);
#pragma mark - socket actions，包含消息
//使用通知去实现，只需要在一个控制器or KNSocketManagerTool（通常也是单利的对象）去做监听，然后发通知，其他控制器监听这个通知就行，这样就可以实现整个项目多个控制器都能同时监听socket改变
- (void)createSocketWithConfig:(nonnull GACConnectConfig *)config {
    
    if (!config.url.length || !config.WeChatNum.length ) {
        HBLogDebug(@"SocketManagerTool缺少基本的连接参数:%@",config);//
        return;
    }
    self.connectConfig = config;
//    self.socketAuthAppraisalChannel = config.channels;
//    [GCKeyChainManager sharedInstance].token = config.token;
//    [self.socketManager changeHost:config.host port:config.port];
//    PROTOCOL_VERSION = config.socketVersion;
//    _WeChatNum = config.WeChatNum;
//    selfCContact = config.selfContact;
    
//    [self.socketManager connectSocketWithDelegate:self];
    
    NSString *url = config.url;
    //发通知，其他控制器监听这个通知就行，这样就可以实现整个项目多个控制器都能同时监听socket改变
    
    HBLogDebug(@"正在尝试连接：%@",url);
    [KNNotificationTool setupKsetuptitleNotificationjsonKey:@"正在尝试连接"];
    __weak __typeof__(self) weakSelf = self;
    [[FLSocketManager shareManager] fl_open:url connect:^{
        NSLog(@"SocketManagerTool成功连接");
        [KNNotificationTool setupKsetuptitleNotificationjsonKey:@"成功连接"];
        // 维持心跳
        [weakSelf initHeartBeat];
        // 进行群信息同步，创建一个定时器
        [weakSelf setupfirstconnecTimer];
        [weakSelf firstconnecTimerforfriend];//firstconnecTimerforfriend

        
    } receive:^(id message, FLSocketReceiveType type) {
        if (type == FLSocketReceiveTypeForMessage) {
            NSLog(@"SocketManagerTool接收 类型1--%@",message);
            
            // 发布通知，给其他监听者处理
            KNSocketRespondModel *tmp = [KNSocketRespondModel initWithNSString:message];
            if (tmp) {
                
                //NSMutableDictionary * userInfo = [NSMutableDictionary dictionaryWithObject:json forKey:kRESPONSE_TYPENotificationjsonKey];//respType 传送json
                NSMutableDictionary * userInfo = [NSMutableDictionary dictionaryWithObject:tmp forKey:kRESPONSE_TYPENotificationjsonKey];//respType 传送json
                [[NSNotificationCenter defaultCenter] postNotificationName:kRESPONSE_TYPERESPONSE_TYPE_NOTIFYNotification object:self userInfo:userInfo];
            }
            
            
        }
        else if (type == FLSocketReceiveTypeForPong){
            NSLog(@"SocketManagerTool接收 类型2FLSocketReceiveTypeForPong--message：%@",message);
            [KNNotificationTool setupKsetuptitleNotificationjsonKey:@"成功连接"];
        }
    } failure:^(NSError *error) {// Error Domain=com.squareup.SocketRocket Code=504 "Timeout Connecting to Server" UserInfo=0x18607f10 {NSLocalizedDescription=Timeout Connecting to Server}  有可能是Wi-Fi没有内外权限；Closed Reason:Stream end encountered  code = 1001 10001 的时候，有可能没加白名单。
        
        NSLog(@"SocketManagerTool连接失败: %@",error);
    }];
}
-(void)sentheart{
    //发送心跳 和后台可以约定发送什么内容  一般可以调用ping  我这里根据后台的要求 发送了data给他
//    [self sendData:@"heart"];
    //{ "event":"ping"}
    
//    fl_sendping
    [[FLSocketManager shareManager] fl_sendping:nil];
}
//初始化心跳
- (void)initHeartBeat
{
    __weak __typeof__(self) weakSelf = self;
    dispatch_main_async_safe(^{
        [weakSelf destoryHeartBeat];
//        通过心跳机制来确保客户端与服务端的在线检测，客户端每30秒发送一次心跳数据，如客户端未接到服务端响应的心跳数据则需要客户端重新建立连接。
        //心跳设置为3分钟，NAT超时一般为5分钟
        heartBeat = [NSTimer timerWithTimeInterval:30 target:weakSelf selector:@selector(sentheart) userInfo:nil repeats:YES];
        //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
        [[NSRunLoop currentRunLoop] addTimer:heartBeat forMode:NSRunLoopCommonModes];
    });
}
// ios 准备用于定时清理数据
- (void)firstconnecTimerforfriend
{
    __weak __typeof__(self) weakSelf = self;
    
    dispatch_main_async_safe(^{
        [weakSelf destoryfirstconnecTimerforfriend];
        //  30 分钟一次
        firstconnecTimerforfriend = [NSTimer timerWithTimeInterval:60*30 target:weakSelf selector:@selector(sentgfriendInfo) userInfo:nil repeats:YES];
        //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
        [[NSRunLoop currentRunLoop] addTimer:firstconnecTimerforfriend forMode:NSRunLoopCommonModes];
        //  先执行一次
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10*6*2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //// 定时清理聊天记录
            [weakSelf clearLocalData];
        });
        
    });
}

- (void)clearLocalData{
    return;
    //[objc_getClass("WCNewStorageUsageViewController") cleanCacheAndclearLocalData];
}
// ios 侧的群同步机制：1、每建立一次ws连接，立即同步一次，后续使用定时器1天同步一次；2、如果有group info的响应协议，也会进行同步￼
- (void)setupfirstconnecTimer
{
    __weak __typeof__(self) weakSelf = self;

    dispatch_main_async_safe(^{
        [weakSelf destoryfirstconnecTimer];
        // 1 天一次 ，60 = 1 分 60*60 = 1H   60*60*24= 24h
        firstconnecTimer = [NSTimer timerWithTimeInterval:60*60*24 target:weakSelf selector:@selector(sentgroupInfo) userInfo:nil repeats:YES];
        //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
        [[NSRunLoop currentRunLoop] addTimer:firstconnecTimer forMode:NSRunLoopCommonModes];
        //  先执行一次
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf sentgroupInfo];// 可以放到setupfirstconnecTimer 之前执行，保证至少执行一次
        });
        
    });
}
- (void)sentgfriendInfo{
    return;
   // [objc_getClass("CContactMgr") setupfriendsyncdata];
}

- (void)sentgroupInfo{
    // 发送通知给tweak 进行信息同步
    return;
   // [objc_getClass("FTSContactMgr") setupgroupsyncdata];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60*1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sentgfriendInfo];// 可以放到setupfirstconnecTimer 之前执行，保证至少执行一次
    });
}
//取消destoryfirstconnecTimer
- (void)destoryfirstconnecTimerforfriend
{
    dispatch_main_async_safe(^{
        if (firstconnecTimerforfriend) {
            if ([firstconnecTimerforfriend respondsToSelector:@selector(isValid)]){
                if ([firstconnecTimerforfriend isValid]){
                    [firstconnecTimerforfriend invalidate];
                    firstconnecTimerforfriend = nil;
                }
            }
        }
    });
}
//取消destoryfirstconnecTimer
- (void)destoryfirstconnecTimer
{
    dispatch_main_async_safe(^{
        if (firstconnecTimer) {
            if ([firstconnecTimer respondsToSelector:@selector(isValid)]){
                if ([firstconnecTimer isValid]){
                    [firstconnecTimer invalidate];
                    firstconnecTimer = nil;
                }
            }
        }
    });
}


//取消心跳
- (void)destoryHeartBeat
{
    dispatch_main_async_safe(^{
        if (heartBeat) {
            if ([heartBeat respondsToSelector:@selector(isValid)]){
                if ([heartBeat isValid]){
                    [heartBeat invalidate];
                    heartBeat = nil;
                }
            }
        }
    });
}
-(void)SRWebSocketClose{
    __weak __typeof__(self) weakSelf = self;
    [[FLSocketManager shareManager] fl_close:^(NSInteger code, NSString *reason, BOOL wasClean) {
        NSLog(@"code = %zd,reason = %@",code,reason);//1005 手动关闭
        [weakSelf destoryHeartBeat];
    }];
}
-(void)SRWebSocketClose:(Close_block_t)block{
    NSLog(@" 手动关闭");
    __weak __typeof__(self) weakSelf = self;
    [[FLSocketManager shareManager] fl_close:^(NSInteger code, NSString *reason, BOOL wasClean) {
        NSLog(@"code = %zd,reason = %@",code,reason);//1005 手动关闭
        [weakSelf destoryHeartBeat];
        if (block) {
            block();
        }
    }];
}
@end
