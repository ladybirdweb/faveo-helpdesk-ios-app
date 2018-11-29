//
//  TicketTableViewCell.m
//  SideMEnuDemo
//
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import "TicketTableViewCell.h"
#import "HexColors.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation TicketTableViewCell

-(void)setUserProfileimage:(NSString*)imageUrl
{
    
    //  self.profilePicView.layer.borderWidth=1.25f;
    self.profilePicView.layer.borderColor=[[UIColor hx_colorWithHexRGBAString:@"#0288D1"] CGColor];
    [self.profilePicView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                           placeholderImage:[UIImage imageNamed:@"default_pic.png"]];
}

// This method prepares the receiver for service after it has been loaded from an Interface Builder archive, or nib file.
- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:self.indicationView.bounds
                              byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)
                              cornerRadii:CGSizeMake(10, 10)
                              ];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.indicationView.layer.mask = maskLayer;
    
    self.profilePicView.layer.cornerRadius = 25;
    self.profilePicView.clipsToBounds = YES;
    
    self.selectionStyle=UITableViewCellSelectionStyleDefault;
    
    // _viewMain.backgroundColor= [UIColor hx_colorWithHexRGBAString:@"#FAFAFA"];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    

    // Configure the view for the selected state
}

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    if (highlighted) {
//        self.ticketIdLabel.textColor = [UIColor whiteColor];
//    } else {
//        self.ticketIdLabel.textColor = [UIColor darkTextColor];
//    }
//}

@end
