//
//  OpenCloseTableViewCell.h
//  SideMEnuDemo

//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
/*!
 @class OpenCloseTableViewCell
 
 @brief It allows you to develop Graphical User Interface.
 
 @discussion This class used for designing and showing open or closed tickets in table view format.
 A table view uses cell objects to draw its visible rows and then caches those objects as long as the rows are visible. Cells inherit from the UITableViewCell class. The table view’s data source provides the cell objects to the table view by implementing the tableView:cellForRowAtIndexPath: method, a required method of the UITableViewDataSource protocol.
 */
@interface OpenCloseTableViewCell : UITableViewCell

/*!
 @property ticketNumberLbl
 
 @brief It is label used for definig ticket number.
 */
@property (weak, nonatomic) IBOutlet UILabel *ticketNumberLbl;

/*!
 @property ticketSubLbl
 
 @brief It is label used for definig ticket sub label.
 */
@property (weak, nonatomic) IBOutlet UILabel *ticketSubLbl;

/*!
 @property indicationView
 
 @brief It an view used for displaying Activity indicator/loader.
 
 @discussion An activity indicator is a spinning wheel that indicates a task is being processed. if an action takes an unknown amount of time to process you should display an activity indicator to let the user know your app is not frozen.
 */
@property (weak, nonatomic) IBOutlet UIView *indicationView;

@end
