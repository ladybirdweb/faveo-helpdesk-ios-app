
#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

/*!
 @class CreateTicketViewController
 
 @brief This class contain Ticket  create process.
 
 @discussion Here  we can create a ticket by filling some necessary information. After filling valid infomation, ticket will be crated.
 */

@interface CreateTicketViewController : UITableViewController<SlideNavigationControllerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

/*!
 @property textViewMsg
 
 @brief Using this user can write multiple lines of messages even paragraph also.
 
 @discussion UITextView supports the display of text using custom style information and also supports text editing. You typically use a text view to display multiple lines of text, such as when displaying the body of a large text document.
 */

@property (weak, nonatomic) IBOutlet UITextView *textViewMsg;

/*!
 @property emailTextField
 
 @brief It is textfiled that allows a user to enter his email address.
 */
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextView *emailTextView;

/*!
 @property firstNameTextField
 
 @brief It is textfiled that allows a user to enter his first name.
 */
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *firstNameView;

/*!
 @property lastNameTextField
 
 @brief It is textfiled that allows a user to enter his last name.
 */
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *lastNameView;

/*!
 @property codeTextField
 
 @brief It is textfiled that allows a user to enter country code of a mobile or phone.
 */
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

/*!
 @property mobileTextField
 
 @brief It is textfiled that allows a user to enter his mobile number.
 */
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextView *mobileView;

/*!
 @property helpTopicTextField
 
 @brief It is textfiled that allows a user to enter Help Topic name.
 */
@property (weak, nonatomic) IBOutlet UITextField *helpTopicTextField;

/*!
 @property slaTextField
 
 @brief It is textfiled that allows a user to enter SLA plan.
 */
@property (weak, nonatomic) IBOutlet UITextField *slaTextField;

/*!
 @property deptTextField
 
 @brief It is textfiled that allows a user to enter Department.
 */
@property (weak, nonatomic) IBOutlet UITextField *deptTextField;

/*!
 @property subjectTextField
 
 @brief It is textfiled that allows a user to write a subject.
 */

@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
//@property (weak, nonatomic) IBOutlet UITextField *msgTextField;
@property (weak, nonatomic) IBOutlet UITextView *subjectView;

/*!
 @property priorityTextField
 
 @brief It is textfiled allows to select priority.
 */

@property (weak, nonatomic) IBOutlet UITextField *priorityTextField;

@property (weak, nonatomic) IBOutlet UITextField *assignTextField;

/*!
 @property submitButton
 
 @brief This is a button property.
 
 @discussion When you tap a button, or select a button that has focus, the button performs any actions attached to it. You communicate the purpose of a button using a text label, an image, or both.
 */
@property (weak, nonatomic) IBOutlet UIButton *submitButton;


/*!
 @property helptopicsArray
 
 @brief This is array that represents list of Help Topics.
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSArray * helptopicsArray;

/*!
 @property slaPlansArray
 
 @brief This is array that represents list of SLA plans.
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSArray * slaPlansArray;

/*!
 @property deptArray
 
 @brief This is array that represents list of Departments.
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSArray * deptArray;

/*!
 @property priorityArray
 
 @brief This is array that represents list of Priorities.
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSArray * priorityArray;

/*!
 @property countryArray
 
 @brief This is array that represents list of Country names.
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSArray * countryArray;

/*!
 @property codeArray
 
 @brief This is array that represents list of Country Codes.
 
 @discussion An object representing a static ordered collection, for use instead of an Array constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSArray * codeArray;

@property (nonatomic, strong) NSMutableArray * staffArray;

/*!
 @property countryDic
 
 @brief This is Dictionary that represents list of Country Names.
 
 @discussion An object representing a static collection of key-value pairs, for use instead ofa Dictionary constant in cases that require reference semantics.
 */
@property (nonatomic, strong) NSDictionary * countryDic;

/*!
 @property selectedIndex
 
 @brief It is an interger number that indicates an Index.
 */
@property (nonatomic, assign) NSInteger selectedIndex;


/*!
 @method helpTopicClicked
 
 @brief It will gives List of Help Topics.
 
 @discussion After clicking this button it will show list of help topics.
 
 The help topics can be Support Query, Sales Query or Operational Query.
 
 @code
 
 - (IBAction)helpTopicClicked:(id)sender;
 
 @endcode
 
 */

- (IBAction)helpTopicClicked:(id)sender;

/*!
 @method slaClicked
 
 @brief This will gives List of SLA plans.
 
 @discussion After clicking this button it will shows list of SLA plans.The SLA plan can be Emergency, High, Low or normal.
 
 @code
 
 - (IBAction)slaClicked:(id)sender;
 
 @endcode
 
 */
- (IBAction)slaClicked:(id)sender;

/*!
 @method deptClicked
 
 @brief This will gives List of Departments.
 
 @discussion AFter clicking this button it will gives a list of all Departments.The department can be Operation, Sales, Support.
 
 @code
 
 - (IBAction)deptClicked:(id)sender;
 
 @endcode
 
 */
- (IBAction)deptClicked:(id)sender;

/*!
 @method priorityClicked
 
 @brief This will gives List of Ticket Priorities.
 
 @discussion After clicking this button whatever we done any chnages in ticket, it will save and updated in ticket details.
 
 @code
 
 - (IBAction)priorityClicked:(id)sender;
 
 @endocde
 */

- (IBAction)priorityClicked:(id)sender;

/*!
 @method submitClicked
 
 @brief This is an button that perform an action.
 
 @discussion  After cicking this submit button, the data enetered in textfiled while ticket creation will be saved.
 
 @code
 
 - (IBAction)submitClicked:(id)sender;
 
 @endcode
 
 */
- (IBAction)submitClicked:(id)sender;

/*!
 @method countryCodeClicked
 
 @brief This will gives List of all country codes.
 
 @code
 
 - (IBAction)countryCodeClicked:(id)sender;
 
 @endocde
 */


- (IBAction)staffClicked:(id)sender;

- (IBAction)countryCodeClicked:(id)sender;


@end

