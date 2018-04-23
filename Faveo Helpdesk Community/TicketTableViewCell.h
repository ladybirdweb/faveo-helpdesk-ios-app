//
//  TicketTableViewCell.h
//  SideMEnuDemo
//
//  Created by Narendra on 19/08/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
/*!
 @class TicketTableViewCell
 
 @brief It allows you to develop Graphical User Interface.
 
 @discussion This class used for designing and showing a ticket which is in table view format.
 A table view uses cell objects to draw its visible rows and then caches those objects as long as the rows are visible. Cells inherit from the UITableViewCell class. The table view’s data source provides the cell objects to the table view by implementing the tableView:cellForRowAtIndexPath: method, a required method of the UITableViewDataSource protocol.
 */
@interface TicketTableViewCell : UITableViewCell

/*!
 @property profilePicView
 
 @brief It used for diplaying image of a user.
 
 @discussion It is an object that displays a single image or a sequence of animated images in your interface.
 */
@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;

/*!
 @property indicationView
 
 @brief An indicator is a spinning wheel that indicates a task is being processed. if an action takes an unknown amount of time to process you should display an activity indicator to let the user know your app is not frozen.
 */
@property (weak, nonatomic) IBOutlet UIView *indicationView;
/*!
 @property ticketIdLabel
 
 @brief It used for definig ticket id.
 */
@property (weak, nonatomic) IBOutlet UILabel *ticketIdLabel;

/*!
 @property timeStampLabel
 
 @brief It used for definig ticket stamp.
 */
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;

/*!
 @property mailIdLabel
 
 @brief It used for definig email id of user.
 */
@property (weak, nonatomic) IBOutlet UILabel *mailIdLabel;

/*!
 @property ticketSubLabel
 
 @brief It used for definig ticket sub label.
 */
@property (weak, nonatomic) IBOutlet UILabel *ticketSubLabel;

/*!
 @property overDueLabel
 
 @brief It used for definig ticket overdue.
 */
@property (weak, nonatomic) IBOutlet UILabel *overDueLabel;


/*!
 @method setUserProfileimage
 
 @param imageUrl This in an url which in string format.
 
 @discussion This method used for displaying a profile picture of a user. It uses a url, and from that url it takes an image and displayed in view.
 
 @code
 [self.profilePicView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
 placeholderImage:[UIImage imageNamed:@"default_pic.png"]];
 */
-(void)setUserProfileimage:(NSString*)imageUrl;
@property (weak, nonatomic) IBOutlet UILabel *today;

@property (weak, nonatomic) IBOutlet UIImageView *sourceImgView;

@property (weak, nonatomic) IBOutlet UIImageView *ccImgView;

@property (weak, nonatomic) IBOutlet UIImageView *attachImgView;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UILabel *agentLabel;

@end

