//
//  LoadingTableViewCell.h
//  SideMEnuDemo
//
//  Created by Narendra on 05/12/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *loadingLbl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
