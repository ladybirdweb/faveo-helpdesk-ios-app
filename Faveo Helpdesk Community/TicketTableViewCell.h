//
//  TicketTableViewCell.h
//  SideMEnuDemo
//
//  Created by Narendra on 19/08/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;
@property (weak, nonatomic) IBOutlet UILabel *ticketIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UILabel *mailIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketSubLabel;
-(void)setUserProfileimage:(NSString*)imageUrl;
@end
