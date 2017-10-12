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

@import Firebase;
@import FirebaseInstanceID;
@import FirebaseMessaging;

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above. Implement FIRMessagingDelegate to receive data message via FCM for
// devices running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate () <FIRMessagingDelegate>
@end
#endif

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

@interface AppDelegate (){
    
    UIStoryboard *mainStoryboard;
}
@property (nonatomic, strong) MBProgressHUD *progressView;
@end

@implementation AppDelegate

NSString *const kGCMMessageIDKey = @"gcm.message_id";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    //[Fabric with:@[[Crashlytics class]]];
    
    //firebase FCM
    // Register for remote notifications. This shows a permission dialog on first run, to
    // show the dialog at a more appropriate time move this registration accordingly.
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier. Disable the deprecation warnings.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
#pragma clang diagnostic pop
    } else {
        // iOS 8 or later
        // [START register_for_notifications]
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        } else {
            // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert
            | UNAuthorizationOptionSound
            | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            }];
            
            // For iOS 10 display notification (sent via APNS)
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            // For iOS 10 data message (sent via FCM)
            [FIRMessaging messaging].remoteMessageDelegate = self;
#endif
        }
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        // [END register_for_notifications]
    }
    
    // [START configure_firebase]
    [FIRApp configure];
    // [END configure_firebase]
    
    // [START set_messaging_delegate]
    //[FIRMessaging messaging].delegate = self;
    // [END set_messaging_delegate]
    
    // Add observer for InstanceID token refresh callback.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    //till here
    
    
    [self setApplicationApperance];
    
    //[self registerRemoteNotifications:application];
    NSDictionary *userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    if (userInfo) {
        //        GlobalVariables *globalVariables=[GlobalVariables sharedInstance];
        //        globalVariables.iD=[userInfo objectForKey:@"id"];
        //        globalVariables.ticket_number=[userInfo objectForKey:@"ticket_number"];
        //        globalVariables.title=[userInfo objectForKey:@"title"];
    }
    
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

//-(void)registerRemoteNotifications:(UIApplication*)application{
//
//    if ([UNUserNotificationCenter class])
//    {
//        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//        center.delegate = self;
//        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
//                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
//                                  if (!error) {
//                                      NSLog(@"request authorization succeeded!");
//
//                                  }
//                              }];
//    }else if ([application respondsToSelector:@selector (registerUserNotificationSettings:)])
//    {
//        UIUserNotificationSettings *settings =
//        [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
//        [application registerUserNotificationSettings:settings];
//    }else
//    {
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//        [application registerForRemoteNotificationTypes:myTypes];
//    }
//
//    [application registerForRemoteNotifications];
//}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeUnknown];

    NSString *token = [[deviceToken.description componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet]invertedSet]]componentsJoinedByString:@""];
    NSLog(@"deviceToken : %@",deviceToken);
    NSLog(@"final token : %@",[[FIRInstanceID instanceID] token]);
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:token forKey:@"deviceToken"];
    [userDefaults synchronize];
    
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Failed to register deviceToken:%@",error.localizedDescription);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"userInfo888  %@", userInfo);

///////////////////////////////////
////    ***imp***
//        [self application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult result){
//            TicketDetailViewController *td=[mainStoryboard instantiateViewControllerWithIdentifier:@"TicketDetailVCID"];
//            // NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
//            GlobalVariables *globalVariables=[GlobalVariables sharedInstance];
//            globalVariables.iD=[userInfo objectForKey:@"id"];
//            //globalVariables.ticket_number=[userInfo objectForKey:@"ticket_number"];
//            //globalVariables.title=[userInfo objectForKey:@"title"];
//    
//            [(UINavigationController *)self.window.rootViewController pushViewController:td animated:YES];
//    
//        }];
  //////////////////////////////////
}

// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // Change this to your preferred presentation option
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
    //completionHandler(UNNotificationPresentationOptionNone);
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"data messages555 %@", userInfo);
    
    NSLog(@"%@",userInfo);
    completionHandler();
    
    TicketDetailViewController *td=[mainStoryboard instantiateViewControllerWithIdentifier:@"TicketDetailVCID"];
    GlobalVariables *globalVariables=[GlobalVariables sharedInstance];
   
    NSString * scenario=[userInfo objectForKey:@"scenario"];
    if ([scenario isEqualToString:@"tickets"])  {
         globalVariables.iD=[userInfo objectForKey:@"id"];
        globalVariables.ticket_number=[userInfo objectForKey:@"ticket_number"];
         [(UINavigationController *)self.window.rootViewController pushViewController:td animated:YES];
       ///////////////////////////
        [[AppDelegate sharedAppdelegate] hideProgressView];
    }else {
    
        
        ClientDetailViewController *cd=[mainStoryboard instantiateViewControllerWithIdentifier:@"ClientDetailVCID"];
        NSError *error;
        NSData *data = [[userInfo objectForKey:@"requester"] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *requester = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:kNilOptions
                                                                       error:&error];
      
        globalVariables.iD=[requester objectForKey:@"id"];
        
         [(UINavigationController *)self.window.rootViewController pushViewController:cd animated:YES];
        ////////////////////
        [[AppDelegate sharedAppdelegate] hideProgressView];
    }


}
#endif
// [END ios_10_message_handling]

//// With "FirebaseAppDelegateProxyEnabled": NO
//- (void)application:(UIApplication *)application
//didReceiveRemoteNotification:(NSDictionary *)userInfo
//fetchCompletionHandler:
//(void (^)(UIBackgroundFetchResult))completionHandler {
//    // Let FCM know about the message for analytics etc.
//    [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
//    // handle your message.
//}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
 
    
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"userinfo %@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
  
 
}

// [START ios_10_data_message_handling]
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Receive data message on iOS 10 devices while app is in the foreground.
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    // Print full message
    NSLog(@"remote messages123%@", remoteMessage.appData);
}
#endif
// [END ios_10_data_message_handling]

// [START refresh_token]
- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken =  [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:refreshedToken forKey:@"FCM_TOKEN"];
    [userDefaults synchronize];
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    [self sendDeviceToken:refreshedToken];
    // TODO: If necessary send token to application server.
}
// [END refresh_token]

- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:fcmToken forKey:@"FCM_TOKEN"];
    [userDefaults synchronize];
    // Connect to FCM since connection may have failed when attempted before having a token.
   
    [self sendDeviceToken:fcmToken];

}

-(void)sendDeviceToken:(NSString*)refreshedToken{
    
    NSLog(@"refreshed token  %@",refreshedToken);
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *url=[NSString stringWithFormat:@"%@fcmtoken?user_id=%@&fcm_token=%@&os=%@",[userDefaults objectForKey:@"companyURL"],[userDefaults objectForKey:@"user_id"],[[FIRInstanceID instanceID] token],@"ios"];
    MyWebservices *webservices=[MyWebservices sharedInstance];
    [webservices httpResponsePOST:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg){
        if (error || [msg containsString:@"Error"]) {
            if (msg) {
                
                // [utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                NSLog(@"Thread-postAPNS-toserver-error == %@",error.localizedDescription);
            }else if(error)  {
                //                [utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                NSLog(@"Thread-postAPNS-toserver-error == %@",error.localizedDescription);
            }
            return ;
        }
        if (json) {
            
            NSLog(@"Thread-sendAPNS-token-json-%@",json);
        }
        
    }];
}

// [START connect_to_fcm]
- (void)connectToFcm {
    // Won't connect since there is no token
    if (![[FIRInstanceID instanceID] token]) {
        return;
    }
    // Disconnect previous FCM connection if it exists.
    [[FIRMessaging messaging] disconnect];
    
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}
// [END connect_to_fcm]

// [START connect_on_active]
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self connectToFcm];
}
// [END connect_on_active]

// [START disconnect_from_fcm]
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[FIRMessaging messaging] disconnect];
    NSLog(@"Disconnected from FCM");
}
// [END disconnect_from_fcm]

////Called when a notification is delivered to a foreground app.
//-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
//    NSLog(@"User Info : %@",notification.request.content.userInfo);
//    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
//}
//
////Called to let your app know which action was selected by the user for a given notification.
//-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
//    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
//    completionHandler();
//}

-(void)setApplicationApperance
{
    [[UINavigationBar appearance] setTintColor:[UIColor hx_colorWithHexRGBAString:@"#00aeef"]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor hx_colorWithHexRGBAString:@"#00aeef"]}];
    
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
