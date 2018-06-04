//
//  ConversationTableViewCell.h
//  SideMEnuDemo
//
//  Created by Narendra on 25/10/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConversationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePicView;
@property (weak, nonatomic) IBOutlet UILabel *clientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *internalNoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
-(void)setUserProfileimage:(NSString*)imageUrl;
@end
