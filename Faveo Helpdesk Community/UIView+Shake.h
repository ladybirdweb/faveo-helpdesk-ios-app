//
//  UIView+Shake.h


#import <UIKit/UIKit.h>

@interface UIView (UIView_Shake)

-(void)shake;
-(void)shakeWithCallback:(void (^)(void))completeBlock;

@end
