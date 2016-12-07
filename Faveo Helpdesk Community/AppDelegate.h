//
//  AppDelegate.h
//  SideMEnuDemo
//
//  Created by Narendra on 17/08/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "LeftMenuViewController.h"
#import "MBProgressHUD.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(AppDelegate*)sharedAppdelegate;

//MBProgreehud
- (void)showProgressView;
- (void)showProgressViewWithText:(NSString *)text;
- (void)hideProgressView;

@end

