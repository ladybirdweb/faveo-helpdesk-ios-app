

#import <UIKit/UIKit.h>

/*!
 @class TicketDetailViewController
 
 @brief This class contains details of a ticket.
 
 @discussion This contain details of a ticket like Subject, Priority, HelpTopic, Name, email, source, ticket type and sue date.
 Here agent can edit things like subject, ticket priority,HelpTopic and Source.
 */
@interface TicketDetailViewController : UIViewController<UITextFieldDelegate>

/*!
 @property segmentedControl
 
 @brief This propert is an instance of a UISegmentedControl.
 
 @discussion A segmented control is a linear set of two or more segments, each of which functions as a mutually exclusive button. Within the control, all segments are equal in width.
 Like buttons, segments can contain text or images. Segmented controls are often used to display different views.
 */
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

/*!
 @property lblTicketNumber
 
 @brief This is an string value used for showing a label for Ticket Number.
 */
@property (weak, nonatomic) IBOutlet UILabel *lblTicketNumber;

/*!
 @property containerView
 
 @brief At runtime, a view object handles the rendering of any content in its area and also handles any interactions with that content.
 */
@property (weak, nonatomic) IBOutlet UIView *containerView;

/*!
 @property currentViewController
 
 @brief A view controller manages a set of views that make up a portion of your app’s user interface. It is responsible for loading and disposing of those views, for managing interactions with those views, and for coordinating responses with any appropriate data objects. View controllers also coordinate their efforts with other controller objects—including other view controllers—and help manage your app’s overall interface.
 */
@property (weak, nonatomic) UIViewController *currentViewController;

/*!
 @property ticketNumber
 
 @brief This property used for dislaying ticket number.
 */
@property(nonatomic,strong) NSString *ticketNumber;

@property (weak, nonatomic) IBOutlet UILabel *ticketLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


/*!
 @method addBtnPressed
 
 @brief This in an Button. After clicking perticluar ticket it redirect to redirect to Ticket Detail page.
 
 @discussion Buttons use the Target-Action design pattern to notify your app when the user taps the button. Rather than handle touch events directly, you assign action methods to the button and designate which events trigger calls to your methods. At runtime, the button handles all incoming touch events and calls your methods in response.
 
 @code
 
 - (IBAction)indexChanged:(id)sender;
 
 @endocde
 
 */
- (IBAction)indexChanged:(id)sender;



@end
