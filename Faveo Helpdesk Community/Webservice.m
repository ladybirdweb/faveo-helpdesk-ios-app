//
//  Webservice.m
//  Share Coupon
//
//  Created by Anilkumar on 20/06/15.
//  Copyright (c) 2015 Anilkumar. All rights reserved.
//

#import "Webservice.h"
//#import "SBJson.h"
@implementation Webservice
@synthesize callbackproperty,connection,responsedata;


//update profile image webservice
//Login API
-(void)loginusername:(NSString*)userNameString password:(NSString*)passwordString usingcallback:(void (^) (NSString *result))afterresponse
{
    self.callbackproperty=[afterresponse copy];
    NSArray *keys = [NSArray arrayWithObjects: @"email",@"password",nil];
    NSArray *objects = [NSArray arrayWithObjects:userNameString,passwordString,nil];
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSString *myJSONString ;//=[jsonDictionary JSONRepresentation];
    NSLog(@"jsondictionary %@",jsonDictionary);
    NSData *myJSONData =[myJSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"myJSONString :%@", myJSONString);
    NSLog(@"myJSONData :%@", myJSONData);

    NSString *querystring=[NSString stringWithFormat:@"http://khkhkhkh/api/login"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:querystring]];
    [request setHTTPBody:myJSONData];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if( connection )
    {
        self.responsedata=[NSMutableData data];
    }
}
#pragma mark - NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responsedata setLength:0];
    //  NSLog(@"response :%@",response);
    // NSLog(@"response  representation:%@",response.JSONRepresentation);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responsedata appendData:data];
   // NSLog(@"Data : %@",data);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed: %@", [error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *responseString = [[NSString alloc] initWithData:self.responsedata encoding:NSUTF8StringEncoding];
    NSLog(@"%@",responseString);
    self.responsedata = nil;
    self.callbackproperty(responseString);
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}
@end
