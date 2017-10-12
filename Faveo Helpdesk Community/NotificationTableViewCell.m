//
//  NotificationTableViewCell.m
//  Faveo Helpdesk Pro
//
//  Created by Narendra on 14/07/17.
//  Copyright © 2017 Ladybird websolutions pvt ltd. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "HexColors.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation NotificationTableViewCell

-(void)setUserProfileimage:(NSString*)imageUrl
{
    
    
    self.profilePicView.layer.borderWidth=1.25f;
    self.profilePicView.layer.borderColor=[[UIColor hx_colorWithHexRGBAString:@"#0288D1"] CGColor];
    [self.profilePicView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                           placeholderImage:[UIImage imageNamed:@"default_pic.png"]];
}

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
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}


@end

