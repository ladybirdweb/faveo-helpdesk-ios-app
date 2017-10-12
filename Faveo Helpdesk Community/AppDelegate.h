//
//  AppDelegate.h
//  SideMEnuDemo
//



#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "SlideNavigationController.h"
#import "LeftMenuViewController.h"
#import "MBProgressHUD.h"

/*!
 @class AppDelegate
 
 @brief This is a class class that receives application-level messages, including the applicationDidFinishLaunching message most commonly used to initiate the creation of other views.
 
 @discussion The app delegate works alongside the app object to ensure your app interacts properly with the system and with other apps. Specifically, the methods of the app delegate give you a chance to respond to important changes. For example, you use the methods of the app delegate to respond to state transitions, such as when your app moves from foreground to background execution, and to respond to incoming notifications. 
     In many cases, the methods of the app delegate are the only way to receive these important notifications.

 */

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

/*!
 @property window
 
 @brief An object that provides the backdrop for your app’s user interface and provides important event-handling behaviors.
 */
@property (strong, nonatomic) UIWindow *window;

+(AppDelegate*)sharedAppdelegate;


/*!
 @method showProgressView
 
 @brief It is activity indicator it appears when the task is in process.
 
 @discussion An activity indicator spins while an unquantifiable task, such as loading or synchronizing complex data, is performed. It disappears when the task completes. Activity indicators are noninteractive.
 
 @code
 
 - (void)showProgressView
 {
 MBProgressHUD *HUD =[MBProgressHUD showHUDAddedTo:self.window animated:YES];
 HUD.label.text = NSLocalizedString(@"Please wait",nil);
 //HUD.dimBackground = YES;
 self.progressView = HUD;
 }

  @endocde
 
 @see showProgressViewWithText:
 */
- (void)showProgressView;

/*!
 @method showProgressViewWithText
 
 @brief It is activity indicator it appears when the task is in process with some text.
 
 @discussion An activity indicator spins while an unquantifiable task, such as loading or synchronizing complex data, is performed. It disappears when the task completes. Activity indicators are noninteractive.
 
 @param text It show some text with Indicator.
 
 @code
 
 - (void)showProgressViewWithText:(NSString *)text
 {
 MBProgressHUD *HUD =[MBProgressHUD showHUDAddedTo:self.window animated:YES];
 HUD.label.text = text;
 // HUD.dimBackground = YES;
 self.progressView = HUD;
 }
 
  @endocde

 @see hideProgressView:
 */
- (void)showProgressViewWithText:(NSString *)text;

/*!
 @method hideProgressView
 
 @brief It is activity indicator it disappears when the task is complete.
 
 @discussion An activity indicator spins while an unquantifiable task, such as loading or synchronizing complex data, is performed. It disappears when the task completes. Activity indicators are noninteractive.
 
 @code
 
 - (void)hideProgressView
 {
 dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
 dispatch_async(dispatch_get_main_queue(), ^{
 [MBProgressHUD hideHUDForView:self.window animated:YES];
 self.progressView = nil;
 }); });
 }
 
 @endocde
 
 @see showProgressView:
 */
- (void)hideProgressView;

@end

