//
//  KNSocketManagerTool.h
//
//  Created by devzkn on 13/06/2018.
//  Copyright © 2018 devzkn. All rights reserved.
#import "HSSingleton.h"
#import "GACConnectConfig.h"
// 管理Socket，主要是负责 FLSocketManager 的监听，并发布对应的通知
@interface KNSocketManagerTool : NSObject
typedef void (^Close_block_t)(void);
HSSingletonH(SocketManagerTool);
/**
 初始化 socket,包含一些基本的配置信息，url ,以及一些必要的参数
 */
- (void)createSocketWithConfig:(GACConnectConfig *)config;
// 关闭之后，会执行Close_block_t
-(void)SRWebSocketClose:(Close_block_t)block;
-(void)SRWebSocketClose;
@end
