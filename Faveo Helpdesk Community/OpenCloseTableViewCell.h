//
//  OpenCloseTableViewCell.h
//  SideMEnuDemo
//
//  Created by Narendra on 25/10/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenCloseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ticketNumberLbl;
@property (weak, nonatomic) IBOutlet UILabel *ticketSubLbl;
@property (weak, nonatomic) IBOutlet UIView *indicationView;

@end
