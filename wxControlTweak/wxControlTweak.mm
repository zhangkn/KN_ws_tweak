#line 1 "/Users/devzkn/code/tweak/knwx2018/wxControlTweak/wxControlTweak/wxControlTweak.xm"

#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SBLockScreenViewController; @class SpringBoard; @class SBApplicationController; @class SBLockScreenManager; 

static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SpringBoard(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SpringBoard"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SBApplicationController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBApplicationController"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SBLockScreenManager(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBLockScreenManager"); } return _klass; }
#line 1 "/Users/devzkn/code/tweak/knwx2018/wxControlTweak/wxControlTweak/wxControlTweak.xm"
static void (*_logos_orig$sbHook$SpringBoard$applicationDidFinishLaunching$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$sbHook$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_meta_method$sbHook$SpringBoard$setupwsConnect(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static void _logos_meta_method$sbHook$SpringBoard$setup_connectConfig$device$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*, id); static void _logos_meta_method$sbHook$SpringBoard$savewxsandboxPath(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL); static NSString* _logos_meta_method$sbHook$SpringBoard$getsandboxPathWithBundleIdentifier$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST, SEL, NSString*); static void _logos_method$sbHook$SpringBoard$checkHeart(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$sbHook$SBLockScreenViewController$activate)(_LOGOS_SELF_TYPE_NORMAL SBLockScreenViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$sbHook$SBLockScreenViewController$activate(_LOGOS_SELF_TYPE_NORMAL SBLockScreenViewController* _LOGOS_SELF_CONST, SEL); 
NSTimer *launchApplicationWithIdentifiertimer;
NSTimer *timer2 ;


GACConnectConfig *_connectConfig;




static void _logos_method$sbHook$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id application) {
    _logos_orig$sbHook$SpringBoard$applicationDidFinishLaunching$(self, _cmd, application);
    
    
    
    [HCPEnvrionmentalVariables shareEnvrionmentalVariables].envrionmentalVariables = ENVRIONMENTAL_VARIABLES_UAT;

    
    
    launchApplicationWithIdentifiertimer = [NSTimer timerWithTimeInterval:60*2 target:self selector:@selector(checkHeart) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:launchApplicationWithIdentifiertimer forMode:NSRunLoopCommonModes];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_logos_static_class_lookup$SpringBoard() savewxsandboxPath];
    });
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_logos_static_class_lookup$SpringBoard() setupwsConnect];
    });
    
}
#pragma mark - ******** 建立长连接

static void _logos_meta_method$sbHook$SpringBoard$setupwsConnect(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    HBLogDebug(@"+[<SpringBoard: %p> setupwsConnect]", self);
    
    id device = @"359245061994628";
    
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
    [_logos_static_class_lookup$SpringBoard() setup_connectConfig:[HCPEnvrionmentalVariables getdefaultbaseurl] device:device];

}

static void _logos_meta_method$sbHook$SpringBoard$setup_connectConfig$device$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* url, id device){
    HBLogDebug(@"+[<SpringBoard: %p> setup_connectConfig:%@ device:%@]", self, url, device);
    _connectConfig = [[GACConnectConfig alloc] init];
    _connectConfig.WeChatNum = device;
    
    _connectConfig.url = [HCPEnvrionmentalVariables getbaseurl:url wxid:_connectConfig.WeChatNum];
    
    [[KNSocketManagerTool shareSocketManagerTool] createSocketWithConfig:_connectConfig];
}




static void _logos_meta_method$sbHook$SpringBoard$savewxsandboxPath(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    NSString *tmpfile = @"/var/root/wxsandboxPath.txt";
    NSString *contentUserIDURL =  [_logos_static_class_lookup$SpringBoard() getsandboxPathWithBundleIdentifier:@"com.tencent.xin"];
    NSData *data = [contentUserIDURL dataUsingEncoding: NSUTF8StringEncoding];
    
    [data writeToFile:tmpfile atomically:YES];
}



static NSString* _logos_meta_method$sbHook$SpringBoard$getsandboxPathWithBundleIdentifier$(_LOGOS_SELF_TYPE_NORMAL Class _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString* bid){
    SBApplicationController *sbApplicationCtrl=[_logos_static_class_lookup$SBApplicationController() sharedInstance];
    id app = [sbApplicationCtrl applicationWithBundleIdentifier:bid];
    NSString *contentUserIDURL =  [app sandboxPath];
    return contentUserIDURL;
}


static void _logos_method$sbHook$SpringBoard$checkHeart(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    dispatch_main_async_safe(^{
        
        [[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.tencent.xin" suspended:0];
    });
}




static void _logos_method$sbHook$SBLockScreenViewController$activate(_LOGOS_SELF_TYPE_NORMAL SBLockScreenViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    _logos_orig$sbHook$SBLockScreenViewController$activate(self, _cmd);
    HBLogDebug(@"-[<SBLockScreenViewController: %p> activate]", self);
    [[_logos_static_class_lookup$SBLockScreenManager() sharedInstance] unlockUIFromSource:0 withOptions:nil];
}





static __attribute__((constructor)) void _logosLocalCtor_a3c65c29(int __unused argc, char __unused **argv, char __unused **envp)
{
    
if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"WeChat"]){





    
}

if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"SpringBoard"]){
{Class _logos_class$sbHook$SpringBoard = objc_getClass("SpringBoard"); Class _logos_metaclass$sbHook$SpringBoard = object_getClass(_logos_class$sbHook$SpringBoard); MSHookMessageEx(_logos_class$sbHook$SpringBoard, @selector(applicationDidFinishLaunching:), (IMP)&_logos_method$sbHook$SpringBoard$applicationDidFinishLaunching$, (IMP*)&_logos_orig$sbHook$SpringBoard$applicationDidFinishLaunching$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_metaclass$sbHook$SpringBoard, @selector(setupwsConnect), (IMP)&_logos_meta_method$sbHook$SpringBoard$setupwsConnect, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_metaclass$sbHook$SpringBoard, @selector(setup_connectConfig:device:), (IMP)&_logos_meta_method$sbHook$SpringBoard$setup_connectConfig$device$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_metaclass$sbHook$SpringBoard, @selector(savewxsandboxPath), (IMP)&_logos_meta_method$sbHook$SpringBoard$savewxsandboxPath, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_metaclass$sbHook$SpringBoard, @selector(getsandboxPathWithBundleIdentifier:), (IMP)&_logos_meta_method$sbHook$SpringBoard$getsandboxPathWithBundleIdentifier$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$sbHook$SpringBoard, @selector(checkHeart), (IMP)&_logos_method$sbHook$SpringBoard$checkHeart, _typeEncoding); }Class _logos_class$sbHook$SBLockScreenViewController = objc_getClass("SBLockScreenViewController"); MSHookMessageEx(_logos_class$sbHook$SBLockScreenViewController, @selector(activate), (IMP)&_logos_method$sbHook$SBLockScreenViewController$activate, (IMP*)&_logos_orig$sbHook$SBLockScreenViewController$activate);}

}


if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"Preferences"]){

}
}
