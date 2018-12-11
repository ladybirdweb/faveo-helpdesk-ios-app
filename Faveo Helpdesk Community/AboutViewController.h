
#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

/*!
 @class AboutViewController
 
 @brief This class display information about Company.
 
 @discussion This class contain a view where It will show information about Faveo Helpdesk.
 
 */

@interface AboutViewController :UIViewController<SlideNavigationControllerDelegate>

/*!
 @property websiteButton
 
 @brief This is simple button property.
 
 @discussion Buttons use the Target-Action design pattern to notify your app when the user taps the button. Rather than handle touch events directly, you assign action methods to the button and designate which events trigger calls to your methods. At runtime, the button handles all incoming touch events and calls your methods in response.
 */
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;

/*!
 @method btnClicked
 
 @brief This in an Button.
 
 @discussion After clicking this button acton is performed i.e It will goto http://www.faveohelpdesk.com url. This link contains website of Faveo Helpdesk. Here we see details information of Faveo Helpdesk.
 
 @code
 
 - (IBAction)btnClicked:(id)sender;
 
 @endocde
 
 @warning If internet is available then it will rediect to that url.
 */

- (IBAction)btnClicked:(id)sender;

/*!
 @property textview
 
 @brief This is an textField property
 
 @discussion It used show show some company details which is not editable.
 */
@property (weak, nonatomic) IBOutlet UITextView *textview;


@end
