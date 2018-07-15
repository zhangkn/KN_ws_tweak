
#import "FLSocketManager.h"
#import "SRWebSocket.h"
@interface FLSocketManager ()<SRWebSocketDelegate>
@property (nonatomic,strong)SRWebSocket *webSocket;

@property (nonatomic,assign)FLSocketStatus fl_socketStatus;
@property (nonatomic,weak)NSTimer *timer;

@property (nonatomic,copy)NSString *urlString;
@end
@implementation FLSocketManager{
    NSInteger _reconnectCounter;
}
+ (instancetype)shareManager{
    static FLSocketManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.overtime = 1;//超时重连的时间,等待优化，默认1秒,
        instance.reconnectCount = 5;//重连次数,默认5次
    });
    return instance;
}
- (void)fl_open:(NSString *)urlStr connect:(FLSocketDidConnectBlock)connect receive:(FLSocketDidReceiveBlock)receive failure:(FLSocketDidFailBlock)failure{
    [FLSocketManager shareManager].connect = connect;
    [FLSocketManager shareManager].receive = receive;
    [FLSocketManager shareManager].failure = failure;
    [self fl_open:urlStr];
}
- (void)fl_close:(FLSocketDidCloseBlock)close{
    [FLSocketManager shareManager].close = close;
    [self fl_close];
}
// Send a UTF8 String or Data. 通知外围
- (void)fl_send:(id)data{
    NSLog(@"准备发送。。。data：%@",data);
    switch ([FLSocketManager shareManager].fl_socketStatus) {
        case FLSocketStatusConnected:
        case FLSocketStatusReceived:{
            NSLog(@"发送data：%@ \n中",data);
            [self.webSocket send:data];
            break;
        }
        case FLSocketStatusFailed:
            NSLog(@"发送失败");
            [self setuponcereconnect];// 重新连接一次
            break;
        case FLSocketStatusClosedByServer:
            NSLog(@"已经关闭");
            [self setuponcereconnect];// 重新连接一次
            break;
        case FLSocketStatusClosedByUser:
            NSLog(@"已经关闭");
            [self setuponcereconnect];// 重新连接一次
            break;
    }
    
}
- (void)fl_sendping:(id)data{
    switch ([FLSocketManager shareManager].fl_socketStatus) {
        case FLSocketStatusConnected:
        case FLSocketStatusReceived:{
            NSLog(@"发送中。。。");
            [self.webSocket sendPing:data];
            break;
        }
        case FLSocketStatusFailed:
            NSLog(@"发送失败");
            // 重新发送
            //[self.webSocket sendPing:data];
            break;
        case FLSocketStatusClosedByServer:
            NSLog(@"已经关闭");
            // 重新连接
            break;
        case FLSocketStatusClosedByUser:
            NSLog(@"已经关闭");
            // 重新连接
            break;
    }
}
#pragma mark -- private method   延迟执行，根据连接的次数，进行延迟
- (void)fl_open:(id)params{
//    NSLog(@"params = %@",params);
    NSString *urlStr = nil;
    if ([params isKindOfClass:[NSString class]]) {
        urlStr = (NSString *)params;
        NSLog(@"立即执行");
        [self setupfl_open:urlStr];
    }
    else if([params isKindOfClass:[NSTimer class]]){
        NSTimer *timer = (NSTimer *)params;
        urlStr = [timer userInfo];
        // 延迟执行
        NSLog(@"延迟执行");
        __weak __typeof__(self) weakSelf = self;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((self.overtime *3) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf setupfl_open:urlStr];
        });
    }
}
- (void)setupfl_open:(NSString*)urlStr{
    [KNNotificationTool setupKsetuptitleNotificationjsonKey:@"重新连接中"];//  到时候需要在tweak中监听处理，显示当前的ws 连接状态
    [FLSocketManager shareManager].urlString = urlStr;
    [self.webSocket close];
    self.webSocket.delegate = nil;
    
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    self.webSocket.delegate = self;
    [self.webSocket open];
    
}
- (void)fl_close{
    
    [self.webSocket close];
    self.webSocket = nil;
    [self.timer invalidate];
    self.timer = nil;
    // 开启成功后重置重连计数器
    _reconnectCounter = 0;
}
- (void)setuponcereconnect{
    NSLog(@"self.urlString %@",self.urlString);
    [self fl_open:self.urlString];
}

//开始新一轮的重新机制
- (void)setupnewfl_reconnect{
    
    [self fl_close];
    // 延迟执行
    
    __weak __typeof__(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((20 *3) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf fl_reconnect];
    });
}
- (void)fl_reconnect{
    // 计数+1
    if (_reconnectCounter < self.reconnectCount - 1) {
        _reconnectCounter ++;
        // 开启定时器
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.overtime target:self selector:@selector(fl_open:) userInfo:self.urlString repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
    else{
        NSLog(@"Websocket Reconnected Outnumber ReconnectCount");
        // 修改导航栏标题
        
        [KNNotificationTool setupKsetuptitleNotificationjsonKey:@"连接失败"];
        // 弹框提示用户
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        // 开启新的一轮重连接
        [self setupnewfl_reconnect];
        return;
    }
    
}
#pragma mark -- SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"Websocket Connected");
    
    [FLSocketManager shareManager].connect ? [FLSocketManager shareManager].connect() : nil;
    [FLSocketManager shareManager].fl_socketStatus = FLSocketStatusConnected;
    // 开启成功后重置重连计数器
    _reconnectCounter = 0;
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@":( Websocket Failed With Error %@", error);
    [FLSocketManager shareManager].fl_socketStatus = FLSocketStatusFailed;
    [FLSocketManager shareManager].failure ? [FLSocketManager shareManager].failure(error) : nil;
    // 重连
    [self fl_reconnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@":( Websocket Receive With message %@", message);
    [FLSocketManager shareManager].fl_socketStatus = FLSocketStatusReceived;
    [FLSocketManager shareManager].receive ? [FLSocketManager shareManager].receive(message,FLSocketReceiveTypeForMessage) : nil;
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"Closed Reason:%@  code = %zd",reason,code);//1005 手动关闭
    //1001表示端点“离开”（going away），例如服务器关闭或浏览器导航到其他页面。---通常是服务端主动把流关闭了。
    if (reason) {
        [FLSocketManager shareManager].fl_socketStatus = FLSocketStatusClosedByServer;
        // 重连
        [self fl_reconnect];
    }
    else{
        [FLSocketManager shareManager].fl_socketStatus = FLSocketStatusClosedByUser;
    }
    [FLSocketManager shareManager].close ? [FLSocketManager shareManager].close(code,reason,wasClean) : nil;// 执行失败回调
    self.webSocket = nil;
}
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    [FLSocketManager shareManager].receive ? [FLSocketManager shareManager].receive(pongPayload,FLSocketReceiveTypeForPong) : nil;
    NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    NSLog(@"reply===%@",reply);
}
- (void)dealloc{
    // Close WebSocket
    [self fl_close];
}
@end
