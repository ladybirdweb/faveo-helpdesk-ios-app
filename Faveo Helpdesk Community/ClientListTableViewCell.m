//
//  ClientListTableViewCell.m
//  SideMEnuDemo
//
//  Created by Narendra on 02/09/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import "ClientListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HexColors.h"
@implementation ClientListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   // self.profilePicView.layer.borderWidth=1.25f;
    self.profilePicView.layer.borderColor=[[UIColor hx_colorWithHexRGBAString:@"#0288D1"] CGColor];
    self.profilePicView.layer.cornerRadius = 57/2;
    self.profilePicView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUserProfileimage:(NSString*)imageUrl
{
    [self.profilePicView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                           placeholderImage:[UIImage imageNamed:@"default_pic.png"]];
}

@end
