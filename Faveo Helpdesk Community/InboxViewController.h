

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

/*!
 @class InboxViewController
 
 @brief This class contains list of tickets.
 
 @discussion This class contains a table view and it gives a list of Clients. After clicking a particular ticket we can see name of client, email id, profile picture, contact number.
 Also it will show client is active and inactive.
 It contains a list of messages that he was created.
 
 */

@interface InboxViewController : UIViewController<SlideNavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>

/*!
 @property tableView
 
 @brief This propert is an instance of a table view.
 
 @discussion Table views are versatile user interface objects frequently found in iOS apps. A table view presents data in a scrollable list of multiple rows that may be divided into sections.
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/*!
 @method addBtnPressed
 
 @brief This in an Button. When user clicked on this button it will redirect to Inbox view controller.
 
 @discussion Buttons use the Target-Action design pattern to notify your app when the user taps the button. Rather than handle touch events directly, you assign action methods to the button and designate which events trigger calls to your methods. At runtime, the button handles all incoming touch events and calls your methods in response.
 
 @code
 
 -(void)addBtnPressed;
 
 @endcode
 
 @remark If tickets are present in inbox then It will show tickets if not then it will show Empty.
 */


@end
