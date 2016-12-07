//
//  InboxViewController.h
//  SideMEnuDemo
//
//  Created by Narendra on 19/08/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface InboxViewController : UIViewController<SlideNavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>

-(void)addBtnPressed;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
