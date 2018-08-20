//
//  DetailViewController.h

#import <UIKit/UIKit.h>

/*!
 @class DetailViewController
 
 @brief This class contains details of a ticket.
 
 @discussion This contain details of a ticket like Subject, Priority, HelpTopic, Name, email, source, ticket type and sue date.
 Here agent can edit things like subject, ticket priority,HelpTopic and Source.
 
 */

@interface DetailViewController : UITableViewController <UITextFieldDelegate>

/*!
 @property emailTextField
 
 @brief This property defines a textfield that shows email of a user.
 */
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

/*!
 @property firstnameTextField
 
 @brief This property defines a textfield that shows name of a user.
 */
@property (weak, nonatomic) IBOutlet UITextField *firstnameTextField;
//@property (weak, nonatomic) IBOutlet UITextField *lastnameTextField;

/*!
 @property helpTopicTextField
 
 @brief This property defines a textfield that shows Help Topic name.
 */
@property (weak, nonatomic) IBOutlet UITextField *helpTopicTextField;

/*!
 @property slaTextField
 
 @brief This property defines a textfield that shows SLA.
 */
@property (weak, nonatomic) IBOutlet UITextField *slaTextField;

/*!
 @property deptTextField
 
 @brief This property defines a textfield that shows department.
 */
@property (weak, nonatomic) IBOutlet UITextField *deptTextField;

/*!
 @property subjectTextField
 
 @brief This property defines a textfield that shows subject.
 */
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;

/*!
 @property statusTextField
 
 @brief This property defines a textfield that shows status of ticket.
 */
@property (weak, nonatomic) IBOutlet UITextField *statusTextField;

/**
 @property typeTextField
 
 @brief This property defines a textfield that shows type of ticket.
 */
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;

/*!
 @property priorityTextField
 
 @brief This property defines a textfield that shows ticket priority.
 */
@property (weak, nonatomic) IBOutlet UITextField *priorityTextField;

/*!
 @property sourceTextField
 
 @brief This property defines a textfield that shows sorce of ticket.
 */
@property (weak, nonatomic) IBOutlet UITextField *sourceTextField;

/*!
 @property dueDateTextField
 
 @brief This property defines a textfield that shows due date of a ticket.
 */
@property (weak, nonatomic) IBOutlet UITextField *dueDateTextField;

/*!
 @property createdDateTextField
 
 @brief This property defines a textfield that shows date of ticket created.
 */
@property (weak, nonatomic) IBOutlet UITextField *createdDateTextField;

/*!
 @property lastResponseDateTextField
 
 @brief This property defines a textfield that shows date of last response of a tocket.
 */
@property (weak, nonatomic) IBOutlet UITextField *lastResponseDateTextField;


/*!
 @property helptopicsArray
 
 @brief This property defines a array that shows list of Help Topics.
 */
@property (nonatomic, strong) NSArray * helptopicsArray;

/*!
 @property slaPlansArray
 
 @brief This property defines a array that shows list of SLA plans.
 */
@property (nonatomic, strong) NSArray * slaPlansArray;

/*!
 @property deptArray
 
 @brief This property defines a array that shows list of Departments.
 */
@property (nonatomic, strong) NSArray * deptArray;

/*!
 @property priorityArray
 
 @brief This property defines a array that shows list of Ticket Priority.
 */
@property (nonatomic, strong) NSArray * priorityArray;

/*!
 @property sourceArray
 
 @brief This property defines a array that shows list of Ticket Source.
 */
@property (nonatomic, strong) NSArray * sourceArray;

/*!
 @property statusArray
 
 @brief This property defines a array that shows list of Ticket Status.
 */
@property (nonatomic, strong) NSArray * statusArray;

/*!
 @property typeArray
 
 @brief This property defines a array that shows list of Ticket types.
 */
@property (nonatomic, strong) NSArray * typeArray;

/*!
 @property saveButton
 
 @brief This property defines button action.
 
 @discussion Buttons use the Target-Action design pattern to notify your app when the user taps the button. Rather than handle touch events directly, you assign action methods to the button and designate which events trigger calls to your methods. At runtime, the button handles all incoming touch events and calls your methods in response.
 
 */
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

/*!
 @property selectedIndex
 
 @brief This property defines in index which is an Integer format.
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/*!
 @method sourceClicked
 
 @brief This gives a list of Ticket source.
 
 @discussion This is button. After clicking this button we will get list of ticket source.
 Source can be Web, call, email or chat.
 
 @code
 
 - (IBAction)sourceClicked:(id)sender;
 
 @endocde
 
 */
- (IBAction)sourceClicked:(id)sender;

/*!
 @method typeClicked
 
 @brief This gives a list of Ticket Type.
 
 @discussion After clicking this button it will show type of ticket.The ticket type can be Question, Incident, Problem or Feature Request.
 
 @code
 
 - (IBAction)typeClicked:(id)sender;
 
 @endocde
 */
- (IBAction)typeClicked:(id)sender;

/*!
 @method statusClicked
 
 @brief This gives a list of Ticket Status.
 
 @discussion After clicking this button it will show status of a ticket.
 
 The status can be open,closed, request for close, archieved,resolved.
 
 @code
 
 - (IBAction)statusClicked:(id)sender;
 
 @endocde
 */
- (IBAction)statusClicked:(id)sender;


/*!
 @method helpTopicClicked
 
 @brief This gives a Help Topic List.
 
 @discussion After clicking this button it will show list of help topics. The help topics can be Support Query, Sales Query or Operational Query.
 
 @code
 
 - (IBAction)helpTopicClicked:(id)sender;
 
 @endocde
 */
- (IBAction)helpTopicClicked:(id)sender;

/*!
 @method slaClicked
 
 @brief This gives list of SLA Plan.
 
 @discussion After clicking this button it will shows list of SLA plans.The SLA plan can be Emergency, High, Low or normal.
 
 @code
 
 - (IBAction)deptClicked:(id)sender;
 
 @endocde
 
 */
- (IBAction)slaClicked:(id)sender;

/*!
 @method deptClicked
 
 @brief This will gives List of Departments.
 
 @discussion AFter clicking this button it will gives a list of all Departments.The department can be Operation, Sales, Support.
 
 @code
 
 - (IBAction)deptClicked:(id)sender;
 
 @endocde
 */
- (IBAction)deptClicked:(id)sender;

/*!
 @method priorityClicked
 
 @brief This will gives List of Ticket Priorities.
 
 @discussion After clicking this button it will gives list of ticket priority.The ticket priority can be Emergency, High, Low or Normal.
 
 @code
 
 - (IBAction)priorityClicked:(id)sender;
 
 @endocde
 
 */
- (IBAction)priorityClicked:(id)sender;

/*!
 @method saveClicked
 
 @brief This will save data.
 
 @discussion After clicking this button whatever we done any chnages in ticket, it will save and updated in ticket details.
 
 @code
 
 - (IBAction)saveClicked:(id)sender;
 
 @endocde
 
 */
- (IBAction)saveClicked:(id)sender;


@property (nonatomic, strong) NSMutableArray * assignArray;
- (IBAction)assignClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *assinTextField;

@property (weak, nonatomic) IBOutlet UITextView *subjectTextView;

@end
