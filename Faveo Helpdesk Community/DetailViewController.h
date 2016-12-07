//
//  DetailViewController.h
//  SideMEnuDemo
//
//  Created by Narendra on 16/09/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *clientNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *helpTopicTextField;
@property (weak, nonatomic) IBOutlet UITextField *slaTextField;
@property (weak, nonatomic) IBOutlet UITextField *deptTextField;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UITextField *statusTextField;
@property (weak, nonatomic) IBOutlet UITextField *priorityTextField;
@property (weak, nonatomic) IBOutlet UITextField *sourceTextField;
@property (weak, nonatomic) IBOutlet UITextField *dueDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *createdDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastResponseDateTextField;

@property (nonatomic, strong) NSArray * helptopicsArray;
@property (nonatomic, strong) NSArray * slaPlansArray;
@property (nonatomic, strong) NSArray * deptArray;
@property (nonatomic, strong) NSArray * priorityArray;
@property (nonatomic, strong) NSArray * sourceArray;
@property (nonatomic, strong) NSArray * statusArray;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;


@property (nonatomic, assign) NSInteger selectedIndex;

- (IBAction)sourceClicked:(id)sender;
- (IBAction)statusClicked:(id)sender;
- (IBAction)helpTopicClicked:(id)sender;
- (IBAction)slaClicked:(id)sender;
- (IBAction)deptClicked:(id)sender;
- (IBAction)priorityClicked:(id)sender;
- (IBAction)saveClicked:(id)sender;

@end
