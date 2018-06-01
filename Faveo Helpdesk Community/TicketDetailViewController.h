//
//  TicketDetailViewController.h
//  SideMEnuDemo
//
//  Created by Narendra on 07/09/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)indexChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblTicketNumber;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) UIViewController *currentViewController;

@property(nonatomic,strong) NSString *ticketNumber;

@end
