
#import <UIKit/UIKit.h>
//#import "IQPreviousNextView.h"

/*!
 @class LoginViewController
 
 @brief This class contains URL veryfying and user Login activities.
 
 @discussion This class contains login activities like URL,Username and Password.
 At First when app will launch after that URL view appear, So here User enters their company URL if that URL is valid then it goes to login activity page.
 Here user gives username/email and password to access profile. After Successfully login it will goes to Inbox page, and here user can see list of tickets, if not then It Will Show Error.
 */

@interface LoginViewController : UIViewController <UITextFieldDelegate>

/*!
 @property companyURLview
 
 @brief This is an property used for declaring an view.
 
 @discussion At runtime, a view object handles the rendering of any content in its area and also handles any interactions with that content.
 
 This view will sow for an url login.Here in this view a user can type his url and moves to login page.
 */
@property (weak, nonatomic) IBOutlet UIView *companyURLview;

/*!
 @property loginView
 
 @brief This is an property used for declaring an view.
 
 @discussion At runtime, a view object handles the rendering of any content in its area and also handles any interactions with that content.
 This view will show an usename and password. Using this credential an user can login for his account.
 */
@property (weak, nonatomic) IBOutlet UIView *loginView;

/*!
 @property loginButton
 
 @brief When you tap a button, or select a button that has focus, the button performs any actions attached to it.
 
 @discussion Buttons use the Target-Action design pattern to notify your app when the user taps the button. Rather than handle touch events directly, you assign action methods to the button and designate which events trigger calls to your methods. At runtime, the button handles all incoming touch events and calls your methods in response.
 */
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

/*!
 @property userNameTextField
 
 @brief This textfiled allows a user to enter his name.
 
 @discussion Text fields gather text-based input from the user using the onscreen keyboard. The keyboard is configurable for many different types of input such as plain text, emails, numbers, and so on. Text fields use the target-action mechanism and a delegate object to report changes made during the course of editing.
 */
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

/*!
 @property passcodeTextField
 
 @brief This textfiled allows a user to enter his password.
 
 @discussion Text fields gather text-based input from the user using the onscreen keyboard. The keyboard is configurable for many different types of input such as plain text, emails, numbers, and so on. Text fields use the target-action mechanism and a delegate object to report changes made during the course of editing.
 */
@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;

/*!
 @property urlTextfield
 
 @brief This textfiled allows a user to  enter his url.
 
 @discussion Text fields gather text-based input from the user using the onscreen keyboard. The keyboard is configurable for many different types of input such as plain text, emails, numbers, and so on. Text fields use the target-action mechanism and a delegate object to report changes made during the course of editing.
 */
@property (weak, nonatomic) IBOutlet UITextField *urlTextfield;

/*!
 @method btnLogin
 
 @brief This is an button action. After clicking button it will check username and password entered by user.
 
 @discussion Buttons use the Target-Action design pattern to notify your app when the user taps the button. Rather than handle touch events directly, you assign action methods to the button and designate which events trigger calls to your methods. At runtime, the button handles all incoming touch events and calls your methods in response.
 
 @code
 
 - (IBAction)btnLogin:(id)sender;
 
 @endcode
 
 */
- (IBAction)btnLogin:(id)sender;


/*!
 @method urlButton
 
 @brief After clicking this button it will check url which is eneterd by user.
 
 @discussion Buttons use the Target-Action design pattern to notify your app when the user taps the button. Rather than handle touch events directly, you assign action methods to the button and designate which events trigger calls to your methods. At runtime, the button handles all incoming touch events and calls your methods in response.
 
 @code
 
 - (IBAction)urlButton:(id)sender;
 
 @endocde
 
 */
- (IBAction)urlButton:(id)sender;
@end
