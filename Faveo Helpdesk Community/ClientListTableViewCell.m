//
//  ClientListTableViewCell.m
//  SideMEnuDemo

//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import "ClientListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HexColors.h"


@implementation ClientListTableViewCell


//It will prepares the receiver for service after it has been loaded from an Interface Builder archive, or nib file.
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   // self.profilePicView.layer.borderWidth=1.25f;
    self.profilePicView.layer.borderColor=[[UIColor hx_colorWithHexRGBAString:@"#0288D1"] CGColor];
    self.profilePicView.layer.cornerRadius = 57/2;
    self.profilePicView.clipsToBounds = YES;
}

// It sets the selected state of the cell, optionally animating the transition between states.
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//This method used for displaying a profile picture of a user. It uses a url, and from that url it takes an image and displayed in view.
-(void)setUserProfileimage:(NSString*)imageUrl
{
    [self.profilePicView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                           placeholderImage:[UIImage imageNamed:@"default_pic.png"]];
}

@end
