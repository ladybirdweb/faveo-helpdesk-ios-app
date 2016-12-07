//
//  NetworkApi.m
//  Location
//
//  Created by Raja Sinha on 07/05/15.
//  Copyright (c) 2015 Location. All rights reserved.
//

#import "NetworkApi.h"

@implementation NetworkApi

+ (instancetype)sharedInstance
{
    static NetworkApi *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NetworkApi alloc] init];
    });
    return sharedInstance;
}

//overload method
- (void)executePostRequestWithURLString:(NSString *)urlString parameter:(id)parameter callbackHandler:(callbackHandler)block
{
    [self executePostRequestWithURLString:urlString
                                parameter:parameter
                              contentType:@"application/x-www-form-urlencoded"
                          callbackHandler:block];
}

- (void)executePostRequestWithURLString:(NSString *)urlString parameter:(id)parameter
                            contentType:(NSString *)contentType
                        callbackHandler:(callbackHandler)block
{
    NSError *error;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"unique-consistent-string";
    // set Content-Type in HTTP header
   contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    // post body
    NSMutableData *body = [NSMutableData data];
    [parameter enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    [request setHTTPBody:body];
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(data.length > 0)
        {
           NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"response is %@",dataString);
           
        }
    }];
}


-(void)startApiExecution:(NSDictionary*)parameter andUrl:(NSString*)apiUrl withCompletionblock:(callbackHandler)block

{
    
    NSString *boundary = [self generateBoundaryString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:apiUrl]];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    NSMutableData *body = [NSMutableData data];
    
    [parameter enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
        
    }];
    
    
    
    self.session = [NSURLSession sharedSession];  // use sharedSession or create your own
    
    NSURLSessionTask *task = [self.session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            
            NSLog(@"error = %@", error);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                block(error , response);
            });
            
            return;
            
        }
        
        else
            
        {
            
            NSError *error = nil;
            
            id responseData =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                block(error,responseData);
            });
            
        }
        
    }];
    
    [task resume];
    
    
    
}

-(void)startImageApiExecution:(NSDictionary*)parameter andUrl:(NSString*)apiUrl withCompletionblock:(callbackHandler)block

{
    NSString *userid = parameter[@"Userid"];
    NSData *image = parameter[@"ProfileImage"];
    
    NSString *boundary = [self generateBoundaryString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:apiUrl]];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Userid"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", userid] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    if (image) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: name=%@; filename=imageName.jpg\r\n", @"ProfileImage"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:image];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.session = [NSURLSession sharedSession];  // use sharedSession or create your own
    
    NSURLSessionTask *task = [self.session uploadTaskWithRequest:request fromData:body completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            
            NSLog(@"error = %@", error);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                block(error , response);
            });
            
            return;
            
        }
        
        else
            
        {
            
            NSError *error = nil;
            
            id responseData =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            block(error,responseData);
            
        }
        
    }];
    
    [task resume];
    
}
- (NSString *)generateBoundaryString
{
return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}
@end
