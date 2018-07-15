%group sbHook
NSTimer *launchApplicationWithIdentifiertimer;
NSTimer *timer2 ;

// 考虑新增一个先关闭，再连接的方法
GACConnectConfig *_connectConfig;

%hook SpringBoard
//applicationDidFinishLaunching
-(void)applicationDidFinishLaunching: (id)application
{
    %orig;
    
    // 设置环境变量
    //[HCPEnvrionmentalVariables shareEnvrionmentalVariables].envrionmentalVariables = ENVRIONMENTAL_VARIABLES_PRODUCTION;
    [HCPEnvrionmentalVariables shareEnvrionmentalVariables].envrionmentalVariables = ENVRIONMENTAL_VARIABLES_UAT;

    
    //timer = [NSTimer scheduledTimerWithTimeInterval:60*2 target:self selector:@selector(checkHeart) userInfo:nil repeats:YES];
    launchApplicationWithIdentifiertimer = [NSTimer timerWithTimeInterval:60*2 target:self selector:@selector(checkHeart) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:launchApplicationWithIdentifiertimer forMode:NSRunLoopCommonModes];
    
    // 异步
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [%c(SpringBoard) savewxsandboxPath];//    // save 特定app的sandboxPath 到特定目录
    });
    
    
    // 建立长连接
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [%c(SpringBoard) setupwsConnect];//
    });
    
}
#pragma mark - ******** 建立长连接
%new
+ (void)setupwsConnect{
    %log;
    //1、 获取硬件参数 imei 设备号
    id device = @"359245061994628";
    //2、调用方法直接连接
switch ([FLSocketManager shareManager].fl_socketStatus) {
        case FLSocketStatusConnected:
        case FLSocketStatusReceived:{
            
            NSLog(@"已经存在连接");
            return;
        }
    default:
    {
    }
        break;
}
    [%c(SpringBoard) setup_connectConfig:[HCPEnvrionmentalVariables getdefaultbaseurl] device:device];

}
%new
+ (void)setup_connectConfig:(NSString*)url device:device{
    %log;
    _connectConfig = [[GACConnectConfig alloc] init];
    _connectConfig.WeChatNum = device;
    // 设置wsurl
    _connectConfig.url = [HCPEnvrionmentalVariables getbaseurl:url wxid:_connectConfig.WeChatNum];// 支持动态切换环境
    // 1.自定义配置连接环境
    [[KNSocketManagerTool shareSocketManagerTool] createSocketWithConfig:_connectConfig];
}
//

// 获取特定app的沙盒路径，以com.tencent.xin 为例子，仅供学习参考
%new
+ (void)savewxsandboxPath{
    NSString *tmpfile = @"/var/root/wxsandboxPath.txt";
    NSString *contentUserIDURL =  [%c(SpringBoard) getsandboxPathWithBundleIdentifier:@"com.tencent.xin"];
    NSData *data = [contentUserIDURL dataUsingEncoding: NSUTF8StringEncoding];
    //写到目标文件
    [data writeToFile:tmpfile atomically:YES];//覆盖
}

%new
//获取 sandboxPath
+ (NSString*) getsandboxPathWithBundleIdentifier:(NSString*)bid{
    SBApplicationController *sbApplicationCtrl=[%c(SBApplicationController) sharedInstance];
    id app = [sbApplicationCtrl applicationWithBundleIdentifier:bid];
    NSString *contentUserIDURL =  [app sandboxPath];
    return contentUserIDURL;
}
%new
- (void)checkHeart
{
    dispatch_main_async_safe(^{
        //定时检测 wx app 是否开启
        [[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.tencent.xin" suspended:0];
    });
}
%end
// 自动解锁
//qutolock ios10 没有生效，也许是没有SBLockScreenViewController，，进一步确认SBLockScreenManager
%hook SBLockScreenViewController
-(void)activate{
    %orig;
    %log;
    [[%c(SBLockScreenManager) sharedInstance] unlockUIFromSource:0 withOptions:nil];
}
%end
%end

//# 必须放置于最后，否则找不到对应的group
//plist { Filter = { Bundles = ( "com.tencent.xin","com.apple.springboard","com.apple.Preferences"); }; }
%ctor
{
    //test code
if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"WeChat"]){
//%init(wxHook);

//%init(jbHook);
//%init(safeHook);
//%init(switchToUserLogin)
    
}

if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"SpringBoard"]){
%init(sbHook);
//setupKNKNeventHandlerlog();// 初始化不同用途的block代码，主要是自动让弹框消息
}

// 新增自动登录appleID的tweak，以便下载app
if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"Preferences"]){//设置
//%init(preHook);
}
}
