#import "HCPEnvrionmentalVariables.h"
@implementation HCPEnvrionmentalVariables
HSSingletonM(EnvrionmentalVariables);
+(NSString*)getbasefullurl:(NSString*)tmpUrl{
    NSMutableString *urlstr =[[NSMutableString alloc]initWithString:tmpUrl];
    [urlstr appendString:@"/websocket?wxid=%@"];
    urlstr=  [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return  urlstr;
}
+(NSString*)getbaseurl:(NSString*)tmpUrl wxid:(NSString*)wxid {
    
    NSString *urlstr =[NSString stringWithFormat:tmpUrl,wxid];
    urlstr=  [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#warning  urlstr  不能包含中文
    return  urlstr;
}
+(NSString*)getdefaultbaseurl{
    NSString *tmpUrl =PRODUCTIONBaseURL;//默认生产地址
    switch ([HCPEnvrionmentalVariables shareEnvrionmentalVariables].envrionmentalVariables) {
        case ENVRIONMENTAL_VARIABLES_PRODUCTION:
            tmpUrl = PRODUCTIONBaseURL ;
            break;         
        case ENVRIONMENTAL_VARIABLES_UAT:
            tmpUrl = UATBaseURL;
            
            break;
    }
    return tmpUrl;
}
+(NSString*)getbaseurl:(NSString*)wxid{
    NSString *tmpUrl = [self getdefaultbaseurl];
    NSString *urlstr =[NSString stringWithFormat:tmpUrl,wxid];
    urlstr=  [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#warning  urlstr  不能包含中文
    return  urlstr;
}
@end
