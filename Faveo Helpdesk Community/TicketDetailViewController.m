//
//  TicketDetailViewController.m
//  SideMEnuDemo
//
//  Created by Narendra on 07/09/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import "TicketDetailViewController.h"
#import "CNPPopupController.h"
#import "Utils.h"
#import "HexColors.h"
#import "AppDelegate.h"
#import "AppConstanst.h"
#import "Reachability.h"
#import "MyWebservices.h"
#import "GlobalVariables.h"
#import "FTProgressIndicator.h"

//#import "ReplyViewController.h"

@interface TicketDetailViewController () <CNPPopupControllerDelegate>{
    Utils *utils;
    NSUserDefaults *userDefaults;
    UITextField *textFieldCc;
    UITextView *textViewInternalNote;
    UITextView *textViewReply;
    GlobalVariables *globalVariables;
}

-(void)replyBtnPressed;
-(void)internalNotePressed;
@property (nonatomic, strong) CNPPopupController *popupController;

@end

@implementation TicketDetailViewController

- (void)viewDidLoad {
     [super viewDidLoad];
    self.currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ConversationVC"];
    self.currentViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:self.currentViewController];
    [self addSubview:self.currentViewController.view toView:self.containerView];
    utils=[[Utils alloc]init];
    globalVariables=[GlobalVariables sharedInstance];
    userDefaults=[NSUserDefaults standardUserDefaults];
    self.segmentedControl.tintColor=[UIColor hx_colorWithHexString:@"#00aeef"];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(replyBtnPressed)],[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(internalNotePressed)], nil] animated:YES];
    
    _lblTicketNumber.text=globalVariables.ticket_number;
       // Do any additional setup after loading the view.
}

- (void)addSubview:(UIView *)subView toView:(UIView*)parentView {
    [parentView addSubview:subView];
    
    NSDictionary * views = @{@"subView" : subView,};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|"
                                                                   options:0
                                                                   metrics:0
                                                                     views:views];
    [parentView addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|"
                                                          options:0
                                                          metrics:0
                                                            views:views];
    [parentView addConstraints:constraints];
}

- (void)cycleFromViewController:(UIViewController*) oldViewController
               toViewController:(UIViewController*) newViewController {
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    [self addSubview:newViewController.view toView:self.containerView];
    newViewController.view.alpha = 0;
    [newViewController.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         newViewController.view.alpha = 1;
                         oldViewController.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [oldViewController.view removeFromSuperview];
                         [oldViewController removeFromParentViewController];
                         [newViewController didMoveToParentViewController:self];
                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)replyBtnPressed{

    NSLog(@"Reply Pressed");

    [self showPopupReply:CNPPopupStyleCentered];
    
    
}

//- (void)dismissPopup {
//if (self.popupViewController != nil) {
 //       [self dismissPopupViewControllerAnimated:YES completion:^{
 //           NSLog(@"popup view dismissed");
 //       }];
 //   }
//}

-(void)internalNotePressed{
     [self showPopupInternalNote:CNPPopupStyleCentered];
    NSLog(@"Internal Pressed");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)indexChanged:(id)sender {
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ConversationVC"];
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
         } else {
        UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
        newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self cycleFromViewController:self.currentViewController toViewController:newViewController];
        self.currentViewController = newViewController;
           }
}

- (void)showPopupInternalNote:(CNPPopupStyle)popupStyle {
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Internal Note" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    //    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:@"Message" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    //    NSAttributedString *lineTwo = [[NSAttributedString alloc] initWithString:@"Message" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0], NSParagraphStyleAttributeName : paragraphStyle}];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = title;
    
    //    UILabel *lineOneLabel = [[UILabel alloc] init];
    //    lineOneLabel.numberOfLines = 0;
    //    lineOneLabel.attributedText = lineOne;
    //
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon"]];
    
    UILabel *lineTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    //    lineTwoLabel.numberOfLines = 0;
    lineTwoLabel.textColor=[UIColor hx_colorWithHexString:@"#00aeef"];
    lineTwoLabel.text = @"Message";
    
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 140)];
    //customView.backgroundColor = [UIColor lightGrayColor];
    
    textViewInternalNote = [[UITextView alloc] initWithFrame:CGRectMake(10, 30, 250, 100)];
    
    [ textViewInternalNote setReturnKeyType:UIReturnKeyDone];
    textViewInternalNote.layer.cornerRadius=4;
     textViewInternalNote.layer.borderWidth=1.0F;
     textViewInternalNote.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    
    [customView addSubview: textViewInternalNote];
    [customView addSubview:lineTwoLabel];
    
    CNPPopupButton *button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor hx_colorWithHexString:@"#00aeef"];
    button.layer.cornerRadius = 4;
    button.selectionHandler = ^(CNPPopupButton *button){
        if ( textViewInternalNote.text.length!=0) {
            [self postInternalNote];
            [self.popupController dismissPopupControllerAnimated:YES];
            NSLog(@"Message of InternalNote: %@",  textViewInternalNote.text);
        }else {
           
        }
    };
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[titleLabel, customView, button]];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
}

- (void)showPopupReply:(CNPPopupStyle)popupStyle {
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Ticket Reply" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:@"Cc" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor hx_colorWithHexString:@"#00aeef"]}];
    NSMutableAttributedString *lineTwo = [[NSMutableAttributedString alloc] initWithString:@"Message*" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor hx_colorWithHexString:@"#00aeef"]}];
    [lineTwo addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(7,1)];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = title;
    
    //    UILabel *lineOneLabel = [[UILabel alloc] init];
    //    lineOneLabel.numberOfLines = 0;
    //    lineOneLabel.attributedText = lineOne;
    //
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon"]];
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 200)];
    //customView.backgroundColor = [UIColor lightGrayColor];
    
    
    UILabel *lineTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    //    lineTwoLabel.numberOfLines = 0;
    //lineTwoLabel.textColor=[UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    lineTwoLabel.attributedText = lineOne;
    
    textFieldCc=[[UITextField alloc]initWithFrame:CGRectMake(10, 30, 250, 30)];
    [textFieldCc setBorderStyle:UITextBorderStyleNone];
    textFieldCc.layer.cornerRadius=4;
    textFieldCc.layer.borderWidth=1.0F;
    textFieldCc.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    
    
    UILabel *lineTwoLabe2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, 100, 20)];
    //    lineTwoLabel.numberOfLines = 0;
    //lineTwoLabe2.textColor=[UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    lineTwoLabe2.attributedText = lineTwo;
    
    textViewReply = [[UITextView alloc] initWithFrame:CGRectMake(10, 90, 250, 100)];
    [textViewReply setReturnKeyType:UIReturnKeyDone];
    textViewReply.layer.cornerRadius=4;
    textViewReply.layer.borderWidth=1.0F;
    textViewReply.layer.borderColor=[[UIColor grayColor] CGColor];
    
    [customView addSubview:textViewReply];
    [customView addSubview:textFieldCc];
    [customView addSubview:lineTwoLabel];
    [customView addSubview:lineTwoLabe2];
    
    
    CNPPopupButton *button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor hx_colorWithHexString:@"#00aeef"];
    button.layer.cornerRadius = 4;
    
    button.selectionHandler = ^(CNPPopupButton *button){
        if (textViewReply.text.length!=0) {
            [self postReply];
            
            [self.popupController dismissPopupControllerAnimated:YES];
            NSLog(@"Reply Message: %@, Cc: %@", textViewReply.text,textFieldCc.text);
        }else {
           
        }
    };
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[titleLabel, customView, button]];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
}

-(void)postInternalNote{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        [utils showAlertWithMessage:NO_INTERNET sendViewController:self];
        
    }else{
        
       // [[AppDelegate sharedAppdelegate] showProgressView];
         [FTProgressIndicator showProgressWithMessage:@"Please wait" userInteractionEnable:NO];
        
        
        NSString *url=[NSString stringWithFormat:@"%@helpdesk/internal-note?api_key=%@&ip=%@&token=%@&userid=%@&body=%@&ticketid=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"],[userDefaults objectForKey:@"user_id"],textViewInternalNote.text,globalVariables.iD];
        
        MyWebservices *webservices=[MyWebservices sharedInstance];
        
        [webservices httpResponsePOST:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
            //[[AppDelegate sharedAppdelegate] hideProgressView];
            if (error || [msg containsString:@"Error"]) {
                [FTProgressIndicator dismiss];
                
                [utils showAlertWithMessage:msg sendViewController:self];
                NSLog(@"Thread-NO4-postCreateTicket-Refresh-error == %@",error.localizedDescription);
                return ;
            }
            
            if ([msg isEqualToString:@"tokenRefreshed"]) {
                
                [self postInternalNote];
                NSLog(@"Thread--NO4-call-postCreateTicket");
                return;
            }
            
            if (json) {
                NSLog(@"JSON-CreateTicket-%@",json);
                
                [FTProgressIndicator dismiss];
                
                if ([json objectForKey:@"thread"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                       // [utils showAlertWithMessage:@"Kindly Refresh!!" sendViewController:self];
                        TicketDetailViewController *td=[self.storyboard instantiateViewControllerWithIdentifier:@"TicketDetailVCID"];
                        
                        [self.navigationController pushViewController:td animated:YES];
                        
                    });
                }
            }
            NSLog(@"Thread-NO5-postCreateTicket-closed");
            
        }];
    }
}


-(void)postReply{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        [utils showAlertWithMessage:NO_INTERNET sendViewController:self];
        
    }else{
        
       // [[AppDelegate sharedAppdelegate] showProgressView];
        
       [FTProgressIndicator showProgressWithMessage:@"Please wait" userInteractionEnable:NO];
        
        NSString *url=[NSString stringWithFormat:@"%@helpdesk/reply?api_key=%@&ip=%@&token=%@&reply_content=%@&ticket_ID=%@&cc=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"],textViewReply.text,globalVariables.iD,textFieldCc.text];
        
        MyWebservices *webservices=[MyWebservices sharedInstance];
        
        
        [webservices httpResponsePOST:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
           // [[AppDelegate sharedAppdelegate] hideProgressView];
            if (error || [msg containsString:@"Error"]) {
                
                [FTProgressIndicator dismiss];
                
                [utils showAlertWithMessage:msg sendViewController:self];
                NSLog(@"Thread-NO4-postCreateTicket-Refresh-error == %@",error.localizedDescription);
                return ;
            }
            
            if ([msg isEqualToString:@"tokenRefreshed"]) {
                
                [self postReply];
                NSLog(@"Thread--NO4-call-postCreateTicket");
                return;
            }
            
            if (json) {
                NSLog(@"JSON-CreateTicket-%@",json);
                [FTProgressIndicator dismiss];
                if ([json objectForKey:@"result"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //[utils showAlertWithMessage:@"Kindly Refresh!" sendViewController:self];
                        TicketDetailViewController *td=[self.storyboard instantiateViewControllerWithIdentifier:@"TicketDetailVCID"];
                        
                        [self.navigationController pushViewController:td animated:YES];
                    });
                }
                
            }
            NSLog(@"Thread-NO5-postCreateTicket-closed");
            
        }];
    }
}
@end
