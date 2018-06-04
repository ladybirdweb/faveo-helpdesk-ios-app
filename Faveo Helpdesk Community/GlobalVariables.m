//
//  GlobalVariables.m
//  SideMEnuDemo
//
//  Created by Narendra on 30/11/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import "GlobalVariables.h"

@implementation GlobalVariables

+ (instancetype)sharedInstance
{
    static GlobalVariables *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GlobalVariables alloc] init];
        NSLog(@"SingleTon-GlobalVariables");
    });
    return sharedInstance;
}
@end
