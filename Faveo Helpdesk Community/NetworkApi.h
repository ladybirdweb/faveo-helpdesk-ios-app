//
//  NetworkApi.h
//  Location
//
//  Created by Raja Sinha on 07/05/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NetworkResponce)(id responce);
typedef void (^callbackHandler) (NSError *, id);
typedef void (^routebackHandler) (NSError *, id, NSHTTPURLResponse*);
typedef void (^ApiResponse)(NSError* , id);

@interface NetworkApi : NSObject

@property (nonatomic, strong) NetworkResponce responceResult;
@property(nonatomic,strong)NSURLSession *session;


+ (instancetype)sharedInstance;


- (void)executePostRequestWithURLString:(NSString *)urlString
                              parameter:(id)parameter
                        callbackHandler:(callbackHandler)block;

- (void)executePostRequestWithURLString:(NSString *)urlString
                              parameter:(id)parameter
                            contentType:(NSString *)contentType
                        callbackHandler:(callbackHandler)block;


-(void)startApiExecution:(NSDictionary*)parameter andUrl:(NSString*)apiUrl withCompletionblock:(ApiResponse)block ;


-(void)startImageApiExecution:(NSDictionary*)parameter andUrl:(NSString*)apiUrl withCompletionblock:(callbackHandler)block;

@end
