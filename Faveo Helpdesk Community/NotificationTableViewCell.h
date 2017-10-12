//
//  NotificationTableViewCell.h
//  Faveo Helpdesk Pro
//
//  Created by Narendra on 14/07/17.
//  Copyright © 2017 Ladybird websolutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;

@property (weak, nonatomic) IBOutlet UILabel *timelbl;

@property (weak, nonatomic) IBOutlet UILabel *msglbl;

@property (weak, nonatomic) IBOutlet UIView *indicationView;

@property (weak, nonatomic) IBOutlet UILabel *name;

-(void)setUserProfileimage:(NSString*)imageUrl;

@end
