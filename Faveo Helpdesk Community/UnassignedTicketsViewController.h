//
//  UnassignedTicketsViewController.h
//  SideMEnuDemo
//
//  Created by Narendra on 01/09/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface UnassignedTicketsViewController :UIViewController<SlideNavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>
-(void)addBtnPressed;
@end
