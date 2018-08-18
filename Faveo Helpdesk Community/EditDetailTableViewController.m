//


#import "EditDetailTableViewController.h"
#import "DetailViewController.h"
#import "ActionSheetStringPicker.h"
#import "HexColors.h"
#import "Utils.h"
#import "AppConstanst.h"
#import "MyWebservices.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "GlobalVariables.h"
#import "RKDropdownAlert.h"
#import "IQKeyboardManager.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "TicketDetailViewController.h"
#import "InboxViewController.h"


@interface EditDetailTableViewController ()<RMessageProtocol>{
    
    Utils *utils;
    NSUserDefaults *userDefaults;
    GlobalVariables *globalVariables;
    
    NSString*statusValue;
    
    NSNumber *sla_id;
//    NSNumber *type_id;
    NSNumber *help_topic_id;
//    NSNumber *dept_id;
    NSNumber *priority_id;
    NSNumber *source_id;
    NSNumber *status_id;
//    NSNumber *staff_id;
    
    
    NSMutableArray * sla_idArray;
 //   NSMutableArray * type_idArray;
 //   NSMutableArray * dept_idArray;
    NSMutableArray * pri_idArray;
    NSMutableArray * helpTopic_idArray;
    NSMutableArray * status_idArray;
    NSMutableArray * source_idArray;
 //   NSMutableArray * staff_idArray;
    
}

@property (nonatomic,retain) UIImageView *imgViewLoading;

- (void)helpTopicWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)slaWasSelected:(NSNumber *)selectedIndex element:(id)element;
//- (void)deptWasSelected:(NSNumber *)selectedIndex element:(id)element;
- (void)priorityWasSelected:(NSNumber *)selectedIndex element:(id)element;
//- (void)staffWasSelected:(NSNumber *)selectedIndex element:(id)element;

- (void)actionPickerCancelled:(id)sender;

@end

@implementation EditDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"Edit Ticket",nil)];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:false];
    sla_id=[[NSNumber alloc]init];
  //  dept_id=[[NSNumber alloc]init];
    help_topic_id=[[NSNumber alloc]init];
    priority_id=[[NSNumber alloc]init];
    source_id=[[NSNumber alloc]init];
    status_id=[[NSNumber alloc]init];
 //   type_id=[[NSNumber alloc]init];
 //   staff_id=[[NSNumber alloc]init];
    
    
    UIToolbar *toolBar= [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *removeBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain  target:self action:@selector(removeKeyBoard)];
    
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolBar setItems:[NSArray arrayWithObjects:space,removeBtn, nil]];
    [self.subjectTextView setInputAccessoryView:toolBar];
    
    _saveButton.backgroundColor=[UIColor hx_colorWithHexRGBAString:@"#00aeef"];
    _imgViewLoading = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 78, 78)];
    _imgViewLoading.image=[UIImage imageNamed:@"loading_imgBlue_78x78"];
    _imgViewLoading.center=CGPointMake(self.view.frame.size.width/2,(self.view.frame.size.height/2)-100);
    [self.view addSubview:_imgViewLoading];
    [self.imgViewLoading.layer addAnimation:[self imageAnimationForEmptyDataSet] forKey:@"transform"];
    
    self.subjectTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.subjectTextView.layer.borderWidth = 0.4;
    self.subjectTextView.layer.cornerRadius = 3;
    
    
    utils=[[Utils alloc]init];
    globalVariables=[GlobalVariables sharedInstance];
    userDefaults=[NSUserDefaults standardUserDefaults];

    statusValue=globalVariables.Ticket_status;
    
    
    [self reload];
    [self readFromPlist];
    
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:true];
}

-(void)removeKeyBoard
{
    [self.subjectTextView resignFirstResponder];
}

-(void)reload{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        [_imgViewLoading setHidden:YES];
        // [_activityIndicatorObject stopAnimating];
        //  [RKDropdownAlert title:APP_NAME message:NO_INTERNET backgroundColor:[UIColor hx_colorWithHexRGBAString:FAILURE_COLOR] textColor:[UIColor whiteColor]];
        
        if (self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO];
        }
        
        [RMessage showNotificationInViewController:self.navigationController
                                             title:NSLocalizedString(@"Error..!", nil)
                                          subtitle:NSLocalizedString(@"There is no Internet Connection...!", nil)
                                         iconImage:nil
                                              type:RMessageTypeError
                                    customTypeName:nil
                                          duration:RMessageDurationAutomatic
                                          callback:nil
                                       buttonTitle:nil
                                    buttonCallback:nil
                                        atPosition:RMessagePositionNavBarOverlay
                              canBeDismissedByUser:YES];
        
        
    }else{
        
        NSString *url=[NSString stringWithFormat:@"%@helpdesk/ticket?api_key=%@&ip=%@&token=%@&ticket_id=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"],globalVariables.iD];
        @try{
            MyWebservices *webservices=[MyWebservices sharedInstance];
            [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
                
                if (error) {
                    
                    [utils showAlertWithMessage:@"Error" sendViewController:self];
                    NSLog(@"Thread-NO4-getDetail-Refresh-error == %@",error.localizedDescription);
                    
                    return ;
                }
                if (error || [msg containsString:@"Error"]) {
                    
                    [self.refreshControl endRefreshing];
                    //[_activityIndicatorObject stopAnimating];
                    [_imgViewLoading setHidden:YES];
                    
                    if (msg) {
                        [utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                        
                    }else if(error)  {
                        [utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                        NSLog(@"Thread-NO4-getInbox-Refresh-error == %@",error.localizedDescription);
                    }
                    
                    return ;
                }
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    [self reload];
                    NSLog(@"Thread--NO4-call-getDetail");
                    return;
                }
                
                if (json) {
                    //NSError *error;
                    
                    NSLog(@"Thread-NO4--getDetailAPI--%@",json);
                    NSDictionary *dic= [json objectForKey:@"result"];
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                          
                            
                            globalVariables.ticket_number=[dic objectForKey:@"ticket_number"];
                            
                    
                            //_subjectTextField.text=[dic objectForKey:@"title"];
                            
                            
                            //______________________________________________________________________________________________________
                            ////////////////for UTF-8 data encoding ///////
                            
                            NSString *encodedString =[dic objectForKey:@"title"];
                            
                            
                            [Utils isEmpty:encodedString];
                            
                            if  ([Utils isEmpty:encodedString]){
                                //_subjectTextField.text =@"No Title";
                                _subjectTextView.text= NSLocalizedString(@"Not Available",nil);
                            }
                            else
                            {
                                
                                NSMutableString *decodedString = [[NSMutableString alloc] init];
                                
                                if ([encodedString hasPrefix:@"=?UTF-8?Q?"] || [encodedString hasSuffix:@"?="])
                                {
                                    NSScanner *scanner = [NSScanner scannerWithString:encodedString];
                                    NSString *buf = nil;
                                    //  NSMutableString *decodedString = [[NSMutableString alloc] init];
                                    
                                    while ([scanner scanString:@"=?UTF-8?Q?" intoString:NULL]
                                           || ([scanner scanUpToString:@"=?UTF-8?Q?" intoString:&buf] && [scanner scanString:@"=?UTF-8?Q?" intoString:NULL])) {
                                        if (buf != nil) {
                                            [decodedString appendString:buf];
                                        }
                                        
                                        buf = nil;
                                        
                                        NSString *encodedRange;
                                        
                                        if (![scanner scanUpToString:@"?=" intoString:&encodedRange]) {
                                            break; // Invalid encoding
                                        }
                                        
                                        [scanner scanString:@"?=" intoString:NULL]; // Skip the terminating "?="
                                        
                                        // Decode the encoded portion (naively using UTF-8 and assuming it really is Q encoded)
                                        // I'm doing this really naively, but it should work
                                        
                                        // Firstly I'm encoding % signs so I can cheat and turn this into a URL-encoded string, which NSString can decode
                                        encodedRange = [encodedRange stringByReplacingOccurrencesOfString:@"%" withString:@"=25"];
                                        
                                        // Turn this into a URL-encoded string
                                        encodedRange = [encodedRange stringByReplacingOccurrencesOfString:@"=" withString:@"%"];
                                        
                                        
                                        // Remove the underscores
                                        encodedRange = [encodedRange stringByReplacingOccurrencesOfString:@"_" withString:@" "];
                                        
                                        // [decodedString appendString:[encodedRange stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                        
                                        NSString *str1= [encodedRange stringByRemovingPercentEncoding];
                                        [decodedString appendString:str1];
                                        
                                        
                                    }
                                    
                                    NSLog(@"Decoded string = %@", decodedString);
                                    
                                    _subjectTextView.text= decodedString;
                                }
                                else{
                                    
                                    _subjectTextView.text= encodedString;
                                    
                                }
                                
                            }
                            ///////////////////////////////////////////////////
                            //____________________________________________________________________________________________________
                            
                            
                            
                            if (([[dic objectForKey:@"sla_name"] isEqual:[NSNull null]] ) || ( [[dic objectForKey:@"sla_name"] length] == 0 )) {
                                _helpTopicTextField.text=@"Nil";
                                
                            }else
                             _slaTextField.text=[dic objectForKey:@"sla_name"];
                            
//                            if (([[dic objectForKey:@"type_name"] isEqual:[NSNull null]] ) || ( [[dic objectForKey:@"type_name"] length] == 0 )) {
//
//                            }else _typeTextField.text=[dic objectForKey:@"type_name"];
//
                            if (([[dic objectForKey:@"helptopic_name"] isEqual:[NSNull null]] ) || ( [[dic objectForKey:@"helptopic_name"] length] == 0 )) {
                                _helpTopicTextField.text=@"Nil";
                                
                            }else _helpTopicTextField.text=[dic objectForKey:@"helptopic_name"];
                            
                            
                            if (([[dic objectForKey:@"source_name"] isEqual:[NSNull null]] ) || ( [[dic objectForKey:@"source_name"] length] == 0 )) {
                                _sourceTextField.text=@"Nil";
                                
                            }else _sourceTextField.text=[dic objectForKey:@"source_name"];
                            
                            if (([[dic objectForKey:@"priority_name"] isEqual:[NSNull null]] ) || ( [[dic objectForKey:@"priority_name"] length] == 0 )) {
                                _priorityTextField.text=@"Nil";
                                
                            }else _priorityTextField.text=[dic objectForKey:@"priority_name"];
                            
                            
//                            if (([[dic objectForKey:@"assignee_email"] isEqual:[NSNull null]] ) || ( [[dic objectForKey:@"assignee_email"] length] == 0 )) {
//                                // _assinTextField.text=NSLocalizedString(@"Not Available",nil);
//                                _assinTextField.text=NSLocalizedString(@"Select Assignee",nil);
//                            }else{
//                                _assinTextField.text= [dic objectForKey:@"assignee_email"];
//                            }
                            
                           
                            [self.refreshControl endRefreshing];
                            [_imgViewLoading setHidden:YES];
                            [self.tableView reloadData];
                            
                        });
                    });
                }
                
                NSLog(@"Thread-NO5-editDetail-closed");
                
            }];
        }@catch (NSException *exception)
        {
            // Print exception information
            NSLog( @"NSException caught in reload method in Detail ViewController\n" );
            NSLog( @"Name: %@", exception.name);
            NSLog( @"Reason: %@", exception.reason );
            return ;
        }
        @finally
        {
            // Cleanup, in both success and fail cases
            NSLog( @"In finally block");
            
        }
        
    }
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
      //  NSDictionary *resultDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        //    NSLog(@"resultDic--%@",resultDic);
        
        NSDictionary *resultDic = globalVariables.dependencyDataDict;

        
      //  NSArray *deptArray=[resultDic objectForKey:@"departments"];
        NSArray *helpTopicArray=[resultDic objectForKey:@"helptopics"];
        NSArray *prioritiesArray=[resultDic objectForKey:@"priorities"];
        NSArray *slaArray=[resultDic objectForKey:@"sla"];
        NSArray *sourcesArray=[resultDic objectForKey:@"sources"];
   //     NSMutableArray *staffsArray=[resultDic objectForKey:@"staffs"];
        NSArray *statusArray=[resultDic objectForKey:@"status"];
   //     NSArray *typeArray=[resultDic objectForKey:@"type"];
        
        //    NSLog(@"resultDic2--%@,%@,%@,%@,%@,%@,%@,%@",deptArray,helpTopicArray,prioritiesArray,slaArray,sourcesArray,staffsArray,statusArray,teamArray);
        
   //     NSMutableArray *deptMU=[[NSMutableArray alloc]init];
        NSMutableArray *slaMU=[[NSMutableArray alloc]init];
        NSMutableArray *helptopicMU=[[NSMutableArray alloc]init];
        NSMutableArray *priMU=[[NSMutableArray alloc]init];
        NSMutableArray *statusMU=[[NSMutableArray alloc]init];
        NSMutableArray *sourceMU=[[NSMutableArray alloc]init];
   //     NSMutableArray *typeMU=[[NSMutableArray alloc]init];
     //   NSMutableArray *staffMU=[[NSMutableArray alloc]init];
        
        
   //     dept_idArray=[[NSMutableArray alloc]init];
        sla_idArray=[[NSMutableArray alloc]init];
        helpTopic_idArray=[[NSMutableArray alloc]init];
        pri_idArray=[[NSMutableArray alloc]init];
        status_idArray=[[NSMutableArray alloc]init];
        source_idArray=[[NSMutableArray alloc]init];
  //      type_idArray=[[NSMutableArray alloc]init];
   //     staff_idArray=[[NSMutableArray alloc]init];
        
        
//        [staffMU insertObject:@"Select Assignee" atIndex:0];
//        [staff_idArray insertObject:@"" atIndex:0];
//
//        for (NSMutableDictionary *dicc in staffsArray) {
//            if ([dicc objectForKey:@"email"]) {
//                [staffMU addObject:[dicc objectForKey:@"email"]];
//                [staff_idArray addObject:[dicc objectForKey:@"id"]];
//            }
//
//        }
        
//        for (NSDictionary *dicc in deptArray) {
//            if ([dicc objectForKey:@"name"]) {
//                [deptMU addObject:[dicc objectForKey:@"name"]];
//                [dept_idArray addObject:[dicc objectForKey:@"id"]];
//            }
//
//        }
        
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
        
//        for (NSDictionary *dicc in typeArray) {
//            if ([dicc objectForKey:@"name"]) {
//                [typeMU addObject:[dicc objectForKey:@"name"]];
//                [type_idArray addObject:[dicc objectForKey:@"id"]];
//            }
//        }
        
        for (NSDictionary *dicc in statusArray) {
            if ([dicc objectForKey:@"name"]) {
                [statusMU addObject:[dicc objectForKey:@"name"]];
                [status_idArray addObject:[dicc objectForKey:@"id"]];
            }
        }

        //getting ststus id
                for (NSDictionary *dic in statusArray)
                {
                    NSString *idOfStatus = dic[@"name"];
        
                    if([idOfStatus isEqual:statusValue])
                    {
                        status_id= dic[@"id"];
        
                        NSLog(@"status id is : %@",status_id);
                    }
                }
        
        
        for (NSDictionary *dicc in sourcesArray) {
            if ([dicc objectForKey:@"name"]) {
                [sourceMU addObject:[dicc objectForKey:@"name"]];
                [source_idArray addObject:[dicc objectForKey:@"id"]];
            }
        }
        
        
        
    //    _deptArray=[deptMU copy];
        _helptopicsArray=[helptopicMU copy];
        _slaPlansArray=[slaMU copy];
        _priorityArray=[priMU copy];
        _statusArray=[statusMU copy];
        _sourceArray=[sourceMU copy];
    //    _typeArray=[typeMU copy];
    //    _assignArray=[staffMU copy];
        
        
      

        
        
    }@catch (NSException *exception)
    {
        // Print exception information
        NSLog( @"NSException caught in read-from-Plist methos in Detail ViewController\n" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        return ;
    }
    @finally
    {
        // Cleanup, in both success and fail cases
        NSLog( @"In finally block");
        
    }
    
}



//- (IBAction)statusClicked:(id)sender {
//    // [_subjectTextField resignFirstResponder];
//    if (!_statusArray||!_statusArray.count) {
//        _statusTextField.text=NSLocalizedString(@"Not Available",nil);
//        status_id=0;
//    }else{
//        [ActionSheetStringPicker showPickerWithTitle:@"Select Status" rows:_statusArray initialSelection:0 target:self successAction:@selector(statusWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
//    }
//}

- (IBAction)slaClicked:(id)sender {
    // [_subjectTextField resignFirstResponder];
    
    if (!_slaPlansArray||!_slaPlansArray.count) {
        _slaTextField.text=NSLocalizedString(@"Not Available",nil);
        sla_id=0;
        
    }else{
        [ActionSheetStringPicker showPickerWithTitle:@"Select SLA" rows:_slaPlansArray initialSelection:0 target:self successAction:@selector(slaWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    }
    
}



//- (IBAction)deptClicked:(id)sender {
//    // [_subjectTextField resignFirstResponder];
//
//    if (!_deptArray||!_deptArray.count) {
//        _deptTextField.text=NSLocalizedString(@"Not Available",nil);
//        dept_id=0;
//    }else{
//        [ActionSheetStringPicker showPickerWithTitle:@"Select Department" rows:_deptArray initialSelection:0 target:self successAction:@selector(deptWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
//    }
//
//}



- (IBAction)priorityClicked:(id)sender {
    
    [self.view endEditing:YES];
    [_priorityTextField resignFirstResponder];
    //[_subjectTextField resignFirstResponder];
    if (!_priorityArray||![_priorityArray count]) {
        _priorityTextField.text=NSLocalizedString(@"Not Available",nil);
        priority_id=0;
        
    }else{
        [ActionSheetStringPicker showPickerWithTitle:@"Select Priority" rows:_priorityArray initialSelection:0 target:self successAction:@selector(priorityWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    }
}

- (IBAction)helpTopicClicked:(id)sender
{
    [self.view endEditing:YES];
    //[_subjectTextField resignFirstResponder];
    [_helpTopicTextField resignFirstResponder];
    if (!_helptopicsArray||!_helptopicsArray.count) {
        _helpTopicTextField.text=NSLocalizedString(@"Not Available",nil);
        help_topic_id=0;
    }else{
        [ActionSheetStringPicker showPickerWithTitle:@"Select Helptopic" rows:_helptopicsArray initialSelection:0 target:self successAction:@selector(helpTopicWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    }
}
- (IBAction)sourceClicked:(id)sender
{
    [self.view endEditing:YES];
    // [_subjectTextField resignFirstResponder];
    [_sourceTextField resignFirstResponder];
    if (!_sourceArray||!_sourceArray.count) {
        _sourceTextField.text=NSLocalizedString(@"Not Available",nil);
        source_id=0;
    }else{
        [ActionSheetStringPicker showPickerWithTitle:@"Select Source" rows:_sourceArray initialSelection:0 target:self successAction:@selector(sourceWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
    }
}
//- (IBAction)typeClicked:(id)sender {
//
//    [self.view endEditing:YES];
//    [_typeTextField resignFirstResponder];
//    if (!_typeArray||![_typeArray count]) {
//        _typeTextField.text=NSLocalizedString(@"Not Available",nil);
//        type_id=0;
//
//    }else{
//        [ActionSheetStringPicker showPickerWithTitle:@"Select Ticket Type" rows:_typeArray initialSelection:0 target:self successAction:@selector(typeWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
//    }
//}

//- (IBAction)assignClicked:(id)sender
//{
//    [self.view endEditing:YES];
//    [_assinTextField resignFirstResponder];
//    if (!_assignArray||!_assignArray.count) {
//        _assinTextField.text=NSLocalizedString(@"Not Available",nil);
//        source_id=0;
//    }else{
//        [ActionSheetStringPicker showPickerWithTitle:@"Select Source" rows:_assignArray initialSelection:0 target:self successAction:@selector(staffWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
//    }
//}

- (IBAction)saveClicked:(id)sender {
    
    
    if (self.subjectTextView.text.length==0) {
        [RKDropdownAlert title:APP_NAME message:NSLocalizedString(@"Please enter SUBJECT",nil) backgroundColor:[UIColor hx_colorWithHexRGBAString:ALERT_COLOR] textColor:[UIColor whiteColor]];
    }else if (self.helpTopicTextField.text.length==0) {
        [RKDropdownAlert title:APP_NAME message:NSLocalizedString(@"Please select HELP-TOPIC",nil) backgroundColor:[UIColor hx_colorWithHexRGBAString:ALERT_COLOR] textColor:[UIColor whiteColor]];
    }else if (self.priorityTextField.text.length==0){
        [RKDropdownAlert title:APP_NAME message:NSLocalizedString(@"Please select PRIORITY" ,nil) backgroundColor:[UIColor hx_colorWithHexRGBAString:ALERT_COLOR] textColor:[UIColor whiteColor]];
    }else  if (self.sourceTextField.text.length==0){
        [RKDropdownAlert title:APP_NAME message:NSLocalizedString(@"Please select SOURCE" ,@"Please select SOURCE") backgroundColor:[UIColor hx_colorWithHexRGBAString:ALERT_COLOR] textColor:[UIColor whiteColor]];
    }
    else  if (self.slaTextField.text.length==0){
        [RKDropdownAlert title:APP_NAME message:NSLocalizedString(@"Please select SLA" ,@"Please select SOURCE") backgroundColor:[UIColor hx_colorWithHexRGBAString:ALERT_COLOR] textColor:[UIColor whiteColor]];
    }
    else  {
        [self save];
    }
    
}




-(void)save{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        
        if (self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO];
        }
        
        [RMessage showNotificationInViewController:self.navigationController
                                             title:NSLocalizedString(@"Error..!", nil)
                                          subtitle:NSLocalizedString(@"There is no Internet Connection...!", nil)
                                         iconImage:nil
                                              type:RMessageTypeError
                                    customTypeName:nil
                                          duration:RMessageDurationAutomatic
                                          callback:nil
                                       buttonTitle:nil
                                    buttonCallback:nil
                                        atPosition:RMessagePositionNavBarOverlay
                              canBeDismissedByUser:YES];
        
    }else{
        
        priority_id=[NSNumber numberWithInteger:1+[_priorityArray indexOfObject:_priorityTextField.text]];
        help_topic_id = [NSNumber numberWithInteger:1+[_helptopicsArray indexOfObject:_helpTopicTextField.text]];
        sla_id = [NSNumber numberWithInteger:1+[_slaPlansArray indexOfObject:_slaTextField.text]];
        source_id = [NSNumber numberWithInteger:1+[_sourceArray indexOfObject:_sourceTextField.text]];
       
        //staff_id = [NSNumber numberWithInteger:1+[_assignArray indexOfObject:_assinTextField.text]];
        
        
        sla_id=[NSNumber numberWithInt:1];
        [[AppDelegate sharedAppdelegate] showProgressView];
        
        
        
        
        NSString *url=[NSString stringWithFormat:@"%@helpdesk/edit?api_key=%@&ip=%@&token=%@&ticket_id=%@&help_topic=%@&ticket_priority=%@&ticket_source=%@&subject=%@&sla_plan=%@&status_id=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"],globalVariables.iD,help_topic_id,priority_id,source_id,_subjectTextView.text,sla_id,status_id];
        
        NSLog(@"URL is : %@",url);
        
        @try{
            MyWebservices *webservices=[MyWebservices sharedInstance];
            
            [webservices httpResponsePOST:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
                [[AppDelegate sharedAppdelegate] hideProgressView];
                
                if (error || [msg containsString:@"Error"]) {
                    
                    if (msg) {
                        
                        if([msg isEqualToString:@"Error-403"])
                        {
                            [utils showAlertWithMessage:NSLocalizedString(@"Access Denied - You don't have permission.", nil) sendViewController:self];
                            [[AppDelegate sharedAppdelegate] hideProgressView];
                        }
                        else{
                            [utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                        }
                        //  NSLog(@"Message is : %@",msg);
                        
                    }else if(error)  {
                        [utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                        NSLog(@"Thread-NO4-getInbox-Refresh-error == %@",error.localizedDescription);
                    }
                    
                    return ;
                }
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    [self save];
                    NSLog(@"Thread--NO4-call-postCreateTicket");
                    return;
                }
                
                if (json) {
                    NSLog(@"JSON-CreateTicket-%@",json);
                    if ([json objectForKey:@"result"]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // [RKDropdownAlert title:APP_NAME message:@"Updated successfully!" backgroundColor:[UIColor hx_colorWithHexRGBAString:SUCCESS_COLOR] textColor:[UIColor whiteColor]];
                            
                            if (self.navigationController.navigationBarHidden) {
                                [self.navigationController setNavigationBarHidden:NO];
                            }
                            
                            [RMessage showNotificationInViewController:self.navigationController
                                                                 title:NSLocalizedString(@"Done!", nil)
                                                              subtitle:NSLocalizedString(@"Updated successfully..!", nil)
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
                            
                            //  TicketDetailViewController *td=[self.storyboard instantiateViewControllerWithIdentifier:@"TicketDetailVCID"];
                            // [self.navigationController pushViewController:td animated:YES];
                            // self.navigationItem.hidesBackButton = YES;
                            
                        });
                    }
                }
                NSLog(@"Thread-NO5-postCreateTicket-closed");
                
            }];
        }@catch (NSException *exception)
        {
            // Print exception information
            NSLog( @"NSException caught in save method in Detail ViewController\n" );
            NSLog( @"Name: %@", exception.name);
            NSLog( @"Reason: %@", exception.reason );
            return ;
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
//
//    self.assinTextField.text = (_assignArray)[(NSUInteger) [selectedIndex intValue]];
//
//}


- (void)sourceWasSelected:(NSNumber *)selectedIndex element:(id)element {
    source_id=(source_idArray)[(NSUInteger) [selectedIndex intValue]];
    // self.selectedIndex = [selectedIndex intValue];
    
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    self.sourceTextField.text = (_sourceArray)[(NSUInteger) [selectedIndex intValue]];
}
//- (void)typeWasSelected:(NSNumber *)selectedIndex element:(id)element {
//    type_id=(type_idArray)[(NSUInteger) [selectedIndex intValue]];
//    // self.selectedIndex = [selectedIndex intValue];
//
//    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
//    self.typeTextField.text = (_typeArray)[(NSUInteger) [selectedIndex intValue]];
//}

//- (void)statusWasSelected:(NSNumber *)selectedIndex element:(id)element {
//    status_id=(status_idArray)[(NSUInteger) [selectedIndex intValue]];
//
//    //self.selectedIndex = [selectedIndex intValue];
//
//    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
//    self.statusTextField.text = (_statusArray)[(NSUInteger) [selectedIndex intValue]];
//}

- (void)helpTopicWasSelected:(NSNumber *)selectedIndex element:(id)element {
    help_topic_id=(helpTopic_idArray)[(NSUInteger) [selectedIndex intValue]];
    // self.selectedIndex = [selectedIndex intValue];
    
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
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
//
//    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
//    self.deptTextField.text = (_deptArray)[(NSUInteger) [selectedIndex intValue]];
//}
- (void)priorityWasSelected:(NSNumber *)selectedIndex element:(id)element {
    priority_id=(pri_idArray)[(NSUInteger) [selectedIndex intValue]];
    
    //self.selectedIndex = [selectedIndex intValue];
    
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    self.priorityTextField.text = (_priorityArray)[(NSUInteger) [selectedIndex intValue]];
}

/*#pragma mark - UITextFieldDelegate
 
 - (void)textFieldDidBeginEditing:(UITextField *)textField {
 
 if (textField.tag==2) {
 
 [_priorityTextField resignFirstResponder];
 _priorityTextField.tintColor = [UIColor clearColor];
 
 if (!_priorityArray||![_priorityArray count]) {
 _priorityTextField.text=NSLocalizedString(@"Not Available",nil);
 priority_id=0;
 
 }else{
 [ActionSheetStringPicker showPickerWithTitle:@"Select Priority" rows:_priorityArray initialSelection:0 target:self successAction:@selector(priorityWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:self.view];
 }
 
 // return NO;
 }else if(textField.tag==3){
 //[_subjectTextField resignFirstResponder];
 [_helpTopicTextField resignFirstResponder];
 _helpTopicTextField.tintColor = [UIColor clearColor];
 
 if (!_helptopicsArray||!_helptopicsArray.count) {
 _helpTopicTextField.text=NSLocalizedString(@"Not Available",nil);
 help_topic_id=0;
 }else{
 [ActionSheetStringPicker showPickerWithTitle:@"Select Helptopic" rows:_helptopicsArray initialSelection:0 target:self successAction:@selector(helpTopicWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:self.view];
 }
 // return NO;
 }else if(textField.tag==4){
 [_sourceTextField resignFirstResponder];
 _sourceTextField.tintColor = [UIColor clearColor];
 
 //[_subjectTextField resignFirstResponder];
 if (!_sourceArray||!_sourceArray.count) {
 _sourceTextField.text=NSLocalizedString(@"Not Available",nil);
 source_id=0;
 }else{
 [ActionSheetStringPicker showPickerWithTitle:@"Select Source" rows:_sourceArray initialSelection:0 target:self successAction:@selector(sourceWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:self.view];
 }
 // return  NO;
 }else if(textField.tag==5){
 [_typeTextField resignFirstResponder];
 _typeTextField.tintColor = [UIColor clearColor];
 
 
 if (!_typeArray||!_typeArray.count) {
 _typeTextField.text=NSLocalizedString(@"Not Available",nil);
 type_id=0;
 }else{
 [ActionSheetStringPicker showPickerWithTitle:@"Select Ticket Type" rows:_typeArray initialSelection:0 target:self successAction:@selector(typeWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:self.view];
 }
 // return  NO;
 }else if(textField.tag==7){
 [_assinTextField resignFirstResponder];
 _assinTextField.tintColor = [UIColor clearColor];
 
 //[_subjectTextField resignFirstResponder];
 if (!_assignArray||!_assignArray.count) {
 _assinTextField.text=NSLocalizedString(@"Not Available",nil);
 staff_id=0;
 }else{
 [ActionSheetStringPicker showPickerWithTitle:@"Select Assignee" rows:_assignArray initialSelection:0 target:self successAction:@selector(staffWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:self.view];
 }
 // return  NO;
 }else{
 
 }
 // return YES;
 }
 */
- (CAAnimation *)imageAnimationForEmptyDataSet{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if(textView == _subjectTextView)
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
        
        NSCharacterSet *set=[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 "];
        
        
        if([text rangeOfCharacterFromSet:set].location == NSNotFound)
        {
            return NO;
        }
    }
    
    
    return YES;
}



@end

