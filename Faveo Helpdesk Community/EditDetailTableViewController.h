

#import <UIKit/UIKit.h>

/*!
 @class EditDetailTableViewController
 
 @brief This class contains details of a ticket.
 
 @discussion This contain details of a ticket like Subject, Priority, HelpTopic, Name, email, source, ticket type and sue date.
  Here agent can edit things like subject, ticket priority,HelpTopic and Source.
 
 */
@interface EditDetailTableViewController : UITableViewController<UITextFieldDelegate>


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

//@property (weak, nonatomic) IBOutlet UITextField *deptTextField;

//@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;

//@property (weak, nonatomic) IBOutlet UITextField *statusTextField;

//@property (weak, nonatomic) IBOutlet UITextField *typeTextField;


/*!
 @property priorityTextField
 
 @brief This property defines a textfield that shows priorities.
 */
@property (weak, nonatomic) IBOutlet UITextField *priorityTextField;

/*!
 @property sourceTextField
 
 @brief This property defines a textfield that shows ticket sources.
 */
@property (weak, nonatomic) IBOutlet UITextField *sourceTextField;

/*!
 @property helptopicsArray
 
 @brief This an Array property used to store all the helptopics names from the Helpdesk.
 */
@property (nonatomic, strong) NSArray * helptopicsArray;

/*!
 @property slaPlansArray
 
 @brief This an Array property used to store all the SLA names from the Helpdesk.
 */
@property (nonatomic, strong) NSArray * slaPlansArray;

/*!
 @property deptArray
 
 @brief This an Array property used to store all the department names from the Helpdesk.
 */
@property (nonatomic, strong) NSArray * deptArray;

/*!
 @property priorityArray
 
 @brief This an Array property used to store all the ticket priority names from the Helpdesk.
 */
@property (nonatomic, strong) NSArray * priorityArray;

/*!
 @property sourceArray
 
 @brief This an Array property used to store all the ticket source names from the Helpdesk.
 */
@property (nonatomic, strong) NSArray * sourceArray;

/*!
 @property statusArray
 
 @brief This an Array property used to store all the ticket status names from the Helpdesk.
 */
@property (nonatomic, strong) NSArray * statusArray;

/*!
 @property typeArray
 
 @brief This an Array property used to store all the ticket type names from the Helpdesk.
 */
@property (nonatomic, strong) NSArray * typeArray;

/*!
 @property saveButton
 
 @brief This is an button property.
 
 */
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

/*!
 @property selectedIndex
 
 @brief It used to represent the index of an pickerView
 */
@property (nonatomic, assign) NSInteger selectedIndex;


/*!
 @method sourceClicked
 
 @brief This will gives List of all ticket source list.
 
 @code
 
 - (IBAction)sourceClicked:(id)sender;
 
 @endocde
 */
- (IBAction)sourceClicked:(id)sender;

//- (IBAction)typeClicked:(id)sender;

//- (IBAction)statusClicked:(id)sender;


/*!
 @method helpTopicClicked
 
 @brief This will gives List of all help topics.
 
 @code
 
- (IBAction)helpTopicClicked:(id)sender;
 
 @endocde
 */
- (IBAction)helpTopicClicked:(id)sender;

/*!
 @method slaClicked
 
 @brief This will gives List of all SLA plans.
 
 @code
 
 -(IBAction)slaClicked:(id)sender;
 
 @endocde
 */
- (IBAction)slaClicked:(id)sender;


//- (IBAction)deptClicked:(id)sender;

//- (IBAction)assignClicked:(id)sender;



/*!
 @method saveClicked
 
 @brief It will save the ticket details modified by user.
 
 @code
 
 - (IBAction)saveClicked:(id)sender;
 
 @endocde
 */
- (IBAction)saveClicked:(id)sender;

/*!
 @method priorityClicked
 
 @brief This will gives List of all ticket priority list.
 
 @code
 
 - (IBAction)priorityClicked:(id)sender;
 
 @endocde
 */
- (IBAction)priorityClicked:(id)sender;




//@property (nonatomic, strong) NSMutableArray * assignArray;
//@property (weak, nonatomic) IBOutlet UITextField *assinTextField;

/*!
 @property subjectTextView
 
 @brief This is an textField property
 
 @discussion It used to accept the subject value for the ticket.
 */
@property (weak, nonatomic) IBOutlet UITextView *subjectTextView;


@end

