#import "GACSocketModel.h"
@implementation GACSocketModel
- (NSString *)socketModelToJSONString {
    NSAssert(self.data != nil, @"Argument must be non-nil");
    if (![self.data isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSString *bodyString = [self dictionnaryObjectToString:self.data];
    self.data = (NSDictionary *)bodyString;
    NSString *jsonString = [self toJSONString];
    jsonString = [jsonString stringByAppendingString:@"\r\n"];
    //jsonString =[GACSocketModel stringByReplacingOccurrencesOfString:jsonString];
    return jsonString;
}
- (NSString *)dictionnaryObjectToString:(NSDictionary *)object {
    NSError *error = nil;
    NSData *stringData =
    [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    // 字典对象用系统JSON序列化之后的data，转UTF-8后的jsonString里面会包含"\n"及" "，需要替换掉
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return jsonString;
}
+ (NSString*)stringByReplacingOccurrencesOfString:(NSString*)jsonString{
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    NSLog(@"length: %d  stringByReplacingOccurrencesOfString:%@  ",jsonString.length,jsonString);
    return jsonString;
}
@end
