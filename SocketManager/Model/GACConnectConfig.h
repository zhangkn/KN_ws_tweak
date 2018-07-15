#import <Foundation/Foundation.h>
@interface GACConnectConfig : NSObject
@property (nonatomic, copy) NSString *url;// ws url
/**
 */
@property (nonatomic, copy) NSString *WeChatNum;
/**
 *  socket配置
 */
@property (nonatomic, strong) NSString *token;
/**
 *  建连时的通道
 */
@property (nonatomic, strong) NSString *channels;
/**
 *  当前使用的通道
 */
@property (nonatomic, strong) NSString *currentChannel;
/**
 *  通信地址
 */
@property (nonatomic, strong) NSString *host;
/**
 *  通信端口号
 */
@property (nonatomic, assign) uint16_t port;
/**
 *  通信协议版本号
 */
@property (nonatomic, assign) NSInteger socketVersion;
@property (nonatomic, strong) id selfContact;

@end
