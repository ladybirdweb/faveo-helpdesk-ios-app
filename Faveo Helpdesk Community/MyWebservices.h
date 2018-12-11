//



#import <Foundation/Foundation.h>


typedef void (^NetworkResponce)(id responce);
typedef void (^callbackHandler) (NSError *, id,NSString*);
typedef void (^routebackHandler) (NSError *, id, NSHTTPURLResponse*);
typedef void (^ApiResponse)(NSError* , id);

/*!
 @class MyWebservices
 
 @brief This class provide web-based APIs to support machine-to-machine communication over networks. Because these APIs are web-based, they inherently support interaction between devices running on different architectures and speaking different native languages
 
 @discussion A server with a database responds to remote queries for data, where the client specifies a particular city, stock symbol, or book title, for example. The client application sends queries to the server, parses the response, and processes the returned data.
 
 All web service schemes utilize a web-based transport mode, such as HTTP, HTTPS, or SMTP, and a method for packaging the queries and responses, typically some sort of XML schema.
 
 */
@interface MyWebservices : NSObject


/*!
 @property session
 
 @brief It defines a way to store information (in variables) to be used across multiple pages. Unlike a cookie, the information is not stored on the users computer
 
 @discussion You can use URL objects to construct URLs and access their parts. For URLs that represent local files, you can also manipulate properties of those files directly, such as changing the file’s last modification date. Finally, you can pass URL objects to other APIs to retrieve the contents of those URLs.
 */
@property(nonatomic,strong)NSURLSession *session;


/*!
 @method sharedInstance
 
 @brief It defines singleton object.
 
 @discussion A singleton object provides a global point of access to the resources of its class. Singletons are used in situations where this single point of control is desirable, such as with classes that offer some general service or resource. You obtain the global instance from a singleton class through a factory method.
 
 @code
 + (instancetype)sharedInstance
 {
 static MyWebservices *sharedInstance = nil;
 static dispatch_once_t onceToken;
 dispatch_once(&onceToken, ^{
 sharedInstance = [[MyWebservices alloc] init];
 NSLog(@"SingleTon-MYwebserves");
 });
 return sharedInstance;
 }
 
 */
+ (instancetype)sharedInstance;


/*!
 @method httpResponsePOST
 @param urlString This is url
 @param parameter This is defines an id
 @param block It uses as block
 @brief This is an POST api call
 @discussion The POST method is used to request that the origin server accept the entity enclosed in the request as a new subordinate of the resource identified by the Request-URI in the Request-Line. It essentially means that POST request-URI should be of a collection URI.
 */
-(void)httpResponsePOST:(NSString *)urlString
              parameter:(id)parameter
        callbackHandler:(callbackHandler)block;


/*!
 @method httpResponseGET
 @param urlString dsknskd
 @param parameter It takes 2 parameters
 @param block It used as block
 @brief This is an GET api call
 @discussion se GET requests to retrieve resource representation/information only – and not to modify it in any way. As GET requests do not change the state of the resource, these are said to be safe methods.
 */
-(void)httpResponseGET:(NSString *)urlString
             parameter:(id)parameter
       callbackHandler:(callbackHandler)block;


/*!
 @method refreshToken
 
 @brief It will refresh a token
 
 @discussion In this, after some particular time of period tokem expires, so that we need to refresh it again and agian, so this this method allows us to refresh a token. It is called everywhere, when call an API, send a request and getting data from server we use this method here for refreshing a token so our session well be continued without interrupting a session.
 */
-(NSString*)refreshToken;

/*!
 @method getNextPageURL
 
 @param url It an url.
 
 @param block It perform some action.
 
 @brief It will call a next page using call handler block, each time when we scroll it will redirect to next page url and we get data.
 
 */
-(void)getNextPageURL:(NSString*)url callbackHandler:(callbackHandler)block;


/*!
 @method getNextPageURL
 
 @param url Its as url i.e it will call new API for getting next data.
 
 @param uid Its an id of a user.
 
 @param block It perform some action.
 
 @brief It passes user id to next page.So that, we can get next ticket data.
 
 */
-(void)getNextPageURL:(NSString*)url user_id:(NSString*)uid callbackHandler:(callbackHandler)block;
@end

