//
//  UIView+Shake.m
//  


#import "UIView+Shake.h"
#import <objc/runtime.h>

@implementation UIView (UIView_Shake)

static void *NumCurrentShakesKey;
static void *NumTotalShakesKey;
static void *ShakeDirectionKey;

- (int)numCurrentShakes {
    return [objc_getAssociatedObject(self, &NumCurrentShakesKey) intValue];
}

- (void)setNumCurrentShakes:(int)value {
    objc_setAssociatedObject(self, &NumCurrentShakesKey, [NSNumber numberWithInt:value], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (int)numTotalShakes {
    return [objc_getAssociatedObject(self, &NumTotalShakesKey) intValue];
}

- (void)setNumTotalShakes:(int)value {
    objc_setAssociatedObject(self, &NumTotalShakesKey, [NSNumber numberWithInt:value], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (int)shakeDirection {
    return [objc_getAssociatedObject(self, &ShakeDirectionKey)  intValue];
}

- (void)setShakeDirection:(int)value {
    objc_setAssociatedObject(self, &ShakeDirectionKey, [NSNumber numberWithInt:value], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)shake {
    [self shakeNextWithCompleteBlock:nil];
}

-(void)shakeWithCallback:(void (^)(void))completeBlock {
    self.numCurrentShakes = 0;
    self.numTotalShakes = 4;
    self.shakeDirection = 6;
    [self shakeNextWithCompleteBlock:completeBlock];
}

-(void)shakeNextWithCompleteBlock:(void (^)(void))completeBlock
{
    UIView* viewToShake = self;
    [UIView animateWithDuration:0.08
                     animations:^
     {
         viewToShake.transform = CGAffineTransformMakeTranslation(self.shakeDirection, 0);
     }
                     completion:^(BOOL finished)
     {
         if(self.numCurrentShakes >= self.numTotalShakes)
         {
             viewToShake.transform = CGAffineTransformIdentity;
             if(completeBlock != nil) {
                 completeBlock();
             }
             return;
         }
         self.numCurrentShakes++;
         self.shakeDirection = self.shakeDirection * -1;
         [self shakeNextWithCompleteBlock:completeBlock];
     }];
}

@end
         

