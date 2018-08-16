//
//  CreateTicketViewController.m

#import "InboxViewController.h"
#import "CreateTicketViewController.h"
#import "LeftMenuViewController.h"
#import "ActionSheetStringPicker.h"
#import "HexColors.h"
#import "Utils.h"
#import "Reachability.h"
#import "AppConstanst.h"
#import "MyWebservices.h"
#import "AppDelegate.h"
#import "RKDropdownAlert.h"
#import "IQKeyboardManager.h"
#import "Dat.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "GlobalVariables.h"


@interface CreateTicketViewController ()<RMessageProtocol>{
    
    Utils *utils;
    NSUserDefaults *userDefaults;
    GlobalVariables *globalVariables;
    
    NSNumber *sla_id;
    NSNumber *help_topic_id;
//    NSNumber *dept_id;
    NSNumber *priority_id;
 //   NSNumber *staff_id;
    
    NSMutableArray * sla_idArray;
//    NSMutableArray * dept_idArray;
    NSMutableArray * pri_idArray;
    NSMutableArray * helpTopic_idArray;
//    NSMutableArray * staff_idArray;
    
    NSDictionary *priDicc1;
}

- (void)helpTopicWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)slaWasSelected:(NSNumber *)selectedIndex element:(id)element;
//- (void)deptWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)priorityWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)countryCodeWasSelected:(NSNumber *)selectedIndex element:(id)element;
//- (void)staffWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)actionPickerCancelled:(id)sender;

@end

@implementation CreateTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self split];
    
    UIToolbar *toolBar= [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *removeBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain  target:self action:@selector(removeKeyBoard)];
    
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolBar setItems:[NSArray arrayWithObjects:space,removeBtn, nil]];
    [self.textViewMsg setInputAccessoryView:toolBar];
    [self.mobileView setInputAccessoryView:toolBar];
    [self.subjectView setInputAccessoryView:toolBar];
    [self.firstNameView setInputAccessoryView:toolBar];
    [self.lastNameView setInputAccessoryView:toolBar];
    [self.emailTextView setInputAccessoryView:toolBar];
    
    
    
    
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:false];
    sla_id=[[NSNumber alloc]init];
 //   dept_id=[[NSNumber alloc]init];
    help_topic_id=[[NSNumber alloc]init];
    priority_id=[[NSNumber alloc]init];
 //   staff_id =[[NSNumber alloc]init];
    
    utils=[[Utils alloc]init];
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    globalVariables=[GlobalVariables sharedInstance];
    //_codeTextField.text=[self setDefaultCountryCode];
    
    [self readFromPlist];
    
    [self setTitle:NSLocalizedString(@"CreateTicket",nil)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _submitButton.backgroundColor=[UIColor hx_colorWithHexRGBAString:@"#00aeef"];
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    // _submitButton.userInteractionEnabled = false;
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:true];
    
}
-(void)readFromPlist{
//    // Read plist from bundle and get Root Dictionary out of it
//    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsPath = [paths objectAtIndex:0];
//    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"faveoData.plist"];
//
    @try{
//        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
//        {
//            plistPath = [[NSBundle mainBundle] pathForResource:@"faveoData" ofType:@"plist"];
//        }
    
     //   NSDictionary *resultDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        NSDictionary *resultDic = globalVariables.dependencyDataDict;
        
        NSLog(@"resultDic--%@",resultDic);
     //   NSArray *deptArray=[resultDic objectForKey:@"departments"];
        NSArray *helpTopicArray=[resultDic objectForKey:@"helptopics"];
        NSArray *prioritiesArray=[resultDic objectForKey:@"priorities"];
        NSArray *slaArray=[resultDic objectForKey:@"sla"];
     //   NSArray *sourcesArray=[resultDic objectForKey:@"sources"];
     //   NSMutableArray *staffsArray=[resultDic objectForKey:@"staffs"];
     //   NSArray *statusArray=[resultDic objectForKey:@"status"];
     //   NSArray *teamArray=[resultDic objectForKey:@"teams"];
  
        //     NSLog(@"resultDic2--%@,%@,%@,%@,%@,%@,%@,%@",deptArray,helpTopicArray,prioritiesArray,slaArray,sourcesArray,staffsArray,statusArray,teamArray);
        
    //    NSMutableArray *deptMU=[[NSMutableArray alloc]init];
        NSMutableArray *slaMU=[[NSMutableArray alloc]init];
        NSMutableArray *helptopicMU=[[NSMutableArray alloc]init];
        NSMutableArray *priMU=[[NSMutableArray alloc]init];
     //   NSMutableArray *staffMU=[[NSMutableArray alloc]init];
        
    //    dept_idArray=[[NSMutableArray alloc]init];
        sla_idArray=[[NSMutableArray alloc]init];
        helpTopic_idArray=[[NSMutableArray alloc]init];
        pri_idArray=[[NSMutableArray alloc]init];
     //   staff_idArray=[[NSMutableArray alloc]init];
        
        
        
     //   [staffMU insertObject:@"Select Assignee" atIndex:0];
     //   [staff_idArray insertObject:@"" atIndex:0];
        
        
//        for (NSMutableDictionary *dicc in staffsArray) {
//            if ([dicc objectForKey:@"email"]) {
//
//                // [staffMU insertObject:@"" atIndex:0];
//                [staffMU addObject:[dicc objectForKey:@"email"]];
//                [staff_idArray addObject:[dicc objectForKey:@"id"]];
//
//            }
//
//        }
        
        
//        for (NSDictionary *dicc in deptArray) {
//            if ([dicc objectForKey:@"name"]) {
//
//                [deptMU addObject:[dicc objectForKey:@"name"]];
//                [dept_idArray addObject:[dicc objectForKey:@"id"]];
//            }
//
//        }
//
        priDicc1=[NSDictionary dictionaryWithObjects:priMU forKeys:pri_idArray];
        
        
        for (NSDictionary *dicc in prioritiesArray) {
            if ([dicc objectForKey:@"priority"]) {
                [priMU addObject:[dicc objectForKey:@"priority"]];
                [pri_idArray addObject:[dicc objectForKey:@"priority_id"]];
            }
            
        }
        
        for (NSDictionary *dicc in slaArray) {
            if ([dicc objectForKey:@"name"]) {
                [slaMU addObject:[dicc objectForKey:@"name"]];
                [sla_idArray addObject:[dicc objectForKey:@"id"]];
                
            }
            
        }
        
        for (NSDictionary *dicc in helpTopicArray) {
            if ([dicc objectForKey:@"topic"]) {
                [helptopicMU addObject:[dicc objectForKey:@"topic"]];
                [helpTopic_idArray addObject:[dicc objectForKey:@"id"]];
                
            }
        }
        
      //  _deptArray=[deptMU copy];
        _helptopicsArray=[helptopicMU copy];
        _slaPlansArray=[slaMU copy];
        _priorityArray=[priMU copy];
      //  _staffArray=[staffMU copy];
        
    }@catch (NSException *exception)
    {
        // Print exception information
        NSLog( @"NSException caught in readFromPlist method in CreateTicket ViewController" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        return;
    }
    @finally
    {
        // Cleanup, in both success and fail cases
        NSLog( @"In finally block");
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)removeKeyboard{
    [_emailTextView resignFirstResponder];
    // [_mobileTextField resignFirstResponder];
    //  [_msgTextField resignFirstResponder];
    [_subjectView resignFirstResponder];
    [_firstNameView resignFirstResponder];
    
    
}
-(void)removeKeyBoard
{
    
    [self.textViewMsg resignFirstResponder];
    [_mobileView resignFirstResponder];
    [_emailTextView resignFirstResponder];
    [_firstNameView resignFirstResponder];
    [_lastNameView resignFirstResponder];
    [_subjectView resignFirstResponder];
    [_codeTextField resignFirstResponder];
    [_helpTopicTextField resignFirstResponder];
    [_priorityTextField resignFirstResponder];
    [_slaTextField resignFirstResponder];
    
}


//- (IBAction)staffClicked:(id)sender
//{
//    [self removeKeyboard];
//
//    if (!_staffArray||!_staffArray.count) {
//        _assignTextField.text=NSLocalizedString(@"Not Available",nil);
//        staff_id=0;
//    }else{
//
//        [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"Select Assignee",nil) rows:_staffArray initialSelection:0 target:self successAction:@selector(staffWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
//    }
//
//}

//- (IBAction)staffClicked:(id)sender {
//    [self.view endEditing:YES];
//    if (!_staffArray||!_staffArray.count) {
//        _assignTextField.text=NSLocalizedString(@"Not Available",nil);
//        staff_id=0;
//    }else{
//
//        [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"Select Assignee",nil) rows:_staffArray initialSelection:0 target:self successAction:@selector(staffWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
//    }
//}

- (IBAction)countryCodeClicked:(id)sender {
    [self.view endEditing:YES];
    [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"Select CountryCode",nil) rows:_countryArray initialSelection:0 target:self successAction:@selector(countryCodeWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

//- (IBAction)countryCodeClicked:(id)sender {
//    [self removeKeyboard];
//
//    [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"Select CountryCode",nil) rows:_countryArray initialSelection:0 target:self successAction:@selector(countryCodeWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
//}

- (IBAction)helpTopicClicked:(id)sender {
    [self.view endEditing:YES];
    if (!_helptopicsArray||!_helptopicsArray.count) {
        _helpTopicTextField.text=NSLocalizedString(@"Not Available",nil);
        help_topic_id=0;
    }else{
        [ActionSheetStringPicker showPickerWithTitle:@"Select Helptopic" rows:_helptopicsArray initialSelection:0 target:self successAction:@selector(helpTopicWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    }
}
- (IBAction)priorityClicked:(id)sender {
    [self.view endEditing:YES];
    if (!_priorityArray||![_priorityArray count]) {
        _priorityTextField.text=NSLocalizedString(@"Not Available",nil);
        priority_id=0;
        
    }else{
        [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"Select Priority",nil) rows:_priorityArray initialSelection:0 target:self successAction:@selector(priorityWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    }
}


//- (IBAction)countryCodeClicked:(id)sender {
//    [self removeKeyboard];
//
//    [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"Select CountryCode",nil) rows:_countryArray initialSelection:0 target:self successAction:@selector(countryCodeWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
//}


//- (IBAction)helpTopicClicked:(id)sender {
//    [self removeKeyboard];
//
//    if (!_helptopicsArray||!_helptopicsArray.count) {
//        _helpTopicTextField.text=NSLocalizedString(@"Not Available",nil);
//        help_topic_id=0;
//    }else{
//        [ActionSheetStringPicker showPickerWithTitle:@"Select Helptopic" rows:_helptopicsArray initialSelection:0 target:self successAction:@selector(helpTopicWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
//    }
//
//}


- (IBAction)slaClicked:(id)sender {
    [self removeKeyboard];
    
    if (!_slaPlansArray||!_slaPlansArray.count) {
        _slaTextField.text=NSLocalizedString(@"Not Available",nil);
        sla_id=0;
    }else{
        [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"Select SLA",nil) rows:_slaPlansArray initialSelection:0 target:self successAction:@selector(slaWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    }
    
}

//- (IBAction)deptClicked:(id)sender {
//    [self removeKeyboard];
//
//    if (!_deptArray||!_deptArray.count) {
//        _deptTextField.text=NSLocalizedString(@"Not Available",nil);
//        dept_id=0;
//    }else{
//        [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"Select Department",nil) rows:_deptArray initialSelection:0 target:self successAction:@selector(deptWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
//    }
//
//}


//
//- (IBAction)priorityClicked:(id)sender {
//    [self removeKeyboard];
//    if (!_priorityArray||![_priorityArray count]) {
//        _priorityTextField.text=NSLocalizedString(@"Not Available",nil);
//        priority_id=0;
//
//    }else{
//        [ActionSheetStringPicker showPickerWithTitle:NSLocalizedString(@"Select Priority",nil) rows:_priorityArray initialSelection:0 target:self successAction:@selector(priorityWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
//    }
//
//}




- (IBAction)submitClicked:(id)sender {
    
    @try{
        
        if(self.emailTextView.text.length==0 && self.firstNameView.text.length==0 && self.helpTopicTextField.text.length==0 && self.subjectView.text.length==0 && self.priorityTextField.text.length==0 && self.textViewMsg.text.length==0 && self.slaTextField.text.length==0)
        {
            if (self.navigationController.navigationBarHidden) {
                [self.navigationController setNavigationBarHidden:NO];
            }
            
            [RMessage showNotificationInViewController:self.navigationController
                                                 title:NSLocalizedString(@"Warning !", nil)
                                              subtitle:NSLocalizedString(@"Please fill all mandatory fields.", nil)
                                             iconImage:nil
                                                  type:RMessageTypeWarning
                                        customTypeName:nil
                                              duration:RMessageDurationAutomatic
                                              callback:nil
                                           buttonTitle:nil
                                        buttonCallback:nil
                                            atPosition:RMessagePositionNavBarOverlay
                                  canBeDismissedByUser:YES];
            
            
        }else if (self.emailTextView.text.length==0){
            //[RKDropdownAlert title:APP_NAME message:NSLocalizedString(@"Please enter EMAIL-ID",nil) backgroundColor:[UIColor hx_colorWithHexRGBAString:ALERT_COLOR] textColor:[UIColor whiteColor]];
            if (self.navigationController.navigationBarHidden) {
                [self.navigationController setNavigationBarHidden:NO];
            }
            
            [RMessage showNotificationInViewController:self.navigationController
                                                 title:NSLocalizedString(@"Warning !", nil)
                                              subtitle:NSLocalizedString(@"Please enter Email.", nil)
                                             iconImage:nil
                                                  type:RMessageTypeWarning
                                        customTypeName:nil
                                              duration:RMessageDurationAutomatic
                                              callback:nil
                                           buttonTitle:nil
                                        buttonCallback:nil
                                            atPosition:RMessagePositionNavBarOverlay
                                  canBeDismissedByUser:YES];
            
            
        }else if(![Utils emailValidation:self.emailTextView.text]){
            // [RKDropdownAlert title:APP_NAME message:NSLocalizedString(@"Invalid EMAIL_ID",nil) backgroundColor:[UIColor hx_colorWithHexRGBAString:ALERT_COLOR] textColor:[UIColor whiteColor]];
            
            if (self.navigationController.navigationBarHidden) {
                [self.navigationController setNavigationBarHidden:NO];
            }
            
            [RMessage showNotificationInViewController:self.navigationController
                                                 title:NSLocalizedString(@"Error !", nil)
                                              subtitle:NSLocalizedString(@"Please enter valid email id.", nil)
                                             iconImage:nil
                                                  type:RMessageTypeWarning
                                        customTypeName:nil
                                              duration:RMessageDurationAutomatic
                                              callback:nil
                                           buttonTitle:nil
                                        buttonCallback:nil
                                            atPosition:RMessagePositionNavBarOverlay
                                  canBeDismissedByUser:YES];
            
        } else if (self.emailTextView.text.length<2) {
            
            //[RKDropdownAlert title:APP_NAME message:NSLocalizedString(@"FirstName should have more than 2 characters",nil) backgroundColor:[UIColor hx_colorWithHexRGBAString:ALERT_COLOR] textColor:[UIColor whiteColor]];
            
            if (self.navigationController.navigationBarHidden) {
                [self.navigationController setNavigationBarHidden:NO];
            }
            
            [RMessage showNotificationInViewController:self.navigationController
                                                 title:NSLocalizedString(@"Warning !", nil)
                                              subtitle:NSLocalizedString(@"FirstName should have more than 2 characters.", nil)
                                             iconImage:nil
                                                  type:RMessageTypeWarning
                                        customTypeName:nil
                                              duration:RMessageDurationAutomatic
                                              callback:nil
                                           buttonTitle:nil
                                        buttonCallback:nil
                                            atPosition:RMessagePositionNavBarOverlay
                                  canBeDismissedByUser:YES];
            
            
        }else /*if (self.mobileTextField.text.length==0) {
               // [RKDropdownAlert title:APP_NAME message:NSLocalizedString(@"Please select HELP-TOPIC",nil) backgroundColor:[UIColor hx_colorWithHexRGBAString:ALERT_COLOR] textColor:[UIColor whiteColor]];
               
               if (self.navigationController.navigationBarHidden) {
               [self.navigationController setNavigationBarHidden:NO];
               }
               
               [RMessage showNotificationInViewController:self.navigationController
               title:NSLocalizedString(@"Warning !", nil)
               subtitle:NSLocalizedString(@"Please enter Mobile...!", nil)
               iconImage:nil
               type:RMessageTypeWarning
               customTypeName:nil
               duration:RMessageDurationAutomatic
               callback:nil
               buttonTitle:nil
               buttonCallback:nil
               atPosition:RMessagePositionNavBarOverlay
               canBeDismissedByUser:YES];
               
               
               }else */ if (self.helpTopicTextField.text.length==0) {
                   // [RKDropdownAlert title:APP_NAME message:NSLocalizedString(@"Please select HELP-TOPIC",nil) backgroundColor:[UIColor hx_colorWithHexRGBAString:ALERT_COLOR] textColor:[UIColor whiteColor]];
                   
                   if (self.navigationController.navigationBarHidden) {
                       [self.navigationController setNavigationBarHidden:NO];
                   }
                   
                   [RMessage showNotificationInViewController:self.navigationController
                                                        title:NSLocalizedString(@"Warning !", nil)
                                                     subtitle:NSLocalizedString(@"Please select HELP-TOPIC.", nil)
                                                    iconImage:nil
                                                         type:RMessageTypeWarning
                                               customTypeName:nil
                                                     duration:RMessageDurationAutomatic
                                                     callback:nil
                                                  buttonTitle:nil
                                               buttonCallback:nil
                                                   atPosition:RMessagePositionNavBarOverlay
                                         canBeDismissedByUser:YES];
                   
                   
               }else if (self.subjectView.text.length==0) {
                   // [RKDropdownAlert title:APP_NAME message:NSLocalizedString(@"Please enter SUBJECT",nil) backgroundColor:[UIColor hx_colorWithHexRGBAString:ALERT_COLOR] textColor:[UIColor whiteColor]];
                   
                   if (self.navigationController.navigationBarHidden) {
                       [self.navigationController setNavigationBarHidden:NO];
                   }
                   
                   [RMessage showNotificationInViewController:self.navigationController
                                                        title:NSLocalizedString(@"Warning !", nil)
                                                     subtitle:NSLocalizedString(@"Please enter SUBJECT.", nil)
                                                    iconImage:nil
                                                         type:RMessageTypeWarning
                                               customTypeName:nil
                                                     duration:RMessageDurationAutomatic
                                                     callback:nil
                                                  buttonTitle:nil
                                               buttonCallback:nil
                                                   atPosition:RMessagePositionNavBarOverlay
                                         canBeDismissedByUser:YES];
                   
               }else if (self.subjectView.text.length<5) {
                   // [RKDropdownAlert title:APP_NAME message:NSLocalizedString(@"SUBJECT requires at least 5 characters",nil) backgroundColor:[UIColor hx_colorWithHexRGBAString:ALERT_COLOR] textColor:[UIColor whiteColor]];
                   if (self.navigationController.navigationBarHidden) {
                       [self.navigationController setNavigationBarHidden:NO];
                   }
                   
                   [RMessage showNotificationInViewController:self.navigationController
                                                        title:NSLocalizedString(@"Warning !", nil)
                                                     subtitle:NSLocalizedString(@"SUBJECT requires at least 5 characters.", nil)
                                                    iconImage:nil
                                                         type:RMessageTypeWarning
                                               customTypeName:nil
                                                     duration:RMessageDurationAutomatic
                                                     callback:nil
                                                  buttonTitle:nil
                                               buttonCallback:nil
                                                   atPosition:RMessagePositionNavBarOverlay
                                         canBeDismissedByUser:YES];
                   
               }else if (self.textViewMsg.text.length==0){
                   // [RKDropdownAlert title:APP_NAME message:NSLocalizedString(@"Please enter ticket MESSAGE" ,nil)backgroundColor:[UIColor hx_colorWithHexRGBAString:ALERT_COLOR] textColor:[UIColor whiteColor]];
                   
                   if (self.navigationController.navigationBarHidden) {
                       [self.navigationController setNavigationBarHidden:NO];
                   }
                   
                   [RMessage showNotificationInViewController:self.navigationController
                                                        title:NSLocalizedString(@"Warning !", nil)
                                                     subtitle:NSLocalizedString(@"Please enter MESSAGE.", nil)
                                                    iconImage:nil
                                                         type:RMessageTypeWarning
                                               customTypeName:nil
                                                     duration:RMessageDurationAutomatic
                                                     callback:nil
                                                  buttonTitle:nil
                                               buttonCallback:nil
                                                   atPosition:RMessagePositionNavBarOverlay
                                         canBeDismissedByUser:YES];
                   
               }else if (self.textViewMsg.text.length<10){
                   // [RKDropdownAlert title:APP_NAME message:NSLocalizedString(@"MESSAGE requires at least 10 characters" ,nil)backgroundColor:[UIColor hx_colorWithHexRGBAString:ALERT_COLOR] textColor:[UIColor whiteColor]];
                   
                   if (self.navigationController.navigationBarHidden) {
                       [self.navigationController setNavigationBarHidden:NO];
                   }
                   
                   [RMessage showNotificationInViewController:self.navigationController
                                                        title:NSLocalizedString(@"Warning !", nil)
                                                     subtitle:NSLocalizedString(@"MESSAGE requires at least 10 characters.", nil)
                                                    iconImage:nil
                                                         type:RMessageTypeWarning
                                               customTypeName:nil
                                                     duration:RMessageDurationAutomatic
                                                     callback:nil
                                                  buttonTitle:nil
                                               buttonCallback:nil
                                                   atPosition:RMessagePositionNavBarOverlay
                                         canBeDismissedByUser:YES];
                   
               }
        /*else if (self.msgTextField.text.length==0){
         [RKDropdownAlert title:APP_NAME message:NSLocalizedString(@"Please enter ticket MESSAGE" ,nil)backgroundColor:[UIColor hx_colorWithHexRGBAString:ALERT_COLOR] textColor:[UIColor whiteColor]];
         // [utils showAlertWithMessage:@"Please enter ticket MESSAGE" sendViewController:self];
         }else if (self.msgTextField.text.length<10){
         [RKDropdownAlert title:APP_NAME message:NSLocalizedString(@"MESSAGE requires at least 10 characters" ,nil)backgroundColor:[UIColor hx_colorWithHexRGBAString:ALERT_COLOR] textColor:[UIColor whiteColor]];
         // [utils showAlertWithMessage:@"Please enter ticket MESSAGE" sendViewController:self];
         }*/ else if (self.priorityTextField.text.length==0){
             // [RKDropdownAlert title:APP_NAME message:NSLocalizedString(@"Please select PRIORITY" ,nil)backgroundColor:[UIColor hx_colorWithHexRGBAString:ALERT_COLOR] textColor:[UIColor whiteColor]];
             
             if (self.navigationController.navigationBarHidden) {
                 [self.navigationController setNavigationBarHidden:NO];
             }
             
             [RMessage showNotificationInViewController:self.navigationController
                                                  title:NSLocalizedString(@"Warning !", nil)
                                               subtitle:NSLocalizedString(@"Please select PRIORITY.", nil)
                                              iconImage:nil
                                                   type:RMessageTypeWarning
                                         customTypeName:nil
                                               duration:RMessageDurationAutomatic
                                               callback:nil
                                            buttonTitle:nil
                                         buttonCallback:nil
                                             atPosition:RMessagePositionNavBarOverlay
                                   canBeDismissedByUser:YES];
             
         }else if (self.slaTextField.text.length==0){
           // [RKDropdownAlert title:APP_NAME message:NSLocalizedString(@"Please select PRIORITY" ,nil)backgroundColor:[UIColor hx_colorWithHexRGBAString:ALERT_COLOR] textColor:[UIColor whiteColor]];
           
           if (self.navigationController.navigationBarHidden) {
           [self.navigationController setNavigationBarHidden:NO];
           }
           
           [RMessage showNotificationInViewController:self.navigationController
           title:NSLocalizedString(@"Warning !", nil)
           subtitle:NSLocalizedString(@"Please select SLA Plan", nil)
           iconImage:nil
           type:RMessageTypeWarning
           customTypeName:nil
           duration:RMessageDurationAutomatic
           callback:nil
           buttonTitle:nil
           buttonCallback:nil
           atPosition:RMessagePositionNavBarOverlay
           canBeDismissedByUser:YES];
           
           }
         else {
                   [self createTicket];
             
         }
        
    }@catch (NSException *exception)
    {
        // Print exception information
        NSLog( @"NSException caught" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        return;
    }
    @finally
    {
        // Cleanup, in both success and fail cases
        NSLog( @"In finally block");
        
    }
}


-(void)createTicket{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        //[utils showAlertWithMessage:NO_INTERNET sendViewController:self];
        [RKDropdownAlert title:APP_NAME message:NO_INTERNET backgroundColor:[UIColor hx_colorWithHexRGBAString:FAILURE_COLOR] textColor:[UIColor whiteColor]];
        
    }else{
        
        [[AppDelegate sharedAppdelegate] showProgressView];
        
        
        NSString *code=@"";
        if(_codeTextField.text.length>0){
            code=[_codeTextField.text substringFromIndex:1];
        }
        
//        NSString *staffID= [NSString stringWithFormat:@"%@",staff_id];
//
//        if([staffID isEqualToString:@"(null)"])
//        {
//
//            staffID=@"";
//        }
  
        NSString *url=[NSString stringWithFormat:@"%@helpdesk/create?api_key=%@&ip=%@&token=%@&user_id=%@&subject=%@&body=%@&first_name=%@&last_name=%@&phone=%@&code=%@&email=%@&helptopic=%@&priority=%@&sla=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"],[userDefaults objectForKey:@"user_id"],_subjectView.text,_textViewMsg.text,_firstNameView.text,_lastNameView.text,_mobileView.text,code,_emailTextView.text,help_topic_id,priority_id,sla_id];
        
//        NSString *url=[NSString stringWithFormat:@"%@helpdesk/create?api_key=%@&token=%@&subject=%@&body=%@&first_name=%@&last_name=%@&mobile=%@&code=%@&email=%@&helptopic=%@&priority=%@&user_id=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,[userDefaults objectForKey:@"token"],_subjectView.text,_textViewMsg.text,_firstNameView.text,_lastNameView.text,_mobileView.text,code,_emailTextView.text,help_topic_id,priority_id,globalVariables.iD];
        
        @try{
            MyWebservices *webservices=[MyWebservices sharedInstance];
            
            [webservices httpResponsePOST:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
                [[AppDelegate sharedAppdelegate] hideProgressView];
                
                if (error || [msg containsString:@"Error"]) {
                    
                    if (msg) {
                        if([msg isEqualToString:@"Error-403"])
                        {
                            [utils showAlertWithMessage:NSLocalizedString(@"Access Denied - You don't have permission.", nil) sendViewController:self];
                        }else{
                            [utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                            NSLog(@"Error is : %@",msg);
                        }
                        
                    }else if(error)  {
                        [utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                        NSLog(@"Thread-NO4-getInbox-Refresh-error == %@",error.localizedDescription);
                    }
                    
                    return ;
                }
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    [self createTicket];
                    NSLog(@"Thread--NO4-call-postCreateTicket");
                    return;
                }
                
                if (json) {
                    NSLog(@"JSON-CreateTicket-%@",json);
                    if ([json objectForKey:@"response"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // [RKDropdownAlert title:APP_NAME message:NSLocalizedString(@"Ticket created successfully!",nil) backgroundColor:[UIColor hx_colorWithHexRGBAString:SUCCESS_COLOR] textColor:[UIColor whiteColor]];
                            
                            if (self.navigationController.navigationBarHidden) {
                                [self.navigationController setNavigationBarHidden:NO];
                            }
                        
                            [RMessage showNotificationInViewController:self.navigationController
                                                                 title:NSLocalizedString(@"Sucess", nil)
                                                              subtitle:NSLocalizedString(@"Ticket created successfully.", nil)
                                                             iconImage:nil
                                                                  type:RMessageTypeSuccess
                                                        customTypeName:nil
                                                              duration:RMessageDurationAutomatic
                                                              callback:nil
                                                           buttonTitle:nil
                                                        buttonCallback:nil
                                                           atPosition:RMessagePositionNavBarOverlay
                                                  canBeDismissedByUser:YES];
                            
                            
                            InboxViewController *inboxVC=[self.storyboard instantiateViewControllerWithIdentifier:@"InboxID"];
                            [self.navigationController pushViewController:inboxVC animated:YES];
                        });
                    }
                }
                NSLog(@"Thread-NO5-postCreateTicket-closed");
                
            }];
        }@catch (NSException *exception)
        {
            //[utils showAlertWithMessage:@"APP IS STOPPED WORKING" sendViewController:self];
            // Print exception information
            NSLog( @"NSException caught in createTicket in CrateTicket ViewController" );
            NSLog( @"Name: %@", exception.name);
            NSLog( @"Reason: %@", exception.reason );
            return;
        }
        @finally
        {
            // Cleanup, in both success and fail cases
            NSLog( @"In finally block");
            
        }
    }
}

- (void)actionPickerCancelled:(id)sender {
    NSLog(@"Delegate has been informed that ActionSheetPicker was cancelled");
}


//- (void)staffWasSelected:(NSNumber *)selectedIndex element:(id)element
//{
//    staff_id=(staff_idArray)[(NSUInteger) [selectedIndex intValue]];
//    self.assignTextField.text = (_staffArray)[(NSUInteger) [selectedIndex intValue]];
//}


- (void)countryCodeWasSelected:(NSNumber *)selectedIndex element:(id)element{
    // self.selectedIndex = [selectedIndex intValue];
    
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    self.codeTextField.text = (_codeArray)[(NSUInteger) [selectedIndex intValue]];
}
- (void)helpTopicWasSelected:(NSNumber *)selectedIndex element:(id)element {
    help_topic_id=(helpTopic_idArray)[(NSUInteger) [selectedIndex intValue]];
    // self.selectedIndex = [selectedIndex intValue];
    self.helpTopicTextField.text = (_helptopicsArray)[(NSUInteger) [selectedIndex intValue]];
}

- (void)slaWasSelected:(NSNumber *)selectedIndex element:(id)element {
    sla_id=(sla_idArray)[(NSUInteger) [selectedIndex intValue]];
    // self.selectedIndex = [selectedIndex intValue];
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    self.slaTextField.text = (_slaPlansArray)[(NSUInteger) [selectedIndex intValue]];
}
//- (void)deptWasSelected:(NSNumber *)selectedIndex element:(id)element {
//    dept_id=(dept_idArray)[(NSUInteger) [selectedIndex intValue]];
//    // self.selectedIndex = [selectedIndex intValue];
//    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
//    self.deptTextField.text = (_deptArray)[(NSUInteger) [selectedIndex intValue]];
//}
- (void)priorityWasSelected:(NSNumber *)selectedIndex element:(id)element {
    
    //Dat *dat=(Dat *)[priDicc1 objectForKey:[NSString stringWithFormat:@"%@", selectedIndex]];
    // NSLog(@"id %@", dat.id1);
    priority_id=(pri_idArray)[(NSUInteger) [selectedIndex intValue]];
    // self.selectedIndex = [selectedIndex intValue];
    self.priorityTextField.text = (_priorityArray)[(NSUInteger) [selectedIndex intValue]];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
   
    
    if (textView == _emailTextView)
    {
        
        //do not allow the first character to be space | do not allow more than one space
        if ([text isEqualToString:@" "]) {
            if (!textView.text.length)
                return NO;
            //                        if ([[textField.text stringByReplacingCharactersInRange:range withString:string] rangeOfString:@"  "].length)
            //                            return NO;
        }
        
        // allow backspace
        if ([textView.text stringByReplacingCharactersInRange:range withString:text].length < textView.text.length) {
            return YES;
        }
        
        // in case you need to limit the max number of characters
        if ([textView.text stringByReplacingCharactersInRange:range withString:text].length > 40) {
            return NO;
        }
        
        // limit the input to only the stuff in this character set, so no emoji or cirylic or any other insane characters
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890@-_. "];
        
        if ([text rangeOfCharacterFromSet:set].location == NSNotFound) {
            return NO;
        }

        
    }else if(textView==_firstNameView || textView==_lastNameView){
        
        //do not allow the first character to be space | do not allow more than one space
        if ([text isEqualToString:@" "]) {
            if (!textView.text.length)
                return NO;
        }
        // allow backspace
        if ([textView.text stringByReplacingCharactersInRange:range withString:text].length < textView.text.length) {
            return YES;
        }
        
        if (textView==_firstNameView || textView==_lastNameView) {
            // limit the input to only the stuff in this character set, so no emoji or cirylic or any other insane characters
            
            //        // in case you need to limit the max number of characters
            if ([textView.text stringByReplacingCharactersInRange:range withString:text].length > 15) {
                return NO;
            }
            
            NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.-_"];
            
            if ([text rangeOfCharacterFromSet:set].location == NSNotFound) {
                return NO;
            }
        }
        
    } else  if (textView == _mobileView) {
        
        //do not allow the first character to be space | do not allow more than one space
        if ([text isEqualToString:@" "]) {
            if (!textView.text.length)
                return NO;
            //                        if ([[textField.text stringByReplacingCharactersInRange:range withString:string] rangeOfString:@"  "].length)
            //                            return NO;
        }
        
        // allow backspace
        if ([textView.text stringByReplacingCharactersInRange:range withString:text].length < textView.text.length) {
            return YES;
        }
        
        // in case you need to limit the max number of characters
        if ([textView.text stringByReplacingCharactersInRange:range withString:text].length > 15) {
            return NO;
        }
        
        // limit the input to only the stuff in this character set, so no emoji or cirylic or any other insane characters
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
        
        if ([text rangeOfCharacterFromSet:set].location == NSNotFound) {
            return NO;
        }
        
    } else if(textView == _subjectView)
    {
        
        if([text isEqualToString:@" "])
        {
            if(!textView.text.length)
            {
                return NO;
            }
        }
        
        if([textView.text stringByReplacingCharactersInRange:range withString:text].length < textView.text.length)
        {
            
            return  YES;
        }
        
        if([textView.text stringByReplacingCharactersInRange:range withString:text].length >100)
        {
            return NO;
        }
        
        NSCharacterSet *set=[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.-_/';;:?()*&%, "];
        
        
        if([text rangeOfCharacterFromSet:set].location == NSNotFound)
        {
            return NO;
        }
    }
    
    else if(textView == _textViewMsg)
    {
        
        if([text isEqualToString:@" "])
        {
            if(!textView.text.length)
            {
                return NO;
            }
        }
        
        if([textView.text stringByReplacingCharactersInRange:range withString:text].length < textView.text.length)
        {
            
            return  YES;
        }
        
        if([textView.text stringByReplacingCharactersInRange:range withString:text].length >100)
        {
            return NO;
        }
        
        NSCharacterSet *set=[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.=-_';;:?()*&%, "];
        
        
        if([text rangeOfCharacterFromSet:set].location == NSNotFound)
        {
            return NO;
        }
    }
    
    
    return YES;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}




- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}


-(void)split{
    
    _countryDic = @{
                    @"Canada"                                       : @"+1",
                    @"China"                                        : @"+86",
                    @"France"                                       : @"+33",
                    @"Germany"                                      : @"+49",
                    @"India"                                        : @"+91",
                    @"Japan"                                        : @"+81",
                    @"Pakistan"                                     : @"+92",
                    @"United Kingdom"                               : @"+44",
                    @"United States"                                : @"+1",
                    @"Abkhazia"                                     : @"+7 840",
                    @"Abkhazia"                                     : @"+7 940",
                    @"Afghanistan"                                  : @"+93",
                    @"Albania"                                      : @"+355",
                    @"Algeria"                                      : @"+213",
                    @"American Samoa"                               : @"+1 684",
                    @"Andorra"                                      : @"+376",
                    @"Angola"                                       : @"+244",
                    @"Anguilla"                                     : @"+1 264",
                    @"Antigua and Barbuda"                          : @"+1 268",
                    @"Argentina"                                    : @"+54",
                    @"Armenia"                                      : @"+374",
                    @"Aruba"                                        : @"+297",
                    @"Ascension"                                    : @"+247",
                    @"Australia"                                    : @"+61",
                    @"Australian External Territories"              : @"+672",
                    @"Austria"                                      : @"+43",
                    @"Azerbaijan"                                   : @"+994",
                    @"Bahamas"                                      : @"+1 242",
                    @"Bahrain"                                      : @"+973",
                    @"Bangladesh"                                   : @"+880",
                    @"Barbados"                                     : @"+1 246",
                    @"Barbuda"                                      : @"+1 268",
                    @"Belarus"                                      : @"+375",
                    @"Belgium"                                      : @"+32",
                    @"Belize"                                       : @"+501",
                    @"Benin"                                        : @"+229",
                    @"Bermuda"                                      : @"+1 441",
                    @"Bhutan"                                       : @"+975",
                    @"Bolivia"                                      : @"+591",
                    @"Bosnia and Herzegovina"                       : @"+387",
                    @"Botswana"                                     : @"+267",
                    @"Brazil"                                       : @"+55",
                    @"British Indian Ocean Territory"               : @"+246",
                    @"British Virgin Islands"                       : @"+1 284",
                    @"Brunei"                                       : @"+673",
                    @"Bulgaria"                                     : @"+359",
                    @"Burkina Faso"                                 : @"+226",
                    @"Burundi"                                      : @"+257",
                    @"Cambodia"                                     : @"+855",
                    @"Cameroon"                                     : @"+237",
                    @"Canada"                                       : @"+1",
                    @"Cape Verde"                                   : @"+238",
                    @"Cayman Islands"                               : @"+ 345",
                    @"Central African Republic"                     : @"+236",
                    @"Chad"                                         : @"+235",
                    @"Chile"                                        : @"+56",
                    @"China"                                        : @"+86",
                    @"Christmas Island"                             : @"+61",
                    @"Cocos-Keeling Islands"                        : @"+61",
                    @"Colombia"                                     : @"+57",
                    @"Comoros"                                      : @"+269",
                    @"Congo"                                        : @"+242",
                    @"Congo, Dem. Rep. of (Zaire)"                  : @"+243",
                    @"Cook Islands"                                 : @"+682",
                    @"Costa Rica"                                   : @"+506",
                    @"Ivory Coast"                                  : @"+225",
                    @"Croatia"                                      : @"+385",
                    @"Cuba"                                         : @"+53",
                    @"Curacao"                                      : @"+599",
                    @"Cyprus"                                       : @"+537",
                    @"Czech Republic"                               : @"+420",
                    @"Denmark"                                      : @"+45",
                    @"Diego Garcia"                                 : @"+246",
                    @"Djibouti"                                     : @"+253",
                    @"Dominica"                                     : @"+1 767",
                    @"Dominican Republic"                           : @"+1 809",
                    @"Dominican Republic"                           : @"+1 829",
                    @"Dominican Republic"                           : @"+1 849",
                    @"East Timor"                                   : @"+670",
                    @"Easter Island"                                : @"+56",
                    @"Ecuador"                                      : @"+593",
                    @"Egypt"                                        : @"+20",
                    @"El Salvador"                                  : @"+503",
                    @"Equatorial Guinea"                            : @"+240",
                    @"Eritrea"                                      : @"+291",
                    @"Estonia"                                      : @"+372",
                    @"Ethiopia"                                     : @"+251",
                    @"Falkland Islands"                             : @"+500",
                    @"Faroe Islands"                                : @"+298",
                    @"Fiji"                                         : @"+679",
                    @"Finland"                                      : @"+358",
                    @"France"                                       : @"+33",
                    @"French Antilles"                              : @"+596",
                    @"French Guiana"                                : @"+594",
                    @"French Polynesia"                             : @"+689",
                    @"Gabon"                                        : @"+241",
                    @"Gambia"                                       : @"+220",
                    @"Georgia"                                      : @"+995",
                    @"Germany"                                      : @"+49",
                    @"Ghana"                                        : @"+233",
                    @"Gibraltar"                                    : @"+350",
                    @"Greece"                                       : @"+30",
                    @"Greenland"                                    : @"+299",
                    @"Grenada"                                      : @"+1 473",
                    @"Guadeloupe"                                   : @"+590",
                    @"Guam"                                         : @"+1 671",
                    @"Guatemala"                                    : @"+502",
                    @"Guinea"                                       : @"+224",
                    @"Guinea-Bissau"                                : @"+245",
                    @"Guyana"                                       : @"+595",
                    @"Haiti"                                        : @"+509",
                    @"Honduras"                                     : @"+504",
                    @"Hong Kong SAR China"                          : @"+852",
                    @"Hungary"                                      : @"+36",
                    @"Iceland"                                      : @"+354",
                    @"India"                                        : @"+91",
                    @"Indonesia"                                    : @"+62",
                    @"Iran"                                         : @"+98",
                    @"Iraq"                                         : @"+964",
                    @"Ireland"                                      : @"+353",
                    @"Israel"                                       : @"+972",
                    @"Italy"                                        : @"+39",
                    @"Jamaica"                                      : @"+1 876",
                    @"Japan"                                        : @"+81",
                    @"Jordan"                                       : @"+962",
                    @"Kazakhstan"                                   : @"+7 7",
                    @"Kenya"                                        : @"+254",
                    @"Kiribati"                                     : @"+686",
                    @"North Korea"                                  : @"+850",
                    @"South Korea"                                  : @"+82",
                    @"Kuwait"                                       : @"+965",
                    @"Kyrgyzstan"                                   : @"+996",
                    @"Laos"                                         : @"+856",
                    @"Latvia"                                       : @"+371",
                    @"Lebanon"                                      : @"+961",
                    @"Lesotho"                                      : @"+266",
                    @"Liberia"                                      : @"+231",
                    @"Libya"                                        : @"+218",
                    @"Liechtenstein"                                : @"+423",
                    @"Lithuania"                                    : @"+370",
                    @"Luxembourg"                                   : @"+352",
                    @"Macau SAR China"                              : @"+853",
                    @"Macedonia"                                    : @"+389",
                    @"Madagascar"                                   : @"+261",
                    @"Malawi"                                       : @"+265",
                    @"Malaysia"                                     : @"+60",
                    @"Maldives"                                     : @"+960",
                    @"Mali"                                         : @"+223",
                    @"Malta"                                        : @"+356",
                    @"Marshall Islands"                             : @"+692",
                    @"Martinique"                                   : @"+596",
                    @"Mauritania"                                   : @"+222",
                    @"Mauritius"                                    : @"+230",
                    @"Mayotte"                                      : @"+262",
                    @"Mexico"                                       : @"+52",
                    @"Micronesia"                                   : @"+691",
                    @"Midway Island"                                : @"+1 808",
                    @"Micronesia"                                   : @"+691",
                    @"Moldova"                                      : @"+373",
                    @"Monaco"                                       : @"+377",
                    @"Mongolia"                                     : @"+976",
                    @"Montenegro"                                   : @"+382",
                    @"Montserrat"                                   : @"+1664",
                    @"Morocco"                                      : @"+212",
                    @"Myanmar"                                      : @"+95",
                    @"Namibia"                                      : @"+264",
                    @"Nauru"                                        : @"+674",
                    @"Nepal"                                        : @"+977",
                    @"Netherlands"                                  : @"+31",
                    @"Netherlands Antilles"                         : @"+599",
                    @"Nevis"                                        : @"+1 869",
                    @"New Caledonia"                                : @"+687",
                    @"New Zealand"                                  : @"+64",
                    @"Nicaragua"                                    : @"+505",
                    @"Niger"                                        : @"+227",
                    @"Nigeria"                                      : @"+234",
                    @"Niue"                                         : @"+683",
                    @"Norfolk Island"                               : @"+672",
                    @"Northern Mariana Islands"                     : @"+1 670",
                    @"Norway"                                       : @"+47",
                    @"Oman"                                         : @"+968",
                    @"Pakistan"                                     : @"+92",
                    @"Palau"                                        : @"+680",
                    @"Palestinian Territory"                        : @"+970",
                    @"Panama"                                       : @"+507",
                    @"Papua New Guinea"                             : @"+675",
                    @"Paraguay"                                     : @"+595",
                    @"Peru"                                         : @"+51",
                    @"Philippines"                                  : @"+63",
                    @"Poland"                                       : @"+48",
                    @"Portugal"                                     : @"+351",
                    @"Puerto Rico"                                  : @"+1 787",
                    @"Puerto Rico"                                  : @"+1 939",
                    @"Qatar"                                        : @"+974",
                    @"Reunion"                                      : @"+262",
                    @"Romania"                                      : @"+40",
                    @"Russia"                                       : @"+7",
                    @"Rwanda"                                       : @"+250",
                    @"Samoa"                                        : @"+685",
                    @"San Marino"                                   : @"+378",
                    @"Saudi Arabia"                                 : @"+966",
                    @"Senegal"                                      : @"+221",
                    @"Serbia"                                       : @"+381",
                    @"Seychelles"                                   : @"+248",
                    @"Sierra Leone"                                 : @"+232",
                    @"Singapore"                                    : @"+65",
                    @"Slovakia"                                     : @"+421",
                    @"Slovenia"                                     : @"+386",
                    @"Solomon Islands"                              : @"+677",
                    @"South Africa"                                 : @"+27",
                    @"South Georgia and the South Sandwich Islands" : @"+500",
                    @"Spain"                                        : @"+34",
                    @"Sri Lanka"                                    : @"+94",
                    @"Sudan"                                        : @"+249",
                    @"Suriname"                                     : @"+597",
                    @"Swaziland"                                    : @"+268",
                    @"Sweden"                                       : @"+46",
                    @"Switzerland"                                  : @"+41",
                    @"Syria"                                        : @"+963",
                    @"Taiwan"                                       : @"+886",
                    @"Tajikistan"                                   : @"+992",
                    @"Tanzania"                                     : @"+255",
                    @"Thailand"                                     : @"+66",
                    @"Timor Leste"                                  : @"+670",
                    @"Togo"                                         : @"+228",
                    @"Tokelau"                                      : @"+690",
                    @"Tonga"                                        : @"+676",
                    @"Trinidad and Tobago"                          : @"+1 868",
                    @"Tunisia"                                      : @"+216",
                    @"Turkey"                                       : @"+90",
                    @"Turkmenistan"                                 : @"+993",
                    @"Turks and Caicos Islands"                     : @"+1 649",
                    @"Tuvalu"                                       : @"+688",
                    @"Uganda"                                       : @"+256",
                    @"Ukraine"                                      : @"+380",
                    @"United Arab Emirates"                         : @"+971",
                    @"United Kingdom"                               : @"+44",
                    @"United States"                                : @"+1",
                    @"Uruguay"                                      : @"+598",
                    @"U.S. Virgin Islands"                          : @"+1 340",
                    @"Uzbekistan"                                   : @"+998",
                    @"Vanuatu"                                      : @"+678",
                    @"Venezuela"                                    : @"+58",
                    @"Vietnam"                                      : @"+84",
                    @"Wake Island"                                  : @"+1 808",
                    @"Wallis and Futuna"                            : @"+681",
                    @"Yemen"                                        : @"+967",
                    @"Zambia"                                       : @"+260",
                    @"Zanzibar"                                     : @"+255",
                    @"Zimbabwe"                                     : @"+263"
                    };
    _countryArray=[_countryDic allKeys];
    _codeArray=[_countryDic allValues];
    NSLog(@"keys %@",[_countryDic allKeys]);
    NSLog(@"values %@",[_countryDic allValues]);
}

- (NSDictionary *)getCountryCodeDictionary {
    // Country code
    
    return [NSDictionary dictionaryWithObjectsAndKeys:@"972", @"IL",
            @"93", @"AF", @"355", @"AL", @"213", @"DZ", @"1", @"AS",
            @"376", @"AD", @"244", @"AO", @"1", @"AI", @"1", @"AG",
            @"54", @"AR", @"374", @"AM", @"297", @"AW", @"61", @"AU",
            @"43", @"AT", @"994", @"AZ", @"1", @"BS", @"973", @"BH",
            @"880", @"BD", @"1", @"BB", @"375", @"BY", @"32", @"BE",
            @"501", @"BZ", @"229", @"BJ", @"1", @"BM", @"975", @"BT",
            @"387", @"BA", @"267", @"BW", @"55", @"BR", @"246", @"IO",
            @"359", @"BG", @"226", @"BF", @"257", @"BI", @"855", @"KH",
            @"237", @"CM", @"1", @"CA", @"238", @"CV", @"345", @"KY",
            @"236", @"CF", @"235", @"TD", @"56", @"CL", @"86", @"CN",
            @"61", @"CX", @"57", @"CO", @"269", @"KM", @"242", @"CG",
            @"682", @"CK", @"506", @"CR", @"385", @"HR", @"53", @"CU",
            @"537", @"CY", @"420", @"CZ", @"45", @"DK", @"253", @"DJ",
            @"1", @"DM", @"1", @"DO", @"593", @"EC", @"20", @"EG",
            @"503", @"SV", @"240", @"GQ", @"291", @"ER", @"372", @"EE",
            @"251", @"ET", @"298", @"FO", @"679", @"FJ", @"358", @"FI",
            @"33", @"FR", @"594", @"GF", @"689", @"PF", @"241", @"GA",
            @"220", @"GM", @"995", @"GE", @"49", @"DE", @"233", @"GH",
            @"350", @"GI", @"30", @"GR", @"299", @"GL", @"1", @"GD",
            @"590", @"GP", @"1", @"GU", @"502", @"GT", @"224", @"GN",
            @"245", @"GW", @"595", @"GY", @"509", @"HT", @"504", @"HN",
            @"36", @"HU", @"354", @"IS", @"91", @"IN", @"62", @"ID",
            @"964", @"IQ", @"353", @"IE", @"972", @"IL", @"39", @"IT",
            @"1", @"JM", @"81", @"JP", @"962", @"JO", @"77", @"KZ",
            @"254", @"KE", @"686", @"KI", @"965", @"KW", @"996", @"KG",
            @"371", @"LV", @"961", @"LB", @"266", @"LS", @"231", @"LR",
            @"423", @"LI", @"370", @"LT", @"352", @"LU", @"261", @"MG",
            @"265", @"MW", @"60", @"MY", @"960", @"MV", @"223", @"ML",
            @"356", @"MT", @"692", @"MH", @"596", @"MQ", @"222", @"MR",
            @"230", @"MU", @"262", @"YT", @"52", @"MX", @"377", @"MC",
            @"976", @"MN", @"382", @"ME", @"1", @"MS", @"212", @"MA",
            @"95", @"MM", @"264", @"NA", @"674", @"NR", @"977", @"NP",
            @"31", @"NL", @"599", @"AN", @"687", @"NC", @"64", @"NZ",
            @"505", @"NI", @"227", @"NE", @"234", @"NG", @"683", @"NU",
            @"672", @"NF", @"1", @"MP", @"47", @"NO", @"968", @"OM",
            @"92", @"PK", @"680", @"PW", @"507", @"PA", @"675", @"PG",
            @"595", @"PY", @"51", @"PE", @"63", @"PH", @"48", @"PL",
            @"351", @"PT", @"1", @"PR", @"974", @"QA", @"40", @"RO",
            @"250", @"RW", @"685", @"WS", @"378", @"SM", @"966", @"SA",
            @"221", @"SN", @"381", @"RS", @"248", @"SC", @"232", @"SL",
            @"65", @"SG", @"421", @"SK", @"386", @"SI", @"677", @"SB",
            @"27", @"ZA", @"500", @"GS", @"34", @"ES", @"94", @"LK",
            @"249", @"SD", @"597", @"SR", @"268", @"SZ", @"46", @"SE",
            @"41", @"CH", @"992", @"TJ", @"66", @"TH", @"228", @"TG",
            @"690", @"TK", @"676", @"TO", @"1", @"TT", @"216", @"TN",
            @"90", @"TR", @"993", @"TM", @"1", @"TC", @"688", @"TV",
            @"256", @"UG", @"380", @"UA", @"971", @"AE", @"44", @"GB",
            @"1", @"US", @"598", @"UY", @"998", @"UZ", @"678", @"VU",
            @"681", @"WF", @"967", @"YE", @"260", @"ZM", @"263", @"ZW",
            @"591", @"BO", @"673", @"BN", @"61", @"CC", @"243", @"CD",
            @"225", @"CI", @"500", @"FK", @"44", @"GG", @"379", @"VA",
            @"852", @"HK", @"98", @"IR", @"44", @"IM", @"44", @"JE",
            @"850", @"KP", @"82", @"KR", @"856", @"LA", @"218", @"LY",
            @"853", @"MO", @"389", @"MK", @"691", @"FM", @"373", @"MD",
            @"258", @"MZ", @"970", @"PS", @"872", @"PN", @"262", @"RE",
            @"7", @"RU", @"590", @"BL", @"290", @"SH", @"1", @"KN",
            @"1", @"LC", @"590", @"MF", @"508", @"PM", @"1", @"VC",
            @"239", @"ST", @"252", @"SO", @"47", @"SJ", @"963", @"SY",
            @"886", @"TW", @"255", @"TZ", @"670", @"TL", @"58", @"VE",
            @"84", @"VN", @"1", @"VG", @"1", @"VI", nil];
}


@end

