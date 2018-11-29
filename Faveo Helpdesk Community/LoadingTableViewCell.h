//
//  LoadingTableViewCell.h
//  SideMEnuDemo

//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
/*!
 @class LoadingTableViewCell
 
 @brief It allows you to develop Graphical User Interface.
 
 @discussion This class used for showing loader (Activity Indicator).
 An activity indicator is a spinning wheel that indicates a task is being processed. if an action takes an unknown amount of time to process you should display an activity indicator to let the user know your app is not frozen.
 
 @superclass UITableViewCell
 */
@interface LoadingTableViewCell : UITableViewCell

/*!
 @property loadingLbl
 
 @brief It is an label used for definig ticket number.
 */
@property (weak, nonatomic) IBOutlet UILabel *loadingLbl;

/*!
 @property indicator.
 
 @brief This is loader.
 
 @discussion An activity indicator is a spinning wheel that indicates a task is being processed. if an action takes an unknown amount of time to process you should display an activity indicator to let the user know your app is not frozen.
 */
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
