//
//  LoginViewController.h
//  SideMEnuDemo
//
//  Created by Narendra on 18/08/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQPreviousNextView.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>

- (IBAction)urlButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *companyURLview;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)btnLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passcodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *urlTextfield;

@end
