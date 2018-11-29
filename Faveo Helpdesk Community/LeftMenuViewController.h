
#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

/*!
 @class LeftMenuViewController
 
 @brief This class contain menu driven view i.e displayed in table view format.
 
 @discussion This class contains and defines slide out design pattern.
 This class defines a table view, and that table view contain a list of menus like Create Ticket, Ticket List, Inbox Tickets, My Tickets, Unassigned Tickets, Closed Tickets, Trash Tickets, Client List and Logout.
 After Clicking on perticular menu it will goes to next ViewController (page).
 
 */
@interface LeftMenuViewController :UITableViewController

@property (nonatomic, assign) BOOL slideOutAnimationEnabled;

/*!
 @property user_profileImage
 
 @brief This is an property name for declaring user Profile Image.
 */
@property (weak, nonatomic) IBOutlet UIImageView *user_profileImage;

/*!
 @property user_role
 
 @brief This is an property name for declaring role of a user.
 
 @discussion The role may be Agent, Admin or User. So that this property describe role.
 */

@property (weak, nonatomic) IBOutlet UILabel *user_role;

/*!
 @property url_label
 
 @brief This is an property name for declaring url.
 
 @discussion Each user have their own url so that, this property defined for url.
 */

@property (weak, nonatomic) IBOutlet UILabel *url_label;

/*!
 @property user_nameLabel
 
 @brief This is an property name for declaring user name.
 */
@property (weak, nonatomic) IBOutlet UILabel *user_nameLabel;

/*!
 @property inbox_countLabel
 
 @brief This is an property declared for showing count of Tickets.
 
 @discussion This is simply count. In inbox, you will see the count that is an integer number so that we can easily understood that How many tockets are there in Inbox.
 
 @remark This shows an Integer number.
 */
@property (weak, nonatomic) IBOutlet UILabel *inbox_countLabel;

/*!
 @property inbox_countLabel
 
 @brief This is an property declared for showing count of my tickets.
 
 @discussion This is simply count. In my tickets, i.e these tickets are assigned to perticular agent, so an agent can easlity understood that How many tickets are there for me.
 In my tickets, you will see the count that is an integer number so that we can easily understood that How many tickets are there for me in my tickets.
 
 @remark This shows an Integer number.
 */
@property (weak, nonatomic) IBOutlet UILabel *myTickets_countLabel;

/*!
 @property unassigned_countLabel
 
 @brief This is an property declared for showing count of unassigned tickets.
 
 @discussion This is simply count. In inbox, you will see the count that is an integer number so that we can easily understood that How many tickets are unassigned.
 
 @remark This shows an Integer number.
 */
@property (weak, nonatomic) IBOutlet UILabel *unassigned_countLabel;

/*!
 @property closed_countLabel
 
 @brief This is an property declared for showing count of closed tickets.
 
 @discussion This is simply count. In inbox, you will see the count that is an integer number so that we can easily understood that How many tickets are closed.
 
 @remark This shows an Integer number.
 */
@property (weak, nonatomic) IBOutlet UILabel *closed_countLabel;

/*!
 @property trash_countLabel
 
 @brief This is an property name  declared for showing count of trash tickets.
 
 @discussion This is simply count. In inbox, you will see the count that is an integer number so that we can easily understood that How many tickets are deleted or present in trash.
 
 @remark This shows an Integer number.
 */
@property (weak, nonatomic) IBOutlet UILabel *trash_countLabel;

/*!
 @property c1, c2, c3, c4, c5
 
 @brief This is an property used for creating label.
 
 @discussion They are used to create view for showing count label of the ticket.
 */
@property (weak, nonatomic) IBOutlet UILabel *c1;
@property (weak, nonatomic) IBOutlet UILabel *c2;
@property (weak, nonatomic) IBOutlet UILabel *c3;
@property (weak, nonatomic) IBOutlet UILabel *c4;
@property (weak, nonatomic) IBOutlet UILabel *c5;

/*!
 @property view1, view2, view3, view4, view5
 
 @brief This is an property used for creating view.
 
 @discussion They are used to create view for showing count label of the ticket.
 */
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;

/*!
 @method update
 
 @brief This method used for updating the data into side-menu view.
 
 @discussion This method used to show data like ticket count, user profile, user name on side-menu when viewDidLoad method is called.
 
 @code
 
 -(void)update;
 
 @endcode
 
 */
-(void)update;

/*!
 @method reloadd
 
 @brief This method used for reloading the tableView
 
 @discussion Using this method, we can able to update the values in tableView.
 
 @code
 
 -(void)reloadd;
 
 @endcode
 
 */
-(void)reloadd;

/*!
 @method addUIRefresh
 
 @brief This method used to show refresh view behind the tableView.
 
 @discussion Using this method, we can able user can able to refresh the tableView so that the data inside the tableView will update while updating this values in tableView background it show an loader with text "Refreshing"
 
 @code
 
 -(void)addUIRefresh;
 
 @endcode
 
 */
-(void)addUIRefresh;

@end

