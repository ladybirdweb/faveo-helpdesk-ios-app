//
//  AppDelegate.m
//  SideMEnuDemo
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "InboxViewController.h"
#import "HexColors.h"
#import "AppConstanst.h"
#import "GlobalVariables.h"
#import "TicketDetailViewController.h"
#import "MyWebservices.h"
#import "ClientDetailViewController.h"

@interface AppDelegate ()
@end

@interface AppDelegate (){
    
    UIStoryboard *mainStoryboard;
}
@property (nonatomic, strong) MBProgressHUD *progressView;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    
   // [self setApplicationApperance];
    
    mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
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

//-(void)setApplicationApperance
//{
//    [[UINavigationBar appearance] setTintColor:[UIColor hx_colorWithHexRGBAString:@"#00aeef"]];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#00aeef"]}];
//
//}

#pragma mark - Singlton class instance
+(AppDelegate*)sharedAppdelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}
#pragma mark - Progress Hud Show and Hide
- (void)showProgressView
{
    MBProgressHUD *HUD =[MBProgressHUD showHUDAddedTo:self.window animated:YES];
    HUD.label.text = NSLocalizedString(@"Please wait",nil);
    //HUD.dimBackground = YES;
    self.progressView = HUD;
}

- (void)showProgressViewWithText:(NSString *)text
{
    MBProgressHUD *HUD =[MBProgressHUD showHUDAddedTo:self.window animated:YES];
    HUD.label.text = text;
   // HUD.dimBackground = YES;
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
    NSLog(@"");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
