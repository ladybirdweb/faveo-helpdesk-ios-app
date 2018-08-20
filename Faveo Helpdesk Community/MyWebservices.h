//



#import <Foundation/Foundation.h>


typedef void (^NetworkResponce)(id responce);
typedef void (^callbackHandler) (NSError *, id,NSString*);
typedef void (^routebackHandler) (NSError *, id, NSHTTPURLResponse*);
typedef void (^ApiResponse)(NSError* , id);


@interface MyWebservices : NSObject


@property(nonatomic,strong)NSURLSession *session;


+ (instancetype)sharedInstance;


-(void)httpResponsePOST:(NSString *)urlString
              parameter:(id)parameter
        callbackHandler:(callbackHandler)block;


-(void)httpResponseGET:(NSString *)urlString
             parameter:(id)parameter
       callbackHandler:(callbackHandler)block;


-(NSString*)refreshToken;


-(void)getNextPageURL:(NSString*)url callbackHandler:(callbackHandler)block;


-(void)getNextPageURL:(NSString*)url user_id:(NSString*)uid callbackHandler:(callbackHandler)block;
@end

