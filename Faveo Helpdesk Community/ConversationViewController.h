//


#import <UIKit/UIKit.h>

/*!
 @class ConversationViewController
 
 @brief This class contains conversation details.
 
 @discussion Here we will get in detail of conversation between Agent and a Client.Here we can see what is the message and its contents and time. It may contain attachment, image or text. Here Agent can see this all details.
 */
@interface ConversationViewController : UITableViewController

/*!
 @property activityIndicatorObject
 
 @brief It is an property to show Loader.
 
 @discussion An activity indicator is a spinning wheel that indicates a task is being processed. if an action takes an unknown amount of time to process you should display an activity indicator to let the user know your app is not frozen
 */
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;


/*!
 @method reloadd
 
 @brief This method used for reloading the tableView
 
 @discussion Using this method, we can able to update the values in tableView.
 
 @code
 
 -(void)reloadd;
 
 @endcode
 
 */
-(void)reload;

@end
