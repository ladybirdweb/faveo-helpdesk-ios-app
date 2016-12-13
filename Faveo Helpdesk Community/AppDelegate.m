//
//  AppDelegate.m
//  SideMEnuDemo
//
//  Created by Narendra on 17/08/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "InboxViewController.h"
#import "HexColors.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()
@property (nonatomic, strong) MBProgressHUD *progressView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    [Fabric with:@[[Crashlytics class]]];
    [self setApplicationApperance];
    
      UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loginSuccess"]) {
        NSLog(@"Login Done!!!");
        
        InboxViewController *inbox=[mainStoryboard instantiateViewControllerWithIdentifier:@"InboxID"];
        SlideNavigationController *slide = [[SlideNavigationController alloc] initWithRootViewController:inbox];
        slide.navigationBar.translucent = NO;
        
        LeftMenuViewController *leftMenu = (LeftMenuViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
        
        [SlideNavigationController sharedInstance].leftMenu = leftMenu;
        [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = slide;
        [self.window makeKeyAndVisible];
    
    }else{
    NSLog(@"Not Login!!!");
    LoginViewController  *homeScreen = [mainStoryboard instantiateViewControllerWithIdentifier:@"Login"];
    
    SlideNavigationController *slide = [[SlideNavigationController alloc] initWithRootViewController:homeScreen];
    slide.navigationBar.translucent = NO;
    
    LeftMenuViewController *leftMenu = (LeftMenuViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
   
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    [SlideNavigationController sharedInstance].menuRevealAnimationDuration = .18;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = slide;
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}

-(void)setApplicationApperance
{
    
   // [[UINavigationBar appearance] setBarTintColor:[UIColor hx_colorWithHexString:@"#00aeef"]];
    [[UINavigationBar appearance] setTintColor:[UIColor hx_colorWithHexRGBAString:@"#00aeef"]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#00aeef"]}];
    
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:8/255.0f green:16/255.0f blue:91/255.0f alpha:1.0f]];
//    [[UINavigationBar appearance] setTintColor: [UIColor whiteColor]];
//    [[UINavigationBar appearance] setTitleTextAttributes:
//     @{NSForegroundColorAttributeName:[UIColor whiteColor],
//       NSFontAttributeName:[UIFont fontWithName:@"Lato-Regular" size:18]}];
//    
//  [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor hx_colorWithHexString:@"#00aeef"]} forState:UIControlStateNormal];
    
//    UIView *backgroundView=[[UIView alloc]init];
//    [backgroundView setBackgroundColor:[UIColor hx_colorWithHexString:@"#87CEFA"]];
//    [[UITableViewCell appearance] setSelectedBackgroundView:backgroundView];
}

#pragma mark - Singlton class instance
+(AppDelegate*)sharedAppdelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}
#pragma mark - Progress Hud Show and Hide
- (void)showProgressView
{
    MBProgressHUD *HUD =[MBProgressHUD showHUDAddedTo:self.window animated:YES];
    HUD.label.text = @"Please wait";
    HUD.dimBackground = YES;
    self.progressView = HUD;
}

- (void)showProgressViewWithText:(NSString *)text
{
    MBProgressHUD *HUD =[MBProgressHUD showHUDAddedTo:self.window animated:YES];
    HUD.label.text = text;
    HUD.dimBackground = YES;
    self.progressView = HUD;
}

- (void)hideProgressView
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.window animated:YES];
            self.progressView = nil;
        }); });
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
