//
//  ClientListTableViewCell.h
//  SideMEnuDemo

//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
/*!
 @class ClientListTableViewCell
 
 @brief It allows you to develop Graphical User Interface.
 
 @discussion This class used for designing and displaying List of Clients in table view format.
 A table view uses cell objects to draw its visible rows and then caches those objects as long as the rows are visible. Cells inherit from the UITableViewCell class. The table view’s data source provides the cell objects to the table view by implementing the tableView:cellForRowAtIndexPath: method, a required method of the UITableViewDataSource protocol.
 */
@interface ClientListTableViewCell : UITableViewCell

/*!
 @property clientNameLabel
 
 @brief It is label used for definig name of user.
 */
@property (weak, nonatomic) IBOutlet UILabel *clientNameLabel;

/*!
 @property emailIdLabel
 
 @brief It is label used for definig email id of user.
 */
@property (weak, nonatomic) IBOutlet UILabel *emailIdLabel;

/*!
 @property phoneNumberLabel
 
 @brief It is label used for definig phone number of user.
 */
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

/*!
 @property profilePicView
 
 @brief It is an view used for displying profile picture of user.
 */
@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;

/*!
 @method setUserProfileimage
 
 @param imageUrl This in an url which in string format.
 
 @discussion This method used for displaying a profile picture of a user. It uses a url, and from that url it takes an image and displayed in view.
 
 @code
 [self.profilePicView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
 placeholderImage:[UIImage imageNamed:@"default_pic.png"]];
 */
-(void)setUserProfileimage:(NSString*)imageUrl;
@end
