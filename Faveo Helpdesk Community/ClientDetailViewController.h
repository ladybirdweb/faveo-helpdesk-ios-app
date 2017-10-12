//


#import <UIKit/UIKit.h>

/*!
 @class ClientDetailViewController
 
 @brief This class display detail information about client.
 
 @discussion Here you can see details of clients like Client Name, Contact Number, Profile Picture of a client and email if a client.
 
 */


@interface ClientDetailViewController : UIViewController

/*!
 @property tableView
 
 @brief This is an instance of Table View.
 
 @discussion Table views are versatile user interface objects frequently found in iOS apps. A table view presents data in a scrollable list of multiple rows that may be divided into sections.
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/*!
 @property testingLAbel
 
 @brief This property in string format used for testing.
 */
@property (weak, nonatomic) IBOutlet UILabel *testingLAbel;

/*!
 @property clientNameLabel
 
 @brief This property in string format defines name of client.
 */
@property (weak, nonatomic) IBOutlet UILabel *clientNameLabel;

/*!
 @property emailLabel
 
 @brief This property in string format defines email of client.
 */
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

/*!
 @property testingLAbel
 
 @brief This is name label for showing label of a phone.
 */
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

/*!
 @property profileImageView
 
 @brief This property used for showing profile picture of user.
 
 @discussion Image views let you efficiently draw any image that can be specified using a
 UIImage object.
 For example, you can use the UIImageView class to display the contents of many standard image files, such as JPEG and PNG files. You can configure image views programmatically or in your storyboard file and change the images they display at runtime
 */
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;


/*!
 @property imageURL
 
 @brief This property used for holding an url which is string fromat.
 */
@property (strong,nonatomic) NSString *imageURL;

/*!
 @method setUserProfileimage
 
 @brief This method used for setting an profile picture of user.
 
 @discussion Here we use url path of image where it is located so that using that url path it will show an profile picture of an user.
 
 @param imageUrl This contains an url.
 
 @code
 
 [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
 placeholderImage:[UIImage imageNamed:@"default_pic.png"]];
 
 @endcode
 */
-(void)setUserProfileimage:(NSString*)imageUrl;


/*!
 @property isClientActive
 
 @brief It is an label that shows client is active.
 */
@property(nonatomic,strong) NSString * isClientActive;

/*!
 @property emailID
 
 @brief It is an label that will show email of user.
 */
@property(nonatomic,strong) NSString * emailID;

/*!
 @property phone
 
 @brief It is an label that will show phone number of user.
 */
@property(nonatomic,strong) NSString * phone;

/*!
 @property clientName
 
 @brief It is an label that will show name of client.
 */
@property(nonatomic,strong) NSString * clientName;

/*!
 @property testingLAbel
 
 @brief It is an label that will show id of client.
 */
@property(nonatomic,strong) NSString * clientId;

@end
