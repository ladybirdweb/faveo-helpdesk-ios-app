//
//  GlobalVariables.m
//  SideMEnuDemo

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
