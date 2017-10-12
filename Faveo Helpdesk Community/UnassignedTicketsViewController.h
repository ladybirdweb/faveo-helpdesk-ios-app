//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

/*!
 @class UnassignedTicketsViewController
 
 @brief This class contains list of Unassigned Tickets.
 
 @discussion This class contains a table view and it gives a list of unassigned tickets. After clicking a particular ticket we can see name of user, ticket number and his email id.
 Also It shows ticket created Time and also show overdue time if ticket is due.
 */
@interface UnassignedTicketsViewController :UIViewController<SlideNavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>


/*!
 @method addBtnPressed
 
 @brief This in an Button. When user clicked on this button it will redirect to unassigned tockets view controller.
 
 @discussion Buttons use the Target-Action design pattern to notify your app when the user taps the button. Rather than handle touch events directly, you assign action methods to the button and designate which events trigger calls to your methods. At runtime, the button handles all incoming touch events and calls your methods in response.
 
 @code
 
 -(void)addBtnPressed;
 
 @endcode
 
 
 @remark If tickets are present in unassigned ticket inbox then It will show tickets if not then it will show Empty.
 */

@end

