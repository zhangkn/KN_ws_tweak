
//
#import <JSONModel/JSONModel.h>
//请求协议的模型
@interface GACSocketModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *fromwxid;
@property (nonatomic, copy) NSString<Optional> *fromwxnick;
@property (nonatomic, copy) NSString<Optional> *event;
@property (nonatomic, copy) NSDictionary<Optional> *data;
@property (nonatomic, copy) NSString<Optional> *type;
@property (nonatomic, copy) NSString<Optional> *wxid;
@property (nonatomic, copy) NSString<Optional> *wxnick;
/**
 *  当前登录的微信ID
 */
@property (nonatomic, copy) NSString<Optional> *WeChatNum;
/**
 *  根据时间戳生成的socket唯一请求ID
 */
@property (nonatomic, strong) NSString<Optional> *reqId;
/**
 *  socket通道，支持单通道，多通道
 */
@property (nonatomic, strong) NSString<Optional> *requestChannel;
/**
 *  socket请求体
 */
@property (nonatomic, strong) NSDictionary<Optional> *body;
/**
 *  使用该方法对body对象进行两次转JSONString处理，如无body，请使用toJSONString方法直接转JSONString
 */
- (NSString *)socketModelToJSONString;
+ (NSString*)stringByReplacingOccurrencesOfString:(NSString*)jsonString;
@end
