
#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

/*!
 @class TrashTicketsViewController
 
 @brief This class contains list of Trash Tickets.
 
 @discussion This class contains a table view and it gives a list of trashed tickets. After clicking a particular ticket we will moves to conversation page. Here we will see conversation between Agent and client.
 */

@interface TrashTicketsViewController :UIViewController<SlideNavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
/*!
 @method addBtnPressed
 
 @brief This in an Button. When user clicked on this button it will redirect to trash tickets view controller.
 
 @discussion Buttons use the Target-Action design pattern to notify your app when the user taps the button. Rather than handle touch events directly, you assign action methods to the button and designate which events trigger calls to your methods. At runtime, the button handles all incoming touch events and calls your methods in response.
 
 @code
 
 -(void)addBtnPressed;
 
 @endcode
 
 @remark If tickets are present in trash ticket inbox then It will show tickets if not then it will show Empty.
 */


@end

