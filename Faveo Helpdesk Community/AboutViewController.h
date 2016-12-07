//
//  AboutViewController.h
//  SideMEnuDemo
//
//  Created by Narendra on 07/09/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface AboutViewController :UIViewController<SlideNavigationControllerDelegate>
- (IBAction)btnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *websiteButton;

@end
