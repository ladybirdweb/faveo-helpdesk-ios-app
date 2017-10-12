//
//  Utils.h
//  SideMEnuDemo
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/*!
 @class AppDelegate
 
 @brief This class contains validation methods.
 
 @discussion This file contains the <b>validation</b>code used for this project.Like username validation, e-mail validation, phone number validation, URL validation of a company. Also it contains <b>sliding</b>or <b>Animating</b> code so that one view move to another direction i.e view will slide to right to left, left to right , top to bottom or bottom to top.
 
 */
@interface Utils : NSObject

/*!
 @method userNameValidation
 
 @brief This method validates an username.

 @discussion It checks the user name valid or not.If it is returns true then it return or returns false.
 
 @param strUsername This in an string value i.e name of user.
 
 @code
 if(strUsername.length >= 5){
 
 return YES;
 }
 
 return NO;
 
 @endocde
 
 @see +(BOOL)emailValidation:
 
 @warning The username lenght must be greater than 2 characters.
 
 @return user name.
 */
+(BOOL)userNameValidation:(NSString *)strUsername;

/*!
 @method emailValidation
 
 @brief This method validates an email of email.
 
 @discussion It checks the email valid or not.If it is valid then it return true or returns false.
 
 @param strEmail This in an string value i.e emal id of user.
 
 @code
 NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
 NSPredicate *emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
 BOOL myStringMatchesRegEx=[emailTest evaluateWithObject:strEmail];
 return myStringMatchesRegEx;
 @endcode
 
 @return email.
 */
+(BOOL)emailValidation:(NSString *)strEmail;

/*!
 @method phoneNovalidation
 
 @brief This method validates the contact number.
 
 @discussion It checks the phone number valid or not.If it is valid then it return true or returns false.
 
 @param strPhonr This in an integer value i.e phone number of user.
 
 @code

 NSString *phoneRegex = @"^[+(00)][0-9]{6,14}$";
 NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
 BOOL phoneValidates = [phoneTest evaluateWithObject:strPhone];
 return phoneValidates;
 @endcode
 
 @see +(BOOL)emailValidation:
 
 @warning This takes integer numbers only.
 */

+(BOOL)phoneNovalidation:(NSString *)strPhonr;

/*!
 @method validateUrl
 
 @brief This method validates URL.
 
 @discussion It checks the URL valid or not.If it is valid then it return true or returns false.
 
 @param url This in an string value i.e url of user.
 
 @code
 
 NSURL* urls = [NSURL URLWithString:url];
 if (urls == nil) {
 
 NSLog(@"Nope %@ is not a proper URL", url);
 return NO;
 }

 @endocde
 
 @return url.
 
 @see -(BOOL)compareDates:
 */
+(BOOL)validateUrl: (NSString *) url ;

/*!
 @method compareDates
 
 @brief This method used for comparing dates.
 
 @discussion It compares the dates, old date and new date.If it is valid then it return true or returns false.
 
 @param date1 This in an integer value.
 
 @code
 
 -(BOOL)compareDates:(NSString*)date1;
 
  @endocde

 
 @see +(BOOL)validateUrl:
 */
-(BOOL)compareDates:(NSString*)date1;


/*!
 @method isEmpty
 
 @brief This method checks whether textfiled is empty.
 
 @discussion This method used for validation process. Here using this method we can check that the data entered in textfield or not, or the textfiled is empty or not. If it contains data the then if false is not then it will return true.
 
 @param str This in an string value.
 
 @code
 
 if (str == nil || str == (id)[NSNull null] || [[NSString stringWithFormat:@"%@",str] length] == 0 || [[[NSString stringWithFormat:@"%@",str] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
 
 return YES;
 }
 
  @endocde

 */
+(BOOL)isEmpty:(NSString *)str;

/*!
 @method viewSlideInFromRightToLeft
 
 @discussion This method used for sliding or moving a view from right to left direction. Here sliding duration and direction is provided, when this method is called it takes that values and excutes it.
 
 @code
 
 -(void)viewSlideInFromRightToLeft:(UIView *)views
 {
 CATransition *transition = nil;
 transition = [CATransition animation];
 transition.duration = 0.5;//kAnimationDuration
 transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
 transition.type = kCATransitionPush;
 transition.subtype =kCATransitionFromRight;
 // transition.delegate = self;
 [views.layer addAnimation:transition forKey:nil];
 
 }
 
  @endocde

 */
-(void)viewSlideInFromRightToLeft:(UIView *)views;

/*!
 @method viewSlideInFromLeftToRight
 
 @discussion This method used for sliding or moving a view from left to right direction. Here sliding duration and direction is provided, when this method is called it takes that values and excutes it.
 
 @code
 
 -(void)viewSlideInFromLeftToRight:(UIView *)views
 {
 CATransition *transition = nil;
 transition = [CATransition animation];
 transition.duration = 0.5;//kAnimationDuration
 transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
 transition.type = kCATransitionPush;
 transition.subtype =kCATransitionFromLeft;
 //transition.delegate = self;
 [views.layer addAnimation:transition forKey:nil];
 }

  @endocde
 */
-(void)viewSlideInFromLeftToRight:(UIView *)views;

/*!
 @method viewSlideInFromTopToBottom
 
 @discussion This method used for sliding or moving a view from top to bottom direction. Here sliding duration and direction is provided, when this method is called it takes that values and excutes it.
 
 @code
 
 -(void)viewSlideInFromTopToBottom:(UIView *)views
 {
 CATransition *transition = nil;
 transition = [CATransition animation];
 transition.duration = 0.5;//kAnimationDuration
 transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
 transition.type = kCATransitionPush;
 transition.subtype =kCATransitionFromBottom ;
 //transition.delegate = self;
 [views.layer addAnimation:transition forKey:nil];
 }

  @endocde
 */
-(void)viewSlideInFromTopToBottom:(UIView *)views;
/*!
 @method viewSlideInFromBottomToTop
 
 @discussion This method used for sliding or moving a view from bottom to top direction. Here sliding duration and direction is provided, when this method is called it takes that values and excutes it.
 
 @code
 
 -(void)viewSlideInFromBottomToTop:(UIView *)views
 {
 CATransition *transition = nil;
 transition = [CATransition animation];
 transition.duration = 0.5;//kAnimationDuration
 transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
 transition.type = kCATransitionPush;
 transition.subtype =kCATransitionFromTop ;
 // transition.delegate = self;
 [views.layer addAnimation:transition forKey:nil];
 }
 
 @endocde
 */
-(void)viewSlideInFromBottomToTop:(UIView *)views;

/*!
 @method showAlertWithMessage
 
 @param message This is string value.
 
 @brief An object that displays an alert message to the user.
 
 @discussion This method used for showing an alert messages. For example, in login page if u enter wrong username or password then it will display one alert message that "Invalid Credentials" or "Wrong Username or Password".
 
 @code
 
 UIAlertController *alertController = [UIAlertController   alertControllerWithTitle:APP_NAME message:message  preferredStyle:UIAlertControllerStyleAlert];
 UIAlertAction *cancelAction = [UIAlertAction  actionWithTitle:@"OK"
 style:UIAlertActionStyleCancel
 handler:^(UIAlertAction *action)
 {
 NSLog(@"Cancel action");
 }];
 [alertController addAction:cancelAction];

 @endocde
 */
-(void)showAlertWithMessage:(NSString*)message sendViewController:(UIViewController *)viewController;

/*!
 @method getLocalDateTimeFromUTC
 
 @param strDate It is an date.
 
 @brief Converts the value of the current DateTime object to local time.
 
 @discuusion You can use the ToLocalTime method to restore a local date and time value that was converted to UTC by the ToUniversalTime or FromFileTimeUtc method. However, if the original time represents an invalid time in the local time zone, it will not match the restored value. When the ToLocalTime method converts a time from UTC to the local time zone, it also adjusts the time so that is valid in the local time zone.
 */
-(NSString *)getLocalDateTimeFromUTC:(NSString *)strDate;

/*!
 @method getLocalDateTimeFromUTCDueDate
 
 @param strDate It is an date.
 
 @brief Converts the value of the current DateTime object to local time.
 
 @discuusion You can use the ToLocalTime method to restore a local date and time value that was converted to UTC by the ToUniversalTime or FromFileTimeUtc method. However, if the original time represents an invalid time in the local time zone, it will not match the restored value. When the ToLocalTime method converts a time from UTC to the local time zone, it also adjusts the time so that is valid in the local time zone.
 */
-(NSString *)getLocalDateTimeFromUTCDueDate:(NSString *)strDate;




@end
