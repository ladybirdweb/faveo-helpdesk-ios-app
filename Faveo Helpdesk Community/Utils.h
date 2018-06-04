//
//  Utils.h
//  SideMEnuDemo
//
//  Created by Narendra on 07/11/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Utils : NSObject

+(BOOL)userNameValidation:(NSString *)strUsername;
+(BOOL)emailValidation:(NSString *)strEmail;
+(BOOL)phoneNovalidation:(NSString *)strPhonr;
+(BOOL)validateUrl: (NSString *) url ;

-(void)viewSlideInFromRightToLeft:(UIView *)views;
-(void)viewSlideInFromLeftToRight:(UIView *)views;
-(void)viewSlideInFromTopToBottom:(UIView *)views;
-(void)viewSlideInFromBottomToTop:(UIView *)views;

-(void)showAlertWithMessage:(NSString*)message sendViewController:(UIViewController *)viewController;
-(NSString *)getLocalDateTimeFromUTC:(NSString *)strDate;

+(BOOL)isEmpty:(NSString *)str;

@end
