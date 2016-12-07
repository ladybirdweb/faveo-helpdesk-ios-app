//
//  ClientListTableViewCell.h
//  SideMEnuDemo
//
//  Created by Narendra on 02/09/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *clientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;
-(void)setUserProfileimage:(NSString*)imageUrl;
@end
