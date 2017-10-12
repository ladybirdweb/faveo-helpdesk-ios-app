
#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

/*!
 @class ClientListViewController
 
 @brief This class contains list of Clients.
 
 @discussion This class contains a table view and it gives a list of Clients. After clicking a particular client cell we can see name of client, email id, profile picture, contact number.
 Also it will show client is active and inactive.
 It contains a list of messages that he was created.
 */

@interface ClientListViewController :UIViewController<SlideNavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@end

